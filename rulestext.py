import json
import sys
import re
import datetime
from lxml import etree as ET


if len(sys.argv) < 2:
    print('Usage python rulestext.py rulesets.json')
    exit()

rulesets = json.load(open(sys.argv[1]))
descriptions = json.load(open('descriptions.json'))


xsDateRegex = re.compile('(-?[0-9]{4,})-([0-9]{2})-([0-9]{2})')

# FIXME use .text only after checking is an element

for xpath, rules in rulesets.items():
    print xpath
    for rule in rules:
        cases = rules[rule]['cases']
        for case in cases:
            if 'paths' in case:
                pass

            if rule not in ['date_order']:
                print '   ', descriptions[rule], case['paths']
            elif rule == 'date_order':
                print '   ', descriptions[rule], case['less'], case['more']

