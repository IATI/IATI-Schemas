International Aid Transparency Initiative (IATI)
XML Schemas

David Megginson <david.megginson@megginson.com>
DRAFT Version 1.01, 2010-11-10

This directory contains a draft of version 1.01 of the IATI XML
schemas, effective 2010-11-10.  More information about these schemas
is available at http://iatistandard.org

This directory contains the following files:

README.txt                      This file.

CHANGES.txt                     Change log.

iati-activities-schema.xsd      XML Schema for describing aid activities
                                (e.g. projects).

iati-organization-schema.xsd    XML schema for describing aid
                                organizations and their budgets.

iati-common.xsd                 A supplementary schema with common
                                IATI markup.  Must be in the same
                                directory as the above.

xml.xsd                         A supplementary schema that must be in
                                the same directory as the above.

iati-registry-record-schema.xsd An application-specific extension
                                schema for importing documents into
                                the IATI registry.

tests/                          Unit tests for the schemas.

The tests include a series of short XML documents that should pass or
file when parsed against the schemas in this distribution.  The shell
scripts for running the tests rely on a Unix environment with the bash
shell and the xmllint utility, but the test documents will work with
any schema-aware XML parser. We will add unit tests as schema
development continues.

__end__
