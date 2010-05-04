#!/bin/sh

IATI_SCHEMA=iati-activities-schema.xsd

xmllint --noout --schema $IATI_SCHEMA $*