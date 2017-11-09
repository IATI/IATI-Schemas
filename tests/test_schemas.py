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
        Remove monkeypatch of the v2.02 schema i.e. call with iati.schemas.ActivitySchema('iati-activities-schema.xsd')
        Requires resolution of issue: https://github.com/IATI/pyIATI/issues/234

    """
    schema = iati.default.activity_schema(version='2.02')
    schema._schema_base_tree = lxml.etree.parse('iati-activities-schema.xsd')
    return schema


def get_filepaths_in_folder(directory_path):
    """Return the full filepaths of all xml files within the 'should-pass' folder.

    Args:
        directory_path (str): A relative path to a directory to recursively find XML files within.

    Returns:
        list of str: Filepaths within the 'should-pass' folder.

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


@pytest.mark.parametrize('filepath', get_filepaths_in_folder('tests/activity-tests/should-pass/') + get_filepaths_in_folder('tests/should-pass/'))
def test_pass_files(activity_schema, filepath):
    """Check that all 'should-pass' test files are XML and pass Schema validation."""
    # Load the dataset
    dataset = load_as_dataset(filepath)

    # Attempt validation and assert valid
    assert iati.validator.is_xml(dataset)
    assert iati.validator.is_iati_xml(dataset, activity_schema)

@pytest.mark.parametrize('filepath', get_filepaths_in_folder('tests/activity-tests/should-fail/'))
def test_fail_files(activity_schema, filepath):
    """Check that all 'should-fail' test files are XML but fail Schema validation."""
    # Load the dataset
    dataset = load_as_dataset(filepath)

    # Attempt validation and assert valid
    assert iati.validator.is_xml(dataset)
    assert not iati.validator.is_iati_xml(dataset, activity_schema)


@pytest.mark.parametrize('filepath', get_filepaths_in_folder('tests/should-fail/'))
def test_2_03_fail_files(activity_schema, filepath):
    """Check that all 'should-fail' test files are XML but fail Schema validation for the expected reason."""
    # Load the dataset
    dataset = load_as_dataset(filepath)

    # Get the reason why this test should fail from the filename
    # All filenames contain the pyIATI error name before the first underscore character
    filename = os.path.split(filepath)[-1]
    filename_no_extension = filename.split('.')[0]
    failure_reason = filename_no_extension.split("_")[0]

    # Attempt validation and assert valid
    error_log = iati.validator.validate_is_iati_xml(dataset, activity_schema)

    assert iati.validator.is_xml(dataset)
    assert error_log.contains_error_called(failure_reason)
