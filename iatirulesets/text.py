from __future__ import print_function
import os
import re
import copy


def human_list(other_paths, separator='or'):
    if len(other_paths) == 1:
        return other_paths[0]
    else:
        out = '``, ``'.join(other_paths[:-1])
        out += '`` {0} ``{1}'.format(separator, other_paths[-1])
        return out


def extract_from_expr(expr):
    if "(" in expr and ")" in expr:  # we hav a () enclosed string, let's extract it
        expr = expr[expr.index("(") + 1:expr.rindex(")")]
    return expr


def simplify_xpath(xpath):
    return re.sub(r'\[[^\]]*\]', '', xpath)


def rule_link(rule_id):
    """Returns a Github link given a rule ID"""
    default_url = 'https://github.com/IATI/IATI-Rulesets/blob/v2.03/validatorV2/rulesets/standard.json'
    base_url = default_url + '#L'
    file_dirname = os.path.dirname(__file__)
    if 'IATI-Rulesets' in file_dirname:
        rule_path = os.path.abspath(os.path.join(file_dirname, '../rulesets/standard.json'))
    else:
        rule_path = os.path.abspath(os.path.join(file_dirname, '../IATI-Rulesets/rulesets/standard.json'))
    with open(rule_path) as standard_json:
        for num, line in enumerate(standard_json, 1):
            if '"' + rule_id + '"' in line:
                return base_url + str(num)
    return default_url


def rules_text(rules, reduced_path=None):
    out = []
    for rule in rules:
        cases = rules[rule]['cases']
        for case in cases:
            if 'ruleInfo' in case:
                if reduced_path:
                    if 'paths' in case:
                        for case_path in case['paths']:
                            if simplify_xpath(case_path) == reduced_path:
                                out.append((case['ruleInfo']['id'], case['ruleInfo']['message'], rule_link(case['ruleInfo']['id'])))
                else:
                    out.append((case['ruleInfo']['id'], case['ruleInfo']['message'], rule_link(case['ruleInfo']['id'])))
            else:
                sub_rules = case['do'].keys()
                for sub_rule in sub_rules:
                    sub_cases = case['do'][sub_rule]['cases']
                    for sub_case in sub_cases:
                        if reduced_path:
                            if 'paths' in sub_case:
                                for sub_case_path in sub_case['paths']:
                                    if simplify_xpath(sub_case_path) == reduced_path:
                                        out.append((sub_case['ruleInfo']['id'], sub_case['ruleInfo']['message'], rule_link(sub_case['ruleInfo']['id'])))
                        else:
                            out.append((sub_case['ruleInfo']['id'], sub_case['ruleInfo']['message'], rule_link(sub_case['ruleInfo']['id'])))


    return out
