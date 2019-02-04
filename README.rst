IATI-Rulesets
^^^^^^^^^^^^^

.. image:: https://travis-ci.org/IATI/IATI-Rulesets.svg?branch=version-2.01
    :target: https://travis-ci.org/IATI/IATI-Rulesets
.. image:: https://requires.io/github/IATI/IATI-Rulesets/requirements.svg?branch=version-2.01
    :target: https://requires.io/github/IATI/IATI-Rulesets/requirements/?branch=version-2.01
    :alt: Requirements Status
.. image:: https://img.shields.io/badge/license-MIT-blue.svg
    :target: https://github.com/IATI/IATI-Rulesets/blob/version-2.01/LICENSE

Introduction
============

This is the source repository for the rulesets, more general information can be found on the IATIStandard website: http://iatistandard.org/rulesets/

These rulesets are part of IATI Standard Single Source of Truth (SSOT). For more detailed information about the SSOT, please see http://iatistandard.org/developer/ssot/

Ruleset Structure
=================

A ruleset is a JSON file which applies different rules to various paths in different element. Strutucure:

.. code-block:: json
    
    { 
        "//iati-activity": {
            "atleast_one": {
                "cases": [
                    { "paths": ["iati-identifier"] }
                ]
            }
        }
    }

Here we have a context: ``iati-activity``, with a single name rule `atleast_one` which is applied in a number of cases - here just one, with a single path.

A more thorough description of this, along with a list of all rule names can be found in the `Spec <https://github.com/IATI/IATI-Rulesets/blob/version-2.02/SPEC.rst>`_.


Ruleset Tester
==============

A program is required to test whether a given xml file conforms to the rules in a ruleset JSON file. The rulesets is designed such that implementations of this can be made in multiple programming languages, so long as they implement the `Spec <https://github.com/IATI/IATI-Rulesets/blob/version-2.02/SPEC.rst>`_.

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

* ``standard.json`` is a ruleset that tries to describe compliance to the standard
* ``dfid.json`` is a more comprehensive set of rules based on DFID's requirements for organisations it works with
* ``ti-fallbacks.json`` finds problems with data that had to be worked around (using fallbacks) in transparency indicator tests

Rules not describable by a Ruleset
==================================

* Testing whether an element is on a certain codelist - this belongs in the IATI-Codelists (see `testcodelists.py <https://github.com/IATI/IATI-Codelists/blob/version-2.02/testcodelists.py>`_)

* Testing whether identifier are correct (e.g. uniqueness etc) - this requires information outside the scope of a single activity/file, whereas currently the rulesets operate in just this context. This may change in the future.

