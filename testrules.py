import json
import sys
import re
import datetime
from lxml import etree as ET


if len(sys.argv) < 3:
    print('Usage python testrules.py rulesets.json file.xml')
    exit()

rulesets = json.load(open(sys.argv[1]))

tree = ET.parse(sys.argv[2])
root = tree.getroot()

xsDateRegex = re.compile('(-?[0-9]{4,})-([0-9]{2})-([0-9]{2})')

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
                elif rule == 'date_order':
                    try:
                        m1 = xsDateRegex.match(element.xpath(case['less'])[0].attrib['iso-date'])
                        less = datetime.date(*map(int, m1.groups()))
                        m2 = xsDateRegex.match(element.xpath(case['more'])[0].attrib['iso-date'])
                        more = datetime.date(*map(int, m2.groups()))
                        if not (less < more):
                            print(rule,case)
                    except IndexError:
                        pass
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
                else:
                    print 'Unimplemented rules, exiting.'
                    exit()

