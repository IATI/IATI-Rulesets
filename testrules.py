import sys, json, collections
from lxml import etree as ET
from iatirulesets import test_ruleset_verbose

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
    for r in test_ruleset_verbose(ruleset, tree):
        if r['result'] is False:
            print_result(r['element'], r['context'], r['rule'], r['case'])

