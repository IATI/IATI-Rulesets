<?php

/*
// NOTE: This PHP implementation of testing rulesets is INCOMPLETE!
// Unless you specifically want PHP, please look at testrules.py instead.
*/

function print_result($xpath_query, $rule, $case) {
    return array(
       'rule'=>$rule,
       'case'=>$case,
       'context'=>$xpath_query
    );
}

function test_ruleset_dom($rulesets, $doc) {
    $xpath = new DOMXpath($doc);
    $errors = array();
    $rules_total = 0;
    foreach($rulesets as $xpath_query => $rules) {
        foreach($xpath->query($xpath_query) as $element) {
            foreach ($rules as $rule => $rule_data) {
                $cases = $rule_data->cases;
                foreach ($cases as $case) {
                    // Handle case conditions
                    if (isset($case->condition)) {
                        if (!$xpath->evaluate($case->condition, $element)) {
                            continue;
                        }
                    }

                    $rules_total += 1;

                    if (isset($case->paths)) {
                        $nested_matches = array();
                        $path_matches = array();
                        foreach ($case->paths as $path) {
                            $single_path_matches = array(); 
                            foreach($xpath->query($path, $element) as $node) {
                                $single_path_matches[] = $node;
                                $path_matches[] = $node;
                            }
                            $nested_matches[] = $single_path_matches;
                        }
                    }
                    if ($rule == 'no_more_than_one') {
                        if (count($path_matches) > 1)
                            $errors[] = print_result($xpath_query, $rule, $case);
                    }
                    elseif ($rule == 'atleast_one') {
                        if (count($path_matches) < 1)
                            $errors[] = print_result($xpath_query, $rule, $case);
                    }
                    elseif ($rule == 'only_one_of') {
                        $exclude = $case->excluded;
                        if (count(array_intersect($exclude, $path_matches))>0)
                            $errors[] = print_result($xpath_query, $rule, $case); 
                    }
                    elseif ($rule == 'dependent') {
                        $allzero = TRUE;
                        $nonezero = TRUE;
                        foreach($nested_matches as $matches) {
                            if (count($matches) == 0) $nonezero = FALSE;
                            else $allzero = FALSE;
                        }
                        if ((!$allzero) && (!$nonezero)) {
                            $errors[] = print_result($xpath_query, $rule, $case);
                        }
                    }
                    elseif (in_array($rule, array('sum', 'strict_sum'))) {
                        if ($rule == 'strict_sum' || count($path_matches) > 0) {
                            $sum = 0.0;
                            foreach ($path_matches as $path_match) {
                                $sum += $path_match->textContent;
                            }
                            if ($sum != $case->sum) {
                                $errors[] = print_result($xpath_query, $rule, $case);
                            }
                        }
                    }
                    elseif ($rule == 'date_order') {
                        $less_item = $xpath->query($case->less, $element)->item(0);
                        if (!$less_item) continue;
                        $less = $less_item->value;
                        $more_item = $xpath->query($case->more, $element)->item(0);
                        if (!$more_item) continue;
                        $more = $more_item->value;
                        // FIXME
                        // Should probably check that it's an ISO date, as this behaviour differs from
                        // the python implementation (and breaks for the year 10000)
                        if ($less > $more) {
                            $errors[] = print_result($xpath_query, $rule, $case);
                        }

                    }
                    elseif ($rule == 'time_limit') {
                        $start_item = $xpath->query($case->start, $element)->item(0);
                        if (!$start_item) continue;
                        $start = new DateTime($start_item->value);
                        $end_item = $xpath->query($case->end, $element)->item(0);
                        if (!$end_item) continue;
                        $end = new DateTime($end_item->value);
                        $date_diff = $start->diff($end);
                        if ($date_diff->y >= 1) {
                          $errors[] = print_result($xpath_query, $rule, $case);
                        }
                    }
                    elseif ($rule == 'date_now') {
                        $update_date = $xpath->query($case->date, $element)->item(0);
                        if (!$update_date) continue;
                        $update = $update_date->value;
                        $current = date("Y-m-d\TH:i:s");
                        if ($update > $current){
                            $errors[] = print_result($xpath_query, $rule, $case);
                        }
                    }
                    elseif ($rule == 'regex_matches' || $rule == 'regex_no_matches') {
                        foreach($path_matches as $path_match) {
                            $matches = preg_match('/'.$case->regex.'/', $path_match->nodeValue);
                            if (!$matches && $rule == 'regex_matches')
                                $errors[] = print_result($xpath_query, $rule, $case);
                            if ($matches && $rule == 'regex_no_matches')
                                $errors[] = print_result($xpath_query, $rule, $case);
                        }

                    }
                    elseif ($rule == 'startswith') {
                        $start = $xpath->query($case->start, $element)->item(0)->textContent;
                        foreach($path_matches as $path_match) {
                            if (strpos($path_match->nodeValue, $start) !== 0) {
                                $errors[] = print_result($xpath_query, $rule, $case);
                            }
                        }
                    }
                    elseif ($rule == 'unique') {
                        $values = array();
                        foreach ($path_matches as $path_match) {
                            if (in_array($path_match->textContent, $values)) {
                                $errors[] = print_result($xpath_query, $rule, $case);
                                break;
                            }
                            $values[] = $path_match->textContent;
                        }
                    }
                    elseif ($rule == 'loop') {
                        $do_copy = $case->do;
                        foreach ($xpath->query($case->foreach, $element) as $replacement_el) {
                            $replacement_value = $replacement_el->value;
                            $subrule_data = json_decode(str_replace('$1', $replacement_value, json_encode($do_copy)));
                            $sub_ruleset = array($xpath_query => $subrule_data);
                            $result = test_ruleset_dom($sub_ruleset, $doc);
                            $errors = $errors + $result['errors'];
                            $rules_total = $rules_total + $result['rules_total'];
                        }
                    }
                }
            }
        }
    }
    return array(
        'errors' => $errors,
        'rules_total' => $rules_total,
        'rules_failed' => count($errors)
    );
}

function test_ruleset($ruleset, $filename, $verbose=false) {
    $rulesets = json_decode(file_get_contents($ruleset));

    $reader = new XMLReader();
    $reader->open($filename);


    while ($reader->read() && $reader->name !== 'iati-activity');

    $error_count = 0;

    while ($reader->name === 'iati-activity')
    {
        $doc = new DOMDocument;
        $doc->loadXML("<iati-activities></iati-activities>");
        $dom = $doc->importNode($reader->expand(), true);
        $doc->documentElement->appendChild($dom);
        $result = test_ruleset_dom($rulesets, $doc);
        $errors = $result['errors'];
        if ($verbose) print_r($errors);

        $error_count += count($errors);

        $reader->next('iati-activity');
    }
    return ($error_count == 0);
}

if (isset($argv[0]) && realpath($argv[0]) == realpath(__FILE__)) {
    if (count($argv) < 3) {
        echo 'Usage php testrules.php rulesets/standard.json file.xml';
        exit();
    }
    else {
        if (count($argv) > 3 && $argv[3] == '--no-breakdown') $breakdown = false;
        else $breakdown = true;
        $result = test_ruleset($argv[1], $argv[2], $breakdown);
        if (!$breakdown) {
            if ($result) echo "True\n";
            else echo "False\n";
        }
    }
}
