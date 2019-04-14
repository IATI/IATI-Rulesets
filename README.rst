IATI-Rulesets
^^^^^^^^^^^^^

.. image:: https://travis-ci.org/data4development/IATI-Rulesets.svg?branch=migrate-to-xslt-rules
    :target: https://travis-ci.org/data4development/IATI-Rulesets
.. image:: https://img.shields.io/badge/license-MIT-blue.svg
    :target: https://github.com/IATI/IATI-Rulesets/blob/version-2.01/LICENSE

Introduction
============

This is the source repository for the rulesets.

As part of the Validator work, the XSLT-based rules are migrated into the repository to replace the JSON-based rules.

The branch `migrate-to-xslt-rules` tracks work on this.

Rules
=====

The rules are implemented as an XSLT transformation of an IATI file. The rules insert data quality feedback messages in the IATI XML, in their own namespace.

The Validator processes these files to generate various output formats. 

Testing the rules
=================

The `developer` folder contains Xspec scenarios for IATI data with expected messages.

The scenarios can be run using Ant: `ant tests` will run tests for version 1.0x and 2.0x and generate two HTML reports.