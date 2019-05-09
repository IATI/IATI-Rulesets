# These are tests of the software in this repository, not tests of IATI data!

import unittest
import iatirulesets
from lxml import etree as ET


def tree_from_string(x):
    return ET.ElementTree(ET.fromstring(x))


class TestTestRuleset(unittest.TestCase):
    def test_empty(self):
        self.assertTrue(iatirulesets.test_ruleset(
            {},
            tree_from_string('<iati-activities/>')
        ))

    def test_atleast_one(self):
        test_title = {
            '//iati-activity': {
                'atleast_one': {
                    'cases': [{
                        'paths': [
                            'title'
                        ]
                    }]
                }
            }
        }

        self.assertFalse(iatirulesets.test_ruleset(
            test_title,
            tree_from_string('<iati-activities><iati-activity></iati-activity></iati-activities>')
        ))

        self.assertTrue(iatirulesets.test_ruleset(
            test_title,
            tree_from_string('<iati-activities/>')
        ))

        self.assertTrue(iatirulesets.test_ruleset(
            test_title,
            tree_from_string('<iati-activities><iati-activity><title/></iati-activity></iati-activities>'))
        )

        test_title_text = {
            '//iati-activity': {
                'atleast_one': {
                    'cases': [{
                        'paths': ['title/text()']
                    }]
                }
            }
        }

        self.assertFalse(iatirulesets.test_ruleset(
            test_title_text,
            tree_from_string('<iati-activities><iati-activity><title/></iati-activity></iati-activities>'))
        )

        self.assertTrue(iatirulesets.test_ruleset(
            test_title_text,
            tree_from_string('<iati-activities><iati-activity><title>Title</title></iati-activity></iati-activities>'))
        )

    def test_no_paths(self):
        self.assertTrue(iatirulesets.test_ruleset({
            '//iati-activity': {
                'atleast_one': {
                    'cases': [{
                        'paths': []
                    }]
                }
            }
        }, tree_from_string('<iati-activities/>')))

        self.assertFalse(iatirulesets.test_ruleset({
            '//iati-activity': {
                'atleast_one': {
                    'cases': [{
                        'paths': []
                    }]
                }
            }
        }, tree_from_string('<iati-activities><iati-activity/></iati-activities>')))


class TestTestRulesetSubelement(unittest.TestCase):
    def test_subelement(self):
        test = {
            '//iati-activity': {
                'atleast_one': {
                    'cases': [{
                        'paths': ['title']
                    }]
                }
            }
        }

        self.assertFalse(iatirulesets.test_ruleset_subelement(
            test,
            ET.fromstring('<iati-activity/>')
        ))

        self.assertTrue(iatirulesets.test_ruleset_subelement(
            test,
            ET.fromstring('<iati-activity><title/></iati-activity>')
        ))


if __name__ == '__main__':
    unittest.main()
