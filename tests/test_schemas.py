"""Container for tests of 2.03 schema compliance."""
import glob
import os
import iati
import lxml
import pytest


class SchemaFactory(object):
    """Container to instiantiate v2.03 IATI Activity and Organisation schemas and return an appropriate instance based on a filepath.

    Todo:
        Replace current monkeypatch of the default v2.02 activity and organisaion schemas with calls to:
            `iati.ActivitySchema('iati-activities-schema.xsd')`
            `iati.OrganisationSchema('iati-organisations-schema.xsd')`
        Requires resolution of issue: https://github.com/IATI/pyIATI/issues/234
    """

    activity_schema = None
    organisation_schema = None

    def __init__(self):
        """Instiantes the v2.03 IATI Activity and Organisation schemas.

        Sets:
            self.activity_schema - A monkeypatched v2.03 IATI Activity schema.

            self.organisation_schema - A monkeypatched v2.03 IATI Organisation schema.
        """
        self.activity_schema = iati.default.activity_schema(version='2.02')
        self.activity_schema._schema_base_tree = lxml.etree.parse('iati-activities-schema.xsd')

        self.organisation_schema = iati.default.organisation_schema(version='2.02')
        self.organisation_schema._schema_base_tree = lxml.etree.parse('iati-organisations-schema.xsd')

    def get_correct_schema_for_filepath(self, filepath):
        """Return the appropriate schema based on an input test case filepath.

        Args:
            filepath (str): Path to a test case XML file.

        Returns:
            iati.ActivitySchema or iati.OrganisationSchema: Depending on the input filepath.
        """
        if 'activity-tests' in filepath or 'iati-activities' in filepath:
            return self.activity_schema
        elif 'organisation-tests' in filepath or 'iati-organisations' in filepath:
            return self.organisation_schema


@pytest.fixture(scope='module')
def schema_factory():
    return SchemaFactory()


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

    Todo:
        Remove this function and replace calls to this with calls to iati.utilities.load_as_dataset once IATI/pyIATI#23 is finalised and released.

    """
    with open(filepath, 'r') as data:
        xml_str = data.read()

    return iati.Dataset(xml_str)


@pytest.mark.parametrize('filepath', list_xml_files_recursively('tests/activity-tests/should-pass/') +  # Legacy activity test cases
                         list_xml_files_recursively('tests/should-pass/iati-activities/') +  # Activity test cases in 2.03+ format
                         list_xml_files_recursively('tests/organisation-tests/should-pass/') +  # Legacy organisaion test cases
                         list_xml_files_recursively('tests/should-pass/iati-organisations/'))  # Organisation test cases in 2.03+ format
def test_pass_files(schema_factory, filepath):
    """Check that all activity and organisation schema 'should-pass' test files are XML and pass Schema validation."""
    dataset = load_as_dataset(filepath)
    schema = schema_factory.get_correct_schema_for_filepath(filepath)

    assert iati.validator.is_xml(dataset)
    assert iati.validator.is_iati_xml(dataset, schema)


@pytest.mark.parametrize('filepath', list_xml_files_recursively('tests/activity-tests/should-fail/') +
                         list_xml_files_recursively('tests/organisation-tests/should-fail/'))
def test_fail_files(schema_factory, filepath):
    """Check that all legacy activity and organisation 'should-fail' test files are XML but fail Schema validation."""
    dataset = load_as_dataset(filepath)
    schema = schema_factory.get_correct_schema_for_filepath(filepath)

    assert iati.validator.is_xml(dataset)
    assert not iati.validator.is_iati_xml(dataset, schema)


@pytest.mark.parametrize('filepath', list_xml_files_recursively('tests/should-fail/iati-activities/') +
                         list_xml_files_recursively('tests/should-fail/iati-organisations/'))
def test_2_03_fail_files(schema_factory, filepath):
    """Check that all activity and organisation 'should-fail' test files are XML but fail IATI Schema validation for the expected reason.

    The expected reason must be stored in the filename of the test case, according to the pyIATI error name. pyIATI error names can be found at: https://github.com/IATI/pyIATI/blob/master/iati/resources/lib_data/validation_err_codes.yaml

    This error name must be inserted in the filename before the first underscore character. Example filename: err-not-iati-xml-missing-attribute_all-required-attributes-missing.xml

    """
    dataset = load_as_dataset(filepath)
    schema = schema_factory.get_correct_schema_for_filepath(filepath)
    filename = os.path.split(filepath)[-1]
    filename_no_extension = filename.split('.')[0]
    failure_reason = filename_no_extension.split("_")[0]

    error_log = iati.validator.validate_is_iati_xml(dataset, schema)

    assert iati.validator.is_xml(dataset)
    assert error_log.contains_error_called(failure_reason)
