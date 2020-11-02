IATI-Rulesets
^^^^^^^^^^^^^

.. image:: https://travis-ci.org/data4development/IATI-Rulesets.svg?branch=master
    :target: https://travis-ci.org/data4development/IATI-Rulesets
.. image:: https://img.shields.io/github/v/tag/data4development/IATI-Rulesets
    :target: https://github.com/data4development/IATI-Rulesets/tags
.. image:: https://img.shields.io/badge/license-MIT-blue.svg
    :target: https://github.com/IATI/IATI-Rulesets/blob/version-2.01/LICENSE

Introduction
============

The master branch of this repository is the source for the rulesets in the `IATI Validator Version 1 <https://github.com/IATI/IATI-Validator-Actual>`_.

As part of the Validator work, the earlier JSON-based rules have been migrated to an XSLT-based system,
and some additional checks and feedback messages have been added.

* Please see the `IATI Validator Actual repository <https://github.com/IATI/IATI-Validator-Actual>`_
  for information about the IATI Validator Version 1 and to report bugs, issues, and other feedback.
* Refer to the verion-X.XX branches of this repository for the original JSON-based rules.

Rules
=====

The rules are implemented as an XSLT transformation of an IATI file. The rules insert data quality feedback messages in the IATI XML, in their own namespace.

The Validator processes these files to generate various output formats. 

Testing the rules
=================

The `developer` folder contains Xspec scenarios for IATI data with expected messages.

The scenarios can be run using Ant: `ant tests` will run tests and generate an HTML report in `develop/tests/xspec/iati-result.html`.

Keeping Dependencies Updated
============================

Currently the XSLT transformation relies on Codelists (defined in XML) and Schemas (defined in XSD) contained in the `/lib/schemata` directory of this repository.

These Codelists and Schemas are actively maintained in other repositories.

Codelists

- `IATI/IATI-Codelists <https://github.com/IATI/IATI-Codelists>`_

- `IATI/IATI-Codelists-NonEmbedded <https://github.com/IATI/IATI-Codelists-NonEmbedded>`_

Schemas

- `IATI/IATI-Schemas <https://github.com/IATI/IATI-Schemas>`_

To ensure this repo is up to date with the most recent changes in these repositories you can run the `update_rulesets_lib.sh` script in the `IATI SSOT <https://github.com/IATI/IATI-Standard-SSOT/>`_ repository

This script copies the appropriate Codelists and Schemas into the appropriate `/lib/schemata` subdirectories.

You'll then need to commit to a branch and pull request into the master branch of this repository.

Also note that the Validator stores a copy of this repository in it's build so results will not update in the Validator until a release has been made.
