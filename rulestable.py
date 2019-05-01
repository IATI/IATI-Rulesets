import json
import sys

if len(sys.argv) < 2:
    print('Usage python rulestable.py rulesets/standard.json')
    exit()

rulesets = json.load(open(sys.argv[1]))
print("""
.. list-table::
  :header-rows: 1

  * - Context
    - Element/Attribute
    - Requirement
    - Tested if

""")  # noqa


english = {
    'date_order': 'Dates must be in correct order',
    'no_more_than_one': 'No more than one',
    'only_one_of': 'Excluded elements must not coexist with selected elements, and only one of these elements must exist',
    'atleast_one': 'Atleast one must be present',
    'one_or_all': 'One must be present or all of the others must be',
    'sum': 'Must sum to {0}',
    'startswith': 'Must start with ``{0}``',
    'unique': 'Unique',
    'range': 'The value must be at least ``min`` and no more than ``max`` (inclusive).',
    'evaluates_to_true': '```eval``` must evaluate to true',
    'time_limit': 'Length must be under a year',
    'date_now': 'Date must not be more recent than the current date',
    'between_dates': 'Date must be within a defined time period',
    'no_percent': 'The value must not contain the ```%``` sign',
    'if_then': 'If ```if``` evaluates to true, ```then``` must evaluate to true',
    'loop': 'Loops through different values of an attribute or element.',
    'strict_sum': 'Must sum to {0} as a decimal'
}

for xpath, rules in rulesets.items():
    for rule in rules:
        cases = rules[rule]['cases']
        for case in cases:
            print('  * -', xpath)
            if rule not in ['date_order']:
                for i, path in enumerate(case['paths']):
                    print('     ' if i else '    -', '``{0}``'.format(path))
            elif rule == 'date_order':
                print('    -', case['less'])
                print('     ', case['more'])
            if rule in english:
                requirement = english[rule]
                if rule == 'sum':
                    requirement = requirement.format(case['sum'])
                elif rule == 'startswith':
                    requirement = requirement.format(case['start'])
            else:
                requirement = rule
            print('    -', requirement)
            print('    -', '``{0}``'.format(case['condition']) if 'condition' in case else '')
