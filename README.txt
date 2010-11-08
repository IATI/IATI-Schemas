International Aid Transparency Initiative
XML Activity and Organization Schemas

David Megginson <david.megginson@megginson.com>
DRAFT 2010-11-08

This directory contains a draft of the IATI activities and
organization schemas effective 2010-11-08.  These schemas are not yet
finalized, but are in use in several field trials.

The directory contains the following files:

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

tests/                          Unit tests for the schemas.

The tests include a series of short XML documents that should pass or
file when parsed against the schemas in this distribution.  The shell
scripts for running the tests rely on a Unix environment with the bash
shell and the xmllint utility, but the test documents will work with
any schema-aware XML parser. We will add unit tests as schema
development continues.

The XSLT script for converting IATI to IDML markup is no longer
bundled with the distribution.  It was originally provided as a
starting point for a specific organization working with the trials,
but the organization has since made its own changes to the script and
taken over responsibility for it.


__end__
