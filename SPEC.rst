
IATI Ruleset Spec
=================

An IATI Ruleset is a JSON document. The structure is described below.

A `JSON schema <https://github.com/IATI/IATI-Rulesets/blob/version-2.01/schema.json>`_ is availible to test that the structure of a Ruleset is correct.

Each JSON document has the form.::

    {
        "CONTEXT": {
            "RULE_NAME": {
                "cases": CASE_DICT_ARRAY
            }
        }

    }

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


no_more_than_one
    Keys: ``condition``, ``paths``

    There must be no more than one element described by the given paths.

atleast_one
    Keys: ``condition``, ``paths``

    There must be at least one element described by the given paths.

dependent
    Keys: ``condition``, ``paths``

    If one of the provided paths exists, they must all exist.

sum
    Keys: ``condition``, ``paths``, ``sum``

    The numerical sum of the values of elements matched by ``paths`` must match the value for the ``sum`` key

date_order
    Keys: ``condition``, ``less``, ``more``

    The date matched by ``less`` must not be after the date matched by ``more``. If either of these dates is not found, the rule is ignored.

regex_matches
    Keys: ``condition``, ``paths``, ``regex``

    The provided ``regex`` must match the text of all elements matched by ``paths``

regex_no_matches
    Keys: ``condition``, ``paths``, ``regex``

    The provided ``regex`` must match the text of none of the elements matched by ``paths``

startswith
    Keys: ``condition``, ``paths``, ``start``

    The text of the each element matched by ``paths`` must start with the text of the element matched by ``start``

unique
    Keys: ``condition``, ``paths``

    The text of each of the elements described by ``paths`` must be unique

positive_decimal
    Keys: ``condition``, ``paths``

    The text of each of the elements described by ``paths`` must a positive decimal number




