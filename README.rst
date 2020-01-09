IATI-Rulesets
^^^^^^^^^^^^^

.. |license| image:: https://img.shields.io/badge/license-MIT-blue.svg
    :target: https://github.com/IATI/IATI-Rulesets/blob/version-2.01/LICENSE

.. |master| image:: https://travis-ci.org/data4development/IATI-Rulesets.svg?branch=master
    :target: https://travis-ci.org/data4development/IATI-Rulesets

.. |develop| image:: https://travis-ci.org/data4development/IATI-Rulesets.svg?branch=develop
    :target: https://travis-ci.org/data4development/IATI-Rulesets

master |master| - develop |develop| - |license|

Introduction
============

This is the source repository for the rulesets in the new IATI Validator.

As part of the Validator work, the earlier JSON-based rules have been migrated to an XSLT-based system,
and some additional checks and feedback messages have been added.

* Please see the `main IATI data validator repository <https://github.com/data4development/IATI-data-validator>`_
  for information about the new IATI Validator and to report bugs, issues, and other feedback.
* Refer to the `original IATI-Rulesets repository <https://github.com/IATI/IATI-Rulesets>`_ for the original JSON-based rules.

Rules
=====

The rules are implemented as an XSLT transformation of an IATI file. The rules insert data quality feedback messages in the IATI XML, in their own namespace.

The Validator processes these files to generate various output formats. 

Testing the rules
=================

The `developer` folder contains Xspec scenarios for IATI data with expected messages.

The scenarios can be run using Ant: `ant tests` will run tests and generate an HTML report in `develop/tests/xspec/iati-result.html`.
