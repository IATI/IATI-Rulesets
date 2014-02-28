import json
import collections

schema = json.load(open('schema.json'), object_pairs_hook=collections.OrderedDict)

print("""
IATI Ruleset Spec
=================

An IATI Ruleset is a JSON document. The structure is described below.

A `JSON schema <https://github.com/IATI/IATI-Rulesets/blob/master/schema.json>`_ is availible to test that the structure of a Ruleset is correct.

Each JSON document has the form.::

    {
        "CONTEXT": {
            "RULE_NAME": {
                "cases": CASE_DICT_ARRAY
            }
        }

    }""")

print ("""
Where ``CONTEXT`` is some xpath expression. This will be used to select the XML elements that the contained rules will be tested against.
``RULE_NAME`` is one of rule names listed below
``CASE_DICT`` is a dictionary who's contents depends on ``RULE_NAME``
``CASE_DICT_ARRAY`` is an array of case dictionaries. The contents of each dictionary depends on the ``RULE_NAME``

The possible keys in a case dictionary are:

``condition``
    An xpath string. If this evaluates to True, the rule will be ignored.
``paths``
    An array of xpath strings. These are evaluated to give a list of elements that the named rule then operates on.
``less``
    A string containing the xpath of the value that should be smaller
``more``
    A string containing the xpath of the value that should be larger
``regex``
    A string containing a perl style regular expression
``sum``
    A number.

Rule Names
----------

Rule names are listed in bold, along with a description and what keys must be in the case dictionary.

""".format(
    repr(list(schema['patternProperties']['.+']['properties'].keys()))
))

for rule_name, rule_schema in schema['patternProperties']['.+']['properties'].items():
    print(rule_name)
    assert(rule_schema['type'] == 'object')
    assert(list(rule_schema['properties'].keys()) == ['cases'])
    assert(rule_schema['properties']['cases']['type'] == 'array')
    print('    Keys: '+', '.join('``'+x+'``' for x in sorted(rule_schema['properties']['cases']['items']['properties'].keys())))
    print()
    print('    '+rule_schema['description'])
    print()
    #for prop_name, prop in rule_schema['properties']['cases']['items']['properties'].items():
        #print(prop_name, 'array of {0}'.format(prop['items']['type']) if prop['type'] == 'array' else prop['type'])

print("""

""")
