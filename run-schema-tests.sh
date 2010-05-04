#!/bin/sh

IDML_SCHEMA=test-data/IDML2.0.xsd

TEST_FILES="test-data/ocha-test-data.xml
  test-data/worked-example.xml"
TEMP=/tmp/iati-test-output$$

for file in $TEST_FILES; do

  echo "****************************************************************"
  echo "  Testing file $file"
  echo "****************************************************************\n"

  echo "Validating IATI file against schema ..."
  sh ./validate-iati-file.sh $file
  echo "done"

  echo "\nTransforming from IATI to IDML ..."
  sh ./transform-to-idml.sh $file > $TEMP
  echo "done"

  echo "\nValidating IDML output against schema ..."
  xmllint --noout --schema $IDML_SCHEMA $TEMP
  echo "done\n"

  #less $TEMP

rm -f $TEMP

done

