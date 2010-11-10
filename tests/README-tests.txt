IATI XML Schema Unit Tests
David Megginson, 2010-11-10
david.megginson@megginson.com


This directory contains unit tests for each of the IATI XML schemas.
Inside each schema-specific directory, there are two subdirectories:

should-fail/
        Invalid XML documents.

should-pass/
        Valid XML documents.

To run the tests, you should be in a Unix-like environment (or
possibly Windows using a Unix shell) and have the xmllint application
installed.  xmllint is available in most Linux distributions, or can
be compiled from source as part of the Gnome XML C Parser and Toolkit
(libxml2), available here:

  http://xmlsoft.org/

To start the tests, type the following in a shell terminal:

  sh ./run-tests

The pass or fail result for each test will appear on the screen. All
tests should pass in each schema release.


Background Note:

IATI schema development follows a test-driven-development practice --
before adding a new feature or fixing a bug, we add a test document
that includes the feature (or triggers the bug), deliberately
introducing a "fail" into the tests.  We then modify the schemas until
all the tests pass again.

__end__
