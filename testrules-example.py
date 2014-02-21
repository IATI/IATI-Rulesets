import lxml.etree as ET
import json
from testrules import ruleset_bool
import sys
import collections

ruleset = json.load(open(sys.argv[1]), object_pairs_hook=collections.OrderedDict)
tree = ET.parse(sys.argv[2])
print ruleset_bool(ruleset,tree)
