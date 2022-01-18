
IATI Ruleset Spec - JS Edition
==============================

An IATI Ruleset is a JSON document. The structure is described below. 

This specification is used by the IATI Validator starting with `version 2 <https://github.com/IATI/js-validator-api/releases/tag/v2.0.1>`_. See `Validator API <https://github.com/IATI/js-validator-api>`_ for more information on the programmatic use of the rules.

A `JSON schema <https://github.com/IATI/IATI-Rulesets/blob/version-2.03/schema.json>`_ is available to test that the structure of a Ruleset is correct.

Each JSON document has the form.::

    {
        "CONTEXT": {
            "RULE_NAME": {
                "cases": CASE_DICT_ARRAY
            }
        }

    }

Where ``CONTEXT`` is an xpath expression. This will be used to select the XML elements that the contained rules will be tested against.
``RULE_NAME`` is one of rule names listed below
``CASE_DICT`` is a dictionary where the contents depend on ``RULE_NAME``
``CASE_DICT_ARRAY`` is an array of case dictionaries. The contents of each dictionary depend on the ``RULE_NAME``

The possible keys in a case dictionary are:

``condition``
    An xpath string. If this evaluates to False, the rule will be ignored.
``idCondition``
    If this evaluates to False, the rule will be ignored.
    
    NOT_EXISTING_ORG_ID - Checks that values in ``paths`` are NOT an existing Publisher Organisation ID from the Registry
    NOT_EXISTING_ORG_ID_PREFIX - Checks that values in ``paths`` are NOT prefixed with an existing Publisher Organisation ID from the Registry
``eval``
    An xpath string. Can evaluate to True or False.
``paths``
    An array of xpath strings. These are evaluated to give a list of elements that the named rule then operates upon.
``less``
    A string containing the xpath of the smaller value (or older value when working with dates).
``more``
    A string containing the xpath of the larger value (or more recent value when working with dates).
``regex``
    A string containing a perl style regular expression.
``sum``
    A number that is the expected sum.
``excluded``
    An array of xpath strings. Evaluate which elements should not coexist with other elements.
``date``
    A string containing the xpath to a date.
``start``
    A string containing the xpath to a start date.
``end``
    A string containing the xpath to an end date.
``one``
    A string containing the xpath of something that must exist or ``all`` must be followed.
``all``
    A string containing the condition that must be met for all elements if ``one`` is not met.
``foreach``
    An xpath string to group the loop by and evalute each ``do`` with the substituted result. 
``do``
    An array of rules. To evaluate with ``foreach``. Available rules include: ``strict_sum``, ``if_then``, ``atleast_one``, ``no_more_than_one`` 
``subs``
    An array of keys where the value matched in ``foreach`` should be substituded for the ``$1`` values in the ``do`` cases.
``prefix``
    An array of xpath strings. The matches of which, contain the possible prefixes for a path. If set to "ORG-ID-PREFIX" for startsWith, checks against provided list of prefixes in ``idSets.ORG-ID-PREFIX``. ``idSets`` are passed to the Rule evaluation code.

Rule Names
----------

**Rule names are listed in bold**
    Keys: The keys for each rule are then listed. They are listed in **snake-case**/**camel-case**. The JS validator can handle either **snake-case** or **camel-case**.

    Followed by a brief description of the rule's function.


**no_more_than_one**/**noMoreThanOne**
    Keys: ``condition``, ``paths``

    There must be no more than one element described by the given paths.

**atleast_one**/**atLeastOne**
    Keys: ``condition``, ``paths``

    There must be at least one element described by the given paths.

**only_one_of**/**onlyOneOf**
    Keys: ``excluded``, ``paths``

    If there's a match of the elements in ``excluded``, there must not be any matches in ``paths``, if there are no matches in ``excluded``, there must be exactly one element from ``paths``.

**one_or_all**/**oneOrAll**
    Keys: ``one``, ``all``

    ``one`` must exist otherwise ``all`` other attributes or elements must exist. 

**dependent**/**NOT IMPLEMENTED IN JS**
    Keys: ``condition``, ``paths``

    If one of the provided paths exists, they must all exist.

**sum**/**sum**
    Keys: ``condition``, ``paths``, ``sum``

    The numerical sum of the values of elements matched by ``paths`` must match the value for the ``sum`` key

**date_order**/**dateOrder**
    Keys: ``condition``, ``less``, ``more``

    The date matched by ``less`` must not be after the date matched by ``more``. If they are equal, the are valid. If either of these dates is not found, the rule is ignored.
    `Guidance - Activity dates and status <https://iatistandard.org/en/guidance/standard-guidance/activity-dates-status/>`_
    
**date_now**/**dateNow**
    Keys: ``date``

    The ``date`` must not be after the current date.

**time_limit**/**timeLimit**
    Keys: ``start``, ``end``

    The difference between the ``start`` date and the ``end`` date must not be greater than a year.

**between_dates**/**betweenDates**
    Keys: ``date``, ``start``, ``end``

    The ``date`` must be between the ``start`` and ``end`` dates.

**regex_matches**/**regexMatches**
    Keys: ``condition``, ``idCondition``, ``paths``, ``regex``

    The provided ``regex`` must match the text of all elements matched by ``paths``. ``idCondition`` is also an optional parameter.

**regex_no_matches**/**regexNoMatches**
    Keys: ``condition``, ``paths``, ``regex``

    The provided ``regex`` must match the text of none of the elements matched by ``paths``.

**startswith**/**startsWith**
    Keys: ``condition``, ``idCondition``, ``paths``, ``start``, ``separator``

    The text of each element matched by ``paths`` must start with the text of one of the elements matched by ``prefix`` (or a list of prefixed provided in ``idSets``) with an optional ``separator`` in between
    ``prefix````separator````pathMatchText``. ``idCondition`` is also an optional parameter.

**unique**/**unique**
    Keys: ``condition``, ``paths``

    The text of each of the elements described by ``paths`` must be unique

**if_then**/**ifThen**
    Keys: ``condition``, ``cases``, ``if``, ``then``, ``paths``

    If the condition evaluated in ``if`` is true, then ``then`` must resolve to true as well
    ``paths`` can be defined to provide additional context data in the output if a rule fails, but had no bearing on the pass/fail of the rule 

**loop**/**loop**
    Keys: ``foreach``, ``do``, ``cases``, ``subs``

    All elements in ``foreach`` are evaluated under the rules inside ``do``

**strict_sum**/**strictSum**
    Keys: ``paths``, ``sum``

    The decimal sum of the values of elements matched by ``paths`` must match the value for the ``sum`` key

**no_spaces**/**noSpaces**
    Keys: ``paths``

    The text of each of the elements described by ``paths`` should not start or end with spaces or newlines 

Rule Example
------------

.. code-block:: json
    
    { 
        "/iati-activities/iati-activity": {
            "atleast_one": {
                "cases": [
                    { 
                        "paths": ["iati-identifier"],
                        "ruleInfo": {
                            "id": "6.11.1",
                            "severity": "error",
                            "category": "information",
                            "message": "The activity must have a planned start date or an actual start date.",
                            "link": {
                                "url": "https://iatistandard.org/en/guidance/standard-guidance/activity-dates-status/"
                            } 
                        }
                    }
                ]
            },
            "range": {
                "cases": [
                    {
                        "paths": ["capital-spend/@percentage"],
                        "min": 0.0,
                        "max": 100.0,
                        "ruleInfo": {
                            "id": "12.2.1",
                            "severity": "error",
                            "category": "financial",
                            "message": "The percentage value must be between 0.0 and 100.0 (inclusive).",
                            "link": {
                                "path": "activity-standard/iati-activities/iati-activity/capital-spend/"
                            }
                        }
                    }
                ]
            }
        }
    }

Here we have a context: ``/iati-activities/iati-activity``, with a two named rules `atleast_one` and `range` which is applied in a number of cases - here just one each, with a single path each.

The ``ruleInfo`` object includes metadata about the rule which is used in the `Validator API <https://github.com/IATI/js-validator-api>`_.

The ``link`` object can contain 2 possible keys which represent the Guidance Links for the rule:
* ``url`` is a full URL to the guidance
* ``path`` is the path to be added to the end of the reference documentation url for the version of standard. (e.g. ``https://iatistandard.org/en/iati-standard/{version}/{path}``)
