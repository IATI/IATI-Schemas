#!/bin/bash
########################################################################
# Run complete schema test suite.
########################################################################

DIRS="activity-tests organisation-tests"

for d in $DIRS; do
    echo $d ...
    $SHELL -c "cd $d && $SHELL run-tests.sh"
    echo
done

echo "[done]"

# end
