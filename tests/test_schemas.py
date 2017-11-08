"""Container for tests of 2.03 schema compliance."""
import os
import pytest
import iati

def get_filepaths_in_folder():
    """Return the full filepaths of files within the 'should-pass' folder.

    Returns:
        list of str: Filepaths within the 'should-pass' folder.
    """
    directory_name = 'tests/activity-tests/should-pass'
    files = [path for path in os.listdir(directory_name) if path.endswith(".xml")]
    for filename in files:
        yield os.path.join(directory_name, filename)

@pytest.mark.parametrize('filepath', get_filepaths_in_folder())
def test_pass_files(filepath):
    """Check that a 'should-pass' test file passes Schema validation.

    Todo:
        Make this test work with a 2.03 activity Schema. Requires that pyIATI support version 2.03.

    """
    # Load the dataset
    with open(filepath, 'r') as data:
        xml_str = data.read()

    dataset = iati.Dataset(xml_str)

    # Load the Schema
    schema = iati.default.activity_schema(version='2.02')

    # Attempt validation and assert valid
    assert iati.validator.is_xml(dataset)
    assert iati.validator.is_iati_xml(dataset, schema)
