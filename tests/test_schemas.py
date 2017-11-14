"""Container for tests of 2.03 schema compliance."""
import glob
import os
import iati
import lxml
import pytest


@pytest.fixture(scope='module')
def activity_schema():
    """Return the v2.03 IATI Activity Schema.

    Todo:
        Replace current monkeypatch of the default v2.02 schema with a call to `iati.schemas.ActivitySchema('iati-activities-schema.xsd')`
        Requires resolution of issue: https://github.com/IATI/pyIATI/issues/234

    """
    schema = iati.default.activity_schema(version='2.02')
    schema._schema_base_tree = lxml.etree.parse('iati-activities-schema.xsd')
    return schema


def list_xml_files_recursively(directory_path):
    """Return the full filepaths of all XML files within the input directory_path folder.

    Args:
        directory_path (str): A relative path to a directory to recursively find XML files within.

    Returns:
        list of str: Relative paths to all XML files that are contained within the input directory_path folder.

    """
    directory_glob_path = directory_path + '**'
    all_files_in_directory = glob.glob(directory_glob_path, recursive=True)
    return [path for path in all_files_in_directory if path.endswith(".xml")]


def load_as_dataset(filepath):
    """Load a filepath as an iati.Dataset object.

    Args:
        filepath (str): A relative path to an XML file.

    Returns:
        iati.Dataset: Representing the input XML file.

    """
    with open(filepath, 'r') as data:
        xml_str = data.read()

    return iati.Dataset(xml_str)


@pytest.mark.parametrize('filepath', list_xml_files_recursively('tests/activity-tests/should-pass/') +  # Legacy tests
                         list_xml_files_recursively('tests/should-pass/'))  # Tests in new format
def test_pass_files(activity_schema, filepath):
    """Check that all 'should-pass' test files are XML and pass Schema validation."""
    dataset = load_as_dataset(filepath)

    assert iati.validator.is_xml(dataset)
    assert iati.validator.is_iati_xml(dataset, activity_schema)

@pytest.mark.parametrize('filepath', list_xml_files_recursively('tests/activity-tests/should-fail/'))
def test_fail_files(activity_schema, filepath):
    """Check that all legacy 'should-fail' test files are XML but fail Schema validation."""
    dataset = load_as_dataset(filepath)

    assert iati.validator.is_xml(dataset)
    assert not iati.validator.is_iati_xml(dataset, activity_schema)


@pytest.mark.parametrize('filepath', list_xml_files_recursively('tests/should-fail/'))
def test_2_03_fail_files(activity_schema, filepath):
    """Check that all 'should-fail' test files are XML but fail IATI Schema validation for the expected reason.

    The expected reason must be stored in the filename of the test case, according to the pyIATI error name. pyIATI error names can be found at: https://github.com/IATI/pyIATI/blob/master/iati/resources/lib_data/validation_err_codes.yaml

    This error name must be inserted in the filename before the first underscore character. Example filename: err-not-iati-xml-missing-attribute_all-required-attributes-missing.xml

    """
    dataset = load_as_dataset(filepath)

    filename = os.path.split(filepath)[-1]
    filename_no_extension = filename.split('.')[0]
    failure_reason = filename_no_extension.split("_")[0]

    error_log = iati.validator.validate_is_iati_xml(dataset, activity_schema)

    assert iati.validator.is_xml(dataset)
    assert error_log.contains_error_called(failure_reason)
