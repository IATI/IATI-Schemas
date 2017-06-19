International Aid Transparency Initiative (IATI) XML Schemas
============================================================

.. image:: https://travis-ci.org/IATI/IATI-Schemas.svg?branch=version-2.02
    :target: https://travis-ci.org/IATI/IATI-Schemas

| IATI Support <support@iatistandard.org>
| Release 2.02, 2015-12-07

This directory contains version 2.02 of the IATI XML
schemas, effective 2015-12-07.  More information about these schemas
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

The tests include a series of short XML documents that should pass or
fail when parsed against the schemas in this distribution.  The shell
scripts for running the tests rely on a Unix environment with the bash
shell and the xmllint utility, but the test documents will work with
any schema-aware XML parser. We will add unit tests as schema
development continues.

Acknowlegements
David Megginson <david.megginson@megginson.com> for his original work on
the IATI Schemas and continued support and involvment.

__end__
