#!/bin/bash
tester=$@
exitcode=0
function test() {
    result=`$tester meta_tests/${1}.json meta_tests/${2}.xml --no-breakdown`
    if [ $result = $3 ]; then echo -n .
    else
        echo
        echo Fail: test $1 $2 $3 
        echo $result
        exitcode=1
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

test no_more_than_one_title title True
test no_more_than_one_title empty_activity True
test no_more_than_one_title title_twice False

test dependent_title_description empty_activity True
test dependent_title_description title False
test dependent_title_description description False
test dependent_title_description title_description True

test sum sum_good True
test sum sum_bad False

test sum_two sum_two_good True
test sum_two sum_two_bad False

test date_order empty_activity True
test date_order date_good True
test date_order date_bad False

test regex_matches regex_good True
test regex_matches regex_bad False
test regex_no_matches regex_bad True
test regex_no_matches regex_good False

test starts_with identifiers True
test starts_with identifiers_bad False

test unique unique_good True
test unique unique_bad False
#test unique_title_description title_description False # FIXME
test unique_title_description title_description_content True

# Test conditions
test condition empty_activity True
test condition activity_status_2 True
test condition activity_status_3 False

test only_one_of only_one_of_activity_bad False
test only_one_of only_one_of_activity_good True

test period_time period_time_good True
test period_time period_time_bad False

test date_now date_now_good True
test date_now date_now_bad False

# End with a newline
echo

if [ $exitcode = 0 ]; then
    echo "Success: All tests passed."
fi

exit $exitcode

