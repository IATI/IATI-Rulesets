from __future__ import print_function
import re

def rules_text(rules, reduced_path, show_all=False):
    out = []
    for rule in rules:
        cases = rules[rule]['cases']
        for case in cases:
            simplify_xpath = lambda x: re.sub('\[[^\]]*\]', '', x)
            if 'paths' in case:
                for case_path in case['paths']:
                    # Don't forget [@ ]
                    if show_all or simplify_xpath(case_path) == reduced_path:
                        other_paths = case['paths']
                        other_paths.remove(case_path)
                        if rule == 'only_one':
                            out.append('``{0}`` must be present only once.'.format(case_path))
                            if other_paths:
                                out.append('``{0}`` must not be present if ``{1}`` are present.'.format(case_path, human_list(other_paths)))
                        elif rule == 'atleast_one':
                            if other_paths:
                                out.append('Either ``{0}`` or ``{1}`` must be present.'.format(case_path, human_list(other_paths)))
                            else:
                                out.append('``{0}`` must be present.\n\n'.format(case_path))
                        elif rule == 'startswith':
                            out.append('``{0}`` should start with the value in ``{1}``'.format(case_path, case['start']))
                        else: print('Not implemented', case_path, rule, case['paths'])
            elif rule == 'date_order':
                if show_all or simplify_xpath(case['less']) == reduced_path or simplify_xpath(case['more']) == reduced_path:
                    if case['less'] == 'NOW':
                        out.append('``{0}`` must be in the future.\n\n'.format(case['more']))
                    elif case['more'] == 'NOW':
                        out.append('``{0}`` must be today, or in the past.\n\n'.format(case['less']))
                    else:
                        out.append('``{0}`` must be before ``{1}``\n\n'.format(case['less'], case['more']))
            else: print('Not implemented', case_path, rule, case['paths'])
    return out

