import json
import sys
import re
import datetime
import collections
from lxml import etree as ET

def get_text(element_or_attribute):
    """ Returns the text of the given element or attribute """ 
    # use .text only after checking is an element
    if type(element_or_attribute) == ET._Element:
        return element_or_attribute.text
    else:
        return unicode(element_or_attribute)

xsDateRegex = re.compile('(-?[0-9]{4,})-([0-9]{2})-([0-9]{2})')

class Rules(object):
    def __init__(self, element, case):
        self.element = element
        if 'paths' in case:
            self.nested_matches = [element.xpath(path) for path in case['paths']]
            self.path_matches = sum(self.nested_matches, [])
            self.path_matches_text = map(get_text, self.path_matches)

    def no_more_than_one(self, case):
        return len(self.path_matches) <= 1

    def atleast_one(self, case):
        return len(self.path_matches) >= 1

    def dependent(self, case):
        return not(
            all(len(m) != 0 for m in self.nested_matches) and
            any(len(m) == 0 for m in self.nested_matches)
            )

    def unique(self, case):
        return len(self.path_matches_text) <= len(set(self.path_matches_text)),

    def sum(self, case):
        return not(len(self.path_matches)) or sum(map(int, map(get_text, self.path_matches))) == case['sum'],

    def _parse_date(self, date_xpath):
        if date_xpath == 'TODAY':
            return datetime.date.today()
        else:
            date_elements = self.element.xpath(date_xpath)
            if len(date_elements) < 1:
                return None
            date_text = date_elements[0].attrib.get('iso-date')
            if date_text:
                m1 = xsDateRegex.match(date_text)
                return datetime.date(*map(int, m1.groups()))
            else:
                return None

    def date_order(self, case):
        less = self._parse_date(case['less'])
        more = self._parse_date(case['more'])
        if less is None or more is None: return None
        else: return less <= more

    def _regex_matches(self, case):
        matches = [ re.search(case['regex'], get_text(path_match)) for path_match in path_matches ]

    def regex_matches(self, case):
        return all([m is None for m in _regex_matches(self, case)])

    def regex_no_matches(self, case):
        return all([m is not None for m in _regex_matches(self, case)]) 

    def startswith(self, case):
        start = get_text(self.element.xpath(case['start'])[0])
        for path_match in self.path_matches:
            if not get_text(path_match).startswith(start):
                return False
        return True

def ruleset_single(context_xpath,element,rule,case):
    if 'condition' in case and not element.xpath(case['condition']):
        result = None
    else:
        rules_ = Rules(element, case)
        result = getattr(rules_, rule)(case)
    return {
        'result':result,
        'element':element,
        'context':context_xpath,
        'rule':rule,
        'case':case
        }

def ruleset_test(ruleset, tree):
    for context_xpath, rules in ruleset.items():
        for element in tree.findall(context_xpath):
            for rule in rules:
                cases = rules[rule]['cases']
                for case in  cases:
                    yield ruleset_single(context_xpath,element,rule,case) 

def ruleset_bool(ruleset, tree):
    return all(x['result'] for x in ruleset_test(ruleset, tree) if x['result'] is not None)

import csv
writer = csv.writer(sys.stdout, delimiter='\t')
def print_result(element, xpath, rule, case):
    """
    Prints information to stdout about the current element, xpath, rule and
    case.
    
    """
    try:
        iati_identifier = element.xpath('ancestor-or-self::iati-activity/iati-identifier')[0].text
    except IndexError: iati_identifier = ''
    writer.writerow(list(map(str, [iati_identifier, xpath, rule, dict(case)])))
                        

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print('Usage python testrules.py rulesets/standard.json file.xml')
        exit()

    ruleset = json.load(open(sys.argv[1]), object_pairs_hook=collections.OrderedDict)
    tree = ET.parse(sys.argv[2])
    for r in ruleset_test(ruleset, tree):
        if r['result'] is False:
            print_result(r['element'], r['context'], r['rule'], r['case'])

