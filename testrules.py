from __future__ import print_function
import sys, json, collections
from lxml import etree as ET
import iatirulesets
import csv
                        
if len(sys.argv) < 3:
    print('Usage python testrules.py rulesets/standard.json file.xml [--no-breakdown]')
    exit()

writer = csv.writer(sys.stdout, delimiter='\t')
ruleset = json.load(open(sys.argv[1]), object_pairs_hook=collections.OrderedDict)

tree = ET.parse(sys.argv[2])

if len(sys.argv) > 3 and sys.argv[3] == '--no-breakdown':
    breakdown = False
else:
    breakdown = True

if breakdown:
    root = tree.getroot()
    for element in root:
        for result in iatirulesets.test_ruleset_subelement(ruleset, element, verbose=True):
            if result['result'] is False:
                writer.writerow(list(map(str, [
                    element.find('iati-identifier').text,
                    result['context'],
                    result['rule'],
                    result['case']
                        ])))
else:
    print(iatirulesets.test_ruleset(ruleset, tree)) 
