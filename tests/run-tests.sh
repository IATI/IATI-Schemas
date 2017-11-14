#!/bin/bash
########################################################################
# Run complete schema test suite.
########################################################################

DIRS="activity-tests organisation-tests registry-tests"
exitcode=0

for d in $DIRS; do
    echo $d ...
    script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"  # The full path of the directory that this script is in, no matter where it is called from
    test_dir_path=$script_dir/$d  # The full path of the test folder
    $SHELL -c "cd $test_dir_path && $SHELL run-tests.sh"  # Run the test script
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
