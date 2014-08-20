#!/bin/bash
########################################################################
# Replace strings in tests.
########################################################################

for f in $(find should-fail -name '*.xml' | sort); do
  sed -i 's/<activity-date type="xx" iso-date="2013-11-27"\/><!-- 1 and only 1-->/<activity-date type="xx" iso-date="2013-11-27"\/><!-- At least 1 -->/' $f
done 

for f in $(find should-pass -name '*.xml' | sort); do
  sed -i 's/<activity-date type="xx" iso-date="2013-11-27"\/><!-- 1 and only 1-->/<activity-date type="xx" iso-date="2013-11-27"\/><!-- At least 1 -->/' $f
done 
