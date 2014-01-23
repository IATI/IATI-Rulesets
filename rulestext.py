import json
import sys
import re
import datetime
from lxml import etree as ET


if len(sys.argv) < 2:
    print('Usage python rulestext.py rulesets/standard.json')
    exit()

rulesets = json.load(open(sys.argv[1]))
descriptions = json.load(open('descriptions-en.json'))

for xpath, rules in rulesets.items():
    print xpath
    print '~'*len(xpath)
    print
    for rule in rules:
        cases = rules[rule]['cases']
        for case in cases:
            if 'paths' in case:
                pass

            if rule not in ['date_order']:
                print descriptions[rule]+'::'
                print
                if 'start' in case:
                    print '    start:', case['start'] 
                    print
                for path in case['paths']:
                    print '   ', path
            elif rule == 'date_order':
                print descriptions[rule]+'::'
                print
                print '    less:', case['less']
                print '    more:', case['more']
            print
        print


