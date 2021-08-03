IATI-Rulesets
^^^^^^^^^^^^^
.. image:: https://github.com/IATI/IATI-Rulesets/workflows/CI_version-2.03/badge.svg
    :target: https://github.com/IATI/IATI-Rulesets/actions

.. image:: https://requires.io/github/IATI/IATI-Rulesets/requirements.svg?branch=version-2.03
    :target: https://requires.io/github/IATI/IATI-Rulesets/requirements/?branch=version-2.03
    :alt: Requirements Status
.. image:: https://img.shields.io/badge/license-MIT-blue.svg
    :target: https://github.com/IATI/IATI-Rulesets/blob/version-2.03/LICENSE

Introduction
============

This is the source repository for the rulesets, more general information can be found on the IATI Standard website: https://iatistandard.org/en/iati-standard/203/rulesets/

These rulesets are part of IATI Standard Single Source of Truth (SSOT). For more detailed information about the SSOT, please see https://iatistandard.org/en/guidance/developer/ssot/


As part of the **V1 Validator work**, the JSON-based rules were migrated to an XSLT-based system, and some additional checks and feedback messages have been added in line with the IATI Standard.
Please see `IATI Validator Actual <https://github.com/IATI/IATI-Validator-Actual>`_  repository for information about the V1 tool and to report bugs, issues, and other feedback.
Please refer to the new Validator's `XSLT-based Ruleset <https://github.com/IATI/IATI-Rulesets#master>`_ repository for an up-to-date version of each rule's narrative.
Email us on support@iatistandard.org for further clarification.

As part of the **V2 Validator work**, the JSON-based rules have been enhanced and some additional checks and feedback messages have been added in line with the IATI Standard. See `SPEC_JS <SPEC_JS.rst>`_ for more detail.
A new JavaScript (Node) implementation of the Ruleset validator has been developed as well. Please see `IATI Validator API <https://github.com/IATI/js-validator-api>`_  repository for information about the new tool and to report bugs, issues, and other feedback.
Email us on support@iatistandard.org for further clarification.

Information for developers
==========================

This tool supports Python 3.x. To use this script, we recommend the use of a virtual environment::

    python3 -m venv pyenv
    source pyenv/bin/activate
    pip install -r requirements.txt

Ruleset Structure
=================

A ruleset is a JSON file which applies different rules to various paths in different elements. Example Structure:

.. code-block:: json
    
    { 
        "//iati-activity": {
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

Here we have a context: ``iati-activity``, with a two named rules `atleast_one` and `range` which is applied in a number of cases - here just one each, with a single path each.

The full JSON Schema is defined in `<schema.json>`__. 

A more thorough description of this, along with a list of all rule names can be found in the `Spec <SPEC_JS.rst>`_.

A description of the earlier Python based implementation can be found in the `Spec <SPEC.rst>`_.

The ``ruleInfo`` object includes metadata about the rule which is used in the `IATI js validator api <https://github.com/IATI/js-validator-api>`_.

The ``link`` object can contain 2 possible keys which represent the Guidance Links for the rule:
* ``url`` is a full URL to the guidance
* ``path`` is the path to be added to the end of the reference documentation url for the version of standard. (e.g. https://iatistandard.org/en/iati-standard/{version}/{path})


Ruleset Tester
==============

**NOTE** : The following Python tests have not been updated for the new JavaScript implementation of the rulesets and therefore are not comprehensive in testing IATI XML. Use the `IATI js validator api <https://github.com/IATI/js-validator-api>`_ for comprehensive testing.

A program is required to test whether a given xml file conforms to the rules in a ruleset JSON file. The rulesets is designed such that implementations of this can be made in multiple programming languages, so long as they implement the `Spec <https://github.com/IATI/IATI-Rulesets/blob/version-2.03/SPEC.rst>`_.

Currently, a Python `<testrules.py>`_ tester is available. E.g.

.. code-block:: bash

   # These commands output a line for each problem found
   python testrules.py rulesets/standard.json file.xml

Tests for Testers
-----------------

`<meta_tests.sh>`_ can be used to run a suite of example Ruleset and XML files (located in the `<meta_tests>`_ folder) against a Ruleset Tester. e.g.

.. code-block:: bash

   ./meta_tests.sh python testrules.py

Different Rulesets
==================

* ``standard.json`` is a ruleset that tries to describe compliance to the standard, this is used by the `IATI js validator api <https://github.com/IATI/js-validator-api>`_
* ``dfid.json`` is a more comprehensive set of rules based on DFID's requirements for organisations it works with
* ``ti-fallbacks.json`` finds problems with data that had to be worked around (using fallbacks) in transparency indicator tests

Rules not describable by a Ruleset
==================================

* Testing whether an element is on a certain codelist - this belongs in the IATI-Codelists (see `testcodelists.py <https://github.com/IATI/IATI-Codelists/blob/version-2.03/testcodelists.py>`_)

* Testing whether identifier are correct (e.g. uniqueness etc) - this requires information outside the scope of a single activity/file, whereas currently the rulesets operate in just this context. This may change in the future.

Both the above rules are included as part of the `IATI js validator api <https://github.com/IATI/js-validator-api>`_. Please see that repository for more information.

GitHub Actions workflows
=========================

``.github/workflows/main.yml`` does a few things when new code is pushed to  version-2.0X branches. 

* Runs flake8 linting 
* Tests that ``rulesets/standard.json`` adheres to the JSON schema defined in ``schema.json``
* Runs `<meta_tests.sh>`__ 
* Pushes ``rulesets/standard.json`` to the Redis cache used by the `IATI js validator api <https://github.com/IATI/js-validator-api>`__
* Triggers a workflow to update the .csv Validator rules in `Validator Rule Tracker <https://github.com/IATI/validator-rule-tracker>`__
