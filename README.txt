IATI schema and support for UN-OCHA to Haiti AMP

David Megginson <david.megginson@megginson.com>
2010-04-27


This archive contains files to support exporting aid data from the
UN-OCHA OPS and FITS databases and transmitting it to the Development
Gateway Haiti AMP.  Note that all files are based on an early draft of
the International Aid Transparency Initiative (IATI) XML schemas,
which are subject to change.

The archive contains the following files:

README.txt                      This file.

CHANGES.txt                     Change log.

iati-projects-schema.xsd        An early draft IATI XML schema for
                                exporting UN-OCHA data.

xml.xsd                         A supplementary schema that must be in
                                the same directory as the above.

iati2idml.xslt                  An XSLT script for converting this
                                early draft version of IATI to the
                                IDML 2.0 used by the Development
                                Gateway Haiti AMP.

run-schema-tests.xml            Shell script to run schema tests on
                                sample data.

test-data/                      Files for test harness (including
                                example files).
