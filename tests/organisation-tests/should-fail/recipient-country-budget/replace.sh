#!/bin/bash
########################################################################
# Replace strings in tests.
########################################################################

for f in *.xml; do
  sed -i 's/total-budget/recipient-country-budget/' $f
done 


