#!/bin/bash
tester=$@
function test() {
    result=`$tester meta_tests/${1}.json meta_tests/${2}.xml --no-breakdown`
    if [ $result = $3 ]; then echo -n .
    else
        echo
        echo Fail: test $1 $2 $3 
    fi
}

test empty empty True
test title_exists empty True
test title_exists empty_activity False
test title_exists title True
test title_text_exists title False
test title_text_exists title_text True
test no_paths empty True
test no_paths empty_activity False

# End with a newline
echo

