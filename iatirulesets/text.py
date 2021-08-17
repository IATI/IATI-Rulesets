from __future__ import print_function
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


def rules_text(rules, reduced_path=None):
    out = []
    for rule in rules:
        cases = rules[rule]['cases']
        for case in cases:
            if reduced_path:
                if 'paths' in case:
                    for case_path in case['paths']:
                        if simplify_xpath(case_path) == reduced_path:
                            out.append({case['ruleInfo']['id']: case['ruleInfo']['message']})
            else:
                out.append({case['ruleInfo']['id']: case['ruleInfo']['message']})
    return out
