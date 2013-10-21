<?php

function print_result($rule, $case) {
    echo $rule."\n";
    print_r($case);
    echo "\n";
}

if (count($argv) < 3) {
    echo 'Usage php testrules.php rulesets.json file.xml';
    exit();
}

$rulesets = json_decode(file_get_contents($argv[1]));

$reader = new XMLReader();
$reader->open($argv[2]);


while ($reader->read() && $reader->name !== 'iati-activity');

while ($reader->name === 'iati-activity')
{
    $doc = new DOMDocument;
    $doc->loadXML("<iati-activities></iati-activities>");
    $dom = $doc->importNode($reader->expand(), true);
    $doc->documentElement->appendChild($dom);
    $xpath = new DOMXpath($doc);
    foreach($rulesets as $xpath_query => $rules) {
        foreach($xpath->query($xpath_query) as $element) {
            foreach ($rules as $rule => $rule_data) {
                $cases = $rule_data->cases;
                foreach ($cases as $case) {
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
                    if ($rule == 'only_one') {
                        if (count($path_matches) > 1)
                            print_result($rule, $case);
                    }
                    elseif ($rule == 'atleast_one') {
                        if (count($path_matches) < 1)
                            print_result($rule, $case);
                    }
                    elseif ($rule == 'dependent') {
                        $allzero = TRUE;
                        $nonezero = TRUE;
                        foreach($nested_matches as $matches) {
                            if (count($matches) == 0) $nonezero = FALSE;
                            else $allzero = FALSE;
                        }
                        if ((!$allzero) && (!$nonezero)) {
                            print_result($rule, $case);
                        }
                    }
                    elseif ($rule == 'sum') {
                        /*if (count($path_matches) > 0) {
                            print_r($path_matches);
                        }*/
                        // FIXME
                    }
                    elseif ($rule == 'date_order') {
                        //$start = $xpath->query($case->start, $element)->item(0)->value;
                        // FIXME

                    }
                    elseif ($rule == 'regex_matches' || $rule == 'regex_no_matches') {
                        foreach($path_matches as $path_match) {
                            $matches = preg_match('/'.$case->regex.'/', $path_match->nodeValue);
                            if (!$matches && $rule == 'regex_matches')
                                print_result($rule, $case);
                            if ($matches && $rule == 'regex_no_matches')
                                print_result($rule, $case);
                        }

                    }
                    elseif ($rule == 'startswith') {
                        $start = $xpath->query($case->start, $element)->item(0)->value;
                        foreach($path_matches as $path_match) {
                            if (strpos($start, $path_match->nodeValue) !== 0) {
                                print_result($rule, $case);
                            }
                        }
                    }
                }
            }
        }
    }

    $reader->next('iati-activity');
}
