#!/bin/bash
########################################################################
# Run complete schema test suite.
########################################################################

DIRS="activity-tests organisation-tests registry-tests"
exitcode=0

for d in $DIRS; do
    echo $d ...
    $SHELL -c "cd $d && $SHELL run-tests.sh"
    if [ $? = 1 ]; then
       exitcode=1
    fi
    echo $exitcode
    echo
done

echo "[done]"
echo $exitcode
exit $exitcode
# end
