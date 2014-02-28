import sys, json, collections
from lxml import etree as ET
from iatirulesets import test_ruleset_subelement
import csv
                        
writer = csv.writer(sys.stdout, delimiter='\t')
ruleset = json.load(open(sys.argv[1]), object_pairs_hook=collections.OrderedDict)

tree = ET.parse(sys.argv[2])
root = tree.getroot()

for element in root:
    for result in test_ruleset_subelement(ruleset, element, verbose=True):
        if result['result'] is False:
            writer.writerow(list(map(str, [
                element.find('iati-identifier').text,
                result['context'],
                result['rule'],
                result['case']
                    ])))
