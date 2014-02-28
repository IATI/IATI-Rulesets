IATI-Rulesets
=============

These rulesets are part of IATI Standard Single Source of Truth (SSOT). For more detailed information about the SSOT, please see https://github.com/IATI/IATI-Standard-SSOT/blob/master/meta-docs/index.rst

Note, these rulesets are currently under development, and do not necessarily represent any current or future version of the IATI Standard.

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

A more thorough description of this, along with a list of all rule names can be found in the `Spec <https://github.com/IATI/IATI-Rulesets/blob/master/SPEC.rst>`.


Ruleset Tester
==============

A program is required to test whether a given xml file conforms to the rules in a ruleset JSON file. The rulesets is designed such that implementations of this can be made in multiple programming languages, so long as they implement all of the named rules in `<descriptions-en.json>`_. Currently there is a completed Python implementation `<testrules.py>`_ and a partially complete PHP implementation `<testrules.php>`_.

Rules not in these Rulesets
===========================

* Testing whether an element is on a certain codelist - this belongs in the IATI-Codelists (see `testcodelists.py <https://github.com/IATI/IATI-Codelists/blob/master/testcodelists.py>`_)

* Testing whether identifier are correct (e.g. uniqueness etc) - this requires information outside the scope of a single activity/file, whereas currently the rulesets operate in just this context. This may change in the future.

Different Rulesets
==================

* ``standard.json`` is a ruleset that tries to describe compliance to the standard
* ``dfid.json`` is a more comprehensive set of rules based on DFID's requirements for organisations it works with
* ``ti-fallbacks.json`` finds problems with data that had to be worked around (using fallbacks) in transparency indicator tests
