import json
import sys
import re
import datetime
from lxml import etree as ET


def print_result(element, xpath, rule, case):
    try:
        iati_identifier = element.xpath('ancestor-or-self::iati-activity/iati-identifier')[0].text
    except IndexError: iati_identifier = ''
    print(iati_identifier, xpath, rule, case)


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
                        print_result(element, xpath, rule, case)
                elif rule == 'atleast_one':
                    if len(path_matches) < 1:
                        print_result(element, xpath, rule, case)
                elif rule == 'dependent':
                    if all(len(m) != 0 for m in nested_matches) and any(len(m) == 0 for m in nested_matches):
                        print (xpath, rule, case)
                elif rule == 'unique':
                    path_matches_text = [ x.text for x in path_matches ]
                    if len(path_matches_text) > len(set(path_matches_text)):
                        print_result(element, xpath, rule, case)
                elif rule == 'sum':
                    if len(path_matches) and sum(map(int, path_matches)) != case['sum']:
                        print_result(element, xpath, rule, case)
                elif rule == 'date_order':
                    def parse_date(date_xpath):
                        if date_xpath == 'TODAY':
                            less = datetime.date.today()
                        else:
                            date_text = element.xpath(date_xpath)[0].attrib.get('iso-date')
                            if date_text:
                                m1 = xsDateRegex.match(date_text)
                                return datetime.date(*map(int, m1.groups()))
                            else:
                                raise IndexError
                    try:
                        less = parse_date(case['less'])
                        more = parse_date(case['more'])
                        if not (less < more):
                            print_result(element, xpath, rule,case)
                    except IndexError:
                        pass
                elif rule in ['regex_matches', 'regex_no_matches']:
                    matches = [ re.search(case['regex'], path_match.text) for path_match in path_matches ]
                    if any([m is None for m in matches]) and rule == 'regex_matches':
                        print_result(element, xpath, rule, case)
                    elif any([m is not None for m in matches]) and rule == 'regex_no_matches':
                        print_result(element, xpath, rule, case)
                elif rule == 'startswith':
                    start = element.xpath(case['start'])[0] 
                    for path_match in path_matches:
                        if not path_match.text.startswith(start):
                            print_result(element, xpath, rule, case)

