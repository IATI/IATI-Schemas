import pytest
import iati

def test_pass_02_minimal_doc_with_repeated_options():
    """Check that a 'should-pass' test file passes Schema validation.

    Todo:
        Make this test work with a 2.03 activity Schema. Requires that
    """
    # Load the dataset
    with open('tests/activity-tests/should-pass/02-minimal-doc-with-repeated-options.xml', 'r') as data:
        xml_str = data.read()

    dataset = iati.Dataset(xml_str)

    # Load the Schema
    schema = iati.default.activity_schema(version='2.02')

    # Attempt validation
    # Assert:
        # Validation passed
        # Empty errorlog ??
    pass
