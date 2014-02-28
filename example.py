import lxml.etree as ET
import json, sys
from iatirulesets import test_ruleset

ruleset = json.load(open(sys.argv[1]))
tree = ET.parse(sys.argv[2])
print(test_ruleset(ruleset,tree))
