import json
import sys
import re
from lxml import etree as ET

rulesets = json.load(open('rulesets.json'))

if len(sys.argv) < 2:
    print('Usage python testrules.py file.xml')
    exit()

tree = ET.parse(sys.argv[1])
root = tree.getroot()

# FIXME use .text only after checking is an element

for xpath, rules in rulesets.items():
    for element in tree.findall(xpath):
        for rule in rules:
            cases = rules[rule]['cases']
            for case in cases:
                if 'paths' in case:
                    nested_matches = [element.xpath(path) for path in case['paths']]
                    path_matches = sum(nested_matches, [])
                if rule == 'only_one':
                    if len(path_matches) > 1:
                        print(rule, case)
                elif rule == 'atleast_one':
                    if len(path_matches) < 1:
                        print(rule, case)
                elif rule == 'dependent':
                    if all(len(m) != 0 for m in nested_matches) and any(len(m) == 0 for m in nested_matches):
                        print (rule, case)
                elif rule == 'sum':
                    if len(path_matches) and sum(path_matches) != case[sum]:
                        print(rule, case)
                elif rule in ['regex_matches', 'regex_no_matches']:
                    matches = [ re.search(case['regex'], path_match.text) for path_match in path_matches ]
                    if any([m is None for m in matches]) and rule == 'regex_matches':
                        print(rule, case)
                    elif any([m is not None for m in matches]) and rule == 'regex_no_matches':
                        print(rule, case)
                elif rule == 'startswith':
                    start = element.xpath(case['start'])[0] 
                    for path_match in path_matches:
                        if not path_match.text.startswith(start):
                            print(rule, case)

