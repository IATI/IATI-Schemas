#!/bin/bash
########################################################################
# Run complete schema test suite.
########################################################################

declare -A SCHEMAS=( 
	# schema name => test folder 
	["activities"]="activity-tests" 
	["organisations"]="organisation-tests" 
	["registry-record"]="registry-tests" 
)

COLOR_BG=0 # Black
COLOR_FG=7 # White
COLOR_FAIL=1 # Red
COLOR_PASS=2 # Green

count_passed=0
count_failed=0
count_total=0
exitcode=0

function fail {
	((count_failed++))
    tput setaf $COLOR_FAIL
    echo '[FAIL]' $1
    tput setaf $COLOR_FG
}

function pass {
	((count_passed++))
    tput setaf $COLOR_PASS
    echo '[PASS]' $1
    tput setaf $COLOR_FG
}

function run_tests {
	local validation_type=$1 # should-pass or should-fail
	local xsd=$2
	local dir=$3
	for f in $(find "$dir/$validation_type" -name '*.xml' | sort); do
		((count_total++))
	    xmllint -noout --schema $xsd $f >/dev/null 2>&1
	    local valid=$?
	    local test_passed
	    if [ $validation_type == "should-pass" ]; then
	    	test_passed=$[$valid==0]
    	else 
	    	test_passed=$[$valid>0]
    	fi
	    if [ $test_passed == 0 ]; then
	        fail $f
	        exitcode=1
	    else
	        pass $f
	    fi
	done
}

tput setab $COLOR_BG
tput setaf $COLOR_FG

for s in "${!SCHEMAS[@]}"; do
	dir=${SCHEMAS[$s]}
	xsd="../iati-$s-schema.xsd"
	echo "Running $s tests"
	run_tests "should-pass" $xsd $dir
	run_tests "should-fail" $xsd $dir
    echo
done

tput setaf $COLOR_FG;   echo "$count_total tests completed "
tput setaf $COLOR_PASS; echo "$count_passed passed"
tput setaf $COLOR_FAIL; echo "$count_failed failed"
tput setaf $COLOR_FG;   echo $exitcode

exit $exitcode

# end
