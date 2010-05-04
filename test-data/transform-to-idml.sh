#!/bin/sh

for file in $*; do
    xalan -in $file -xsl iati2idml.xslt | xmllint -format -
done

