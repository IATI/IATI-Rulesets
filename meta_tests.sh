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

test results_references results_refs_good True
test results_references results_refs_bad False

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

test no_percent no_percent_good True
test no_percent no_percent_bad False

test evaluates_to_true evaluates_to_true_good True
test evaluates_to_true evaluates_to_true_bad False

test if_then if_then_good True
test if_then if_then_bad False

# Test conditions
test condition empty_activity True
test condition activity_status_2 True
test condition activity_status_3 False

test result_indicator_baseline_selector_with_conditions results_indicator_baseline_value_good True
test result_indicator_baseline_selector_with_conditions results_indicator_baseline_value_bad False
test result_indicator_baseline_selector_with_conditions results_indicator_baseline_value_not_relevant True

test result_indicator_period_target_selector_with_conditions results_indicator_period_target_value_good True
test result_indicator_period_target_selector_with_conditions results_indicator_period_target_value_bad False
test result_indicator_period_target_selector_with_conditions results_indicator_period_target_value_not_relevant True

test result_indicator_period_actual_selector_with_conditions results_indicator_period_actual_value_good True
test result_indicator_period_actual_selector_with_conditions results_indicator_period_actual_value_bad False
test result_indicator_period_actual_selector_with_conditions results_indicator_period_actual_value_not_relevant True


test only_one_of only_one_of_activity_bad False
test only_one_of only_one_of_activity_good True
test only_one_of only_one_of_transaction_bad False
test only_one_of only_one_of_transaction_good True

test period_time period_time_good True
test period_time period_time_bad False
test time_limit time_limit_good True
test time_limit time_limit_bad False

test date_now date_now_good True
test date_now date_now_bad False

test at_least_one at_least_one_bad False
test at_least_one at_least_one_ref True
test at_least_one at_least_one_narrative True

test one_or_all one_or_all_lang_bad False
test one_or_all one_or_all_lang_good True
test one_or_all one_or_all_lang_bad_all False
test one_or_all one_or_all_lang_good_all True
test one_or_all one_or_all_sector_bad False
test one_or_all one_or_all_sector_good True
test one_or_all one_or_all_sector_all_good True
test one_or_all one_or_all_sector_all_bad False
test one_or_all one_or_all_currency_bad False
test one_or_all one_or_all_currency_good True
test one_or_all one_or_all_currency_all_bad False
test one_or_all one_or_all_currency_all_good True
test one_or_all_org one_or_all_org_currency_good True
test one_or_all_org one_or_all_org_currency_bad False

test between_dates between_dates_good True
test between_dates between_dates_bad False

test recipient_region_budget recipient_region_budget_good True
test recipient_region_budget recipient_region_budget_bad False

test total_expenditure total_expenditure_good True
test total_expenditure total_expenditure_bad False

test status_date status_date_good True
test status_date status_date_bad False

test range range_good True
test range range_bad False

# End with a newline
echo

if [ $exitcode = 0 ]; then
    echo "Success: All tests passed."
fi

exit $exitcode
