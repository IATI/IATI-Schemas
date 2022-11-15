"""Container for tests of 2.03 schema compliance."""
import glob
import os
import re
from lxml import etree
import pytest


class SchemaFactory(object):
    """Container to initialize v2.03 IATI Activity and Organisation schemas and return an appropriate instance based on a filepath.
    """

    activity_schema = None
    organisation_schema = None

    def __init__(self):
        """Instiantes the v2.03 IATI Activity and Organisation schemas.

        Sets:
            self.activity_schema - v2.03 IATI Activity schema.

            self.organisation_schema - v2.03 IATI Organisation schema.
        """
        self.activity_schema  = etree.XMLSchema(etree.parse('iati-activities-schema.xsd'))

        self.organisation_schema = etree.XMLSchema(etree.parse('iati-organisations-schema.xsd'))

    def get_correct_schema_for_filepath(self, filepath):
        """Return the appropriate schema based on an input test case filepath.

        Args:
            filepath (str): Path to a test case XML file.

        Returns:
            ActivitySchema or OrganisationSchema: Depending on the input filepath.
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


def load_as_str(filepath):
    """Load a filepath as an lxml object.

    Args:
        filepath (str): A relative path to an XML file.

    Returns:
        Dataset: Representing the input XML file.

    """
    with open(filepath, 'r') as data:
        xml_str = data.read()

    return xml_str


def is_xml(xml_string):
    try:
        etree.fromstring(xml_string)
        return True
    except etree.XMLSyntaxError:
        return False


def is_iati_xml(xml_string, schema):
    parser = etree.XMLParser(schema = schema)
    try:
        dataset = etree.fromstring(xml_string, parser)
        return True
    except etree.XMLSyntaxError:
        return False



@pytest.mark.parametrize('filepath', list_xml_files_recursively('tests/activity-tests/should-pass/') +  # Legacy activity test cases
                         list_xml_files_recursively('tests/should-pass/iati-activities/') +  # Activity test cases in 2.03+ format
                         list_xml_files_recursively('tests/organisation-tests/should-pass/') +  # Legacy organisaion test cases
                         list_xml_files_recursively('tests/should-pass/iati-organisations/'))  # Organisation test cases in 2.03+ format
def test_pass_files(schema_factory, filepath):
    """Check that all activity and organisation schema 'should-pass' test files are XML and pass Schema validation."""
    data_str = load_as_str(filepath)
    schema = schema_factory.get_correct_schema_for_filepath(filepath)

    assert is_xml(data_str)
    assert is_iati_xml(data_str, schema)


@pytest.mark.parametrize('filepath', list_xml_files_recursively('tests/activity-tests/should-fail/') +
                         list_xml_files_recursively('tests/organisation-tests/should-fail/'))
def test_fail_files(schema_factory, filepath):
    """Check that all legacy activity and organisation 'should-fail' test files are XML but fail Schema validation."""
    data_str = load_as_str(filepath)
    schema = schema_factory.get_correct_schema_for_filepath(filepath)

    assert is_xml(data_str)
    assert not is_iati_xml(data_str, schema)


@pytest.mark.parametrize('filepath', list_xml_files_recursively('tests/should-fail/iati-activities/') +
                         list_xml_files_recursively('tests/should-fail/iati-organisations/'))
def test_2_03_fail_files(schema_factory, filepath):
    """Check that all activity and organisation 'should-fail' test files are XML but fail IATI Schema validation for the expected reason.

    The expected reason must be stored in the filename of the test case, according to the dict below.

    This error name must be inserted in the filename before the first underscore character. Example filename: err-not-iati-xml-missing-attribute_all-required-attributes-missing.xml

    """

    failure_reason_mapping = {
        'err-not-iati-xml-missing-required-element': "Element '[a-z-]*?': ((Missing child element\(s\)\.)|(This element is not expected\.)) Expected is( one of)? \( [#\*a-z-\s,]*? \)\.",
        'err-not-iati-xml-missing-attribute': "Element '[a-z-]*?': The attribute '[a-z-]*?' is required but missing\.",
        'err-not-iati-xml-forbidden-attribute': "Element '[a-z-]*?', attribute '[a-z-]*': The attribute '[a-z-]*?' is not allowed\.",
        'err-not-iati-xml-incorrect-datatype': "Element '[a-z-]*?', attribute '[a-z-]*?': '.*?' is not a valid value of the atomic type '[a-z-:]*?'\."
    }

    data_str = load_as_str(filepath)
    schema = schema_factory.get_correct_schema_for_filepath(filepath)
    filename = os.path.split(filepath)[-1]
    filename_no_extension = filename.split('.')[0]
    failure_reason = filename_no_extension.split("_")[0]

    assert is_xml(data_str)

    parser = etree.XMLParser(schema = schema)
    try:
        dataset = etree.fromstring(data_str, parser)
    except etree.XMLSyntaxError as error_log:
        expected_error_text = failure_reason_mapping[failure_reason]
        if re.search(expected_error_text, str(error_log)) is None:
            assert False