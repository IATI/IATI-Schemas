International Aid Transparency Initiative (IATI) XML Schemas
============================================================

.. image:: https://travis-ci.org/IATI/IATI-Schemas.svg?branch=version-2.03
    :target: https://travis-ci.org/IATI/IATI-Schemas

| IATI Support <support@iatistandard.org>
| Release 2.03, Unreleased

This directory contains version 2.03 of the IATI XML
schemas, due to be released in early 2018.  More information about these schemas
is available at http://iatistandard.org

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

```
# Create and start a virtual environment
virtualenv -p python3 pyenv
source pyenv/bin/activate

# Install Python package dependencies
pip install -r requirements-dev.txt
```

The tests include a series of short XML documents that should pass or
fail when parsed against the schemas in this distribution.  We use pytest
as a test runner to check the validity of these files against the defined
schema.


Acknowlegements
David Megginson <david.megginson@megginson.com> for his original work on
the IATI Schemas and continued support and involvment.

__end__
