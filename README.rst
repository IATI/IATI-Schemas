International Aid Transparency Initiative (IATI) XML Schemas
============================================================

.. image:: https://github.com/IATI/IATI-Schemas/workflows/CI_Tests/badge.svg
   :target: https://github.com/IATI/IATI-Schemas/actions

| IATI Support <support@iatistandard.org>
| Release 2.03, Unreleased

This directory contains version 2.03 of the IATI XML schemas. More information about these schemas is available at http://iatistandard.org

This directory contains the following files:

=============================== ========================================
File                            Description
=============================== ========================================
README.rst                      This file.

CHANGES.txt                     Change log.

iati-activities-schema.xsd      XML Schema for describing aid activities
                                (e.g. projects).

iati-organisations-schema.xsd   XML schema for describing aid
                                organisations and their budgets.

iati-common.xsd                 A supplementary schema with common
                                IATI markup.  Must be in the same
                                directory as the above.

xml.xsd                         A supplementary schema that must be in
                                the same directory as the above.

iati-registry-record-schema.xsd An application-specific extension
                                schema for importing documents into
                                the IATI registry.

tests/                          Unit tests for the schemas.
=============================== ========================================

Dev Installation
----------------

.. code-block:: bash

  # Create and start a virtual environment
  $ python3 -m venv pyenv
  $ source pyenv/bin/activate

  # Install Python package dependencies
  $ pip install -r requirements-dev.txt


Tests
-----

There are two types of tests:

Legacy tests
~~~~~~~~~~~~

A series of short XML documents are included in the ``tests/**/should-pass``  and ``tests/**/should-fail`` directories (and sub-directories). These files test elements and attributes added pre-version 2.03 and offer a simple pass/fail check when parsed against the schemas in this distribution.

These tests can be run using:

.. code-block:: bash

   $ xmllint --schema http://www.w3.org/2001/XMLSchema.xsd --noout *.xsd
   $ ./tests/run-tests.sh

Tests for elements/attributes added in v2.03
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A new test structure was added at version 2.03, with additional test cases added to ``tests/should-pass`` and ``tests/should-fail`` directories (and sub-directories). Directory structure is based upon the schema. Each element has a folder based on its name and is nested accordingly. Attributes also have folders but their folder names are prepended by an underscore.

All XML test cases in the ``should-fail`` directory are tested to be valid XML but invalid against the distributed IATI schemas.  The expected reason for failure (for example, a missing required attribute) in each test case is asserted.

We use pytest as a test runner to check the validity of these files against the defined schema.

.. code-block:: bash

   $ pytest


Test file naming syntax
~~~~~~~~~~~~~~~~~~~~~~~

`should-fail` test file names should begin with one of the following strings, depending on the expected failure type:
- `err-not-iati-xml-missing-required-element`
- `err-not-iati-xml-missing-attribute`
- `err-not-iati-xml-forbidden-attribute`
- `err-not-iati-xml-incorrect-datatype`

Additional test descriptions may be added to the file name following an underscore, like so:
`err-not-iati-xml-missing-required-element_document-link-with-multiple-description-elements.xml`

The files are now parsed with `etree.fromstring`.
If an XMLSchemaError is raised during the parsing, the beginning of the file name is compared against Regex for the four possible error types above.
For example, the error raised from `err-not-iati-xml-missing-required-element_document-link-with-multiple-description-elements.xml` is expected to match the Regex:
`Element '[a-z-]*?': ((Missing child element\(s\)\.)|(This element is not expected\.)) Expected is( one of)? \( [#\*a-z-\s,]*? \)\.`


Acknowlegements
---------------

David Megginson <david.megginson@megginson.com> for his original work on the IATI Schemas and continued support and involvement.
