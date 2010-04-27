#!/bin/sh

TEST_FILES=ocha-test-data.xml
TEMP=/tmp/iati-test-output$$

for file in $TEST_FILES; do

  echo "Testing file $file ..."

  echo "Validating IATI file against schema ..."
  xmllint --noout --schema iati-activities-schema.xsd ocha-test-data.xml
  echo "done"

  echo "\nTransforming from IATI to IDML ..."
  xalan -in ocha-test-data.xml -out $TEMP -xsl iati2idml.xslt
  echo "done"

  echo "\nValidating IDML output against schema ..."
  xmllint --noout --schema IDML2.0.xsd $TEMP
  echo "done\n"

  rm -f $TEMP

done

