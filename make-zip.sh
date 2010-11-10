#!/bin/sh
########################################################################
# Package up a new IATI schema distribution.
########################################################################

SOURCE=/home/david/Documents/Work/IATI/Schemas
TARGET=iati-schemas-dist-`date +%Y%m%d`

cd $SOURCE

rm -rf $TARGET
mkdir $TARGET
cp README.txt CHANGES.txt *.xsd $TARGET

cp -av tests $TARGET
find $TARGET -name '*~' | xargs rm -fv
find $TARGET -name '.svn' | xargs rm -rf

rm -rf $TARGET.zip
zip -9vr $TARGET.zip $TARGET
rm -rf $TARGET

# end