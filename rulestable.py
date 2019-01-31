import json
import sys
import re
import datetime
from lxml import etree as ET


if len(sys.argv) < 2:
    print('Usage python rulestable.py rulesets/standard.json')
    exit()

rulesets = json.load(open(sys.argv[1]))
print """
.. list-table::
  :header-rows: 1
  
  * - Context
    - Element/Attribute
    - Requirement
    - Tested if

"""
                

english = {
    'date_order': 'Dates must be in correct order',
    'no_more_than_one': 'No more than one',
    'atleast_one': 'Atleast one must be present',
    'sum': 'Must sum to {0}',
    'startswith': 'Must start with ``{0}``',
    'unique': 'Unique',
    'time_limit': 'Length must be under a year',
    'date_now': 'Date must not be more recent than the current date'
}

for xpath, rules in rulesets.items():
    for rule in rules:
        cases = rules[rule]['cases']
        for case in cases:
            print '  * -', xpath
            if rule not in ['date_order']:
                for i,path in enumerate(case['paths']):
                    print ('     ' if i else '    -'), '``{0}``'.format(path)
            elif rule == 'date_order':
                print '    -', case['less']
                print '     ', case['more']
            if rule in english:
                requirement = english[rule]
                if rule == 'sum':
                    requirement = requirement.format(case['sum'])
                elif rule == 'startswith':
                    requirement = requirement.format(case['start'])
            else:
                requirement = rule
            print '    -', requirement
            print '    -', '``{0}``'.format(case['condition']) if 'condition' in case else ''
            print


