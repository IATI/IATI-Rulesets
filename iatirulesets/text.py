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
                        other_paths = copy.deepcopy(case['paths'])
                        other_paths.remove(case_path)
                        if rule == 'only_one':
                            out.append('``{0}`` must be present only once.'.format(case_path))
                            if other_paths:
                                out.append('``{0}`` must not be present if ``{1}`` are present.'.format(case_path, human_list(other_paths)))
                        elif rule == 'atleast_one':
                            if other_paths:
                                all_paths = [case_path] + other_paths
                                out.append('At least one of ``{0}`` must be present.'.format(human_list(all_paths)))
                            else:
                                out.append('``{0}`` must be present.'.format(case_path))
                        elif rule == 'startswith':
                            out.append('``{0}`` should start with the value in ``{1}``'.format(case_path, case['start']))
                        elif rule == 'regex_matches':
                            out.append('``{0}`` should match the regex ``{1}``'.format(case_path, case['regex']))
                        elif rule == 'no_more_than_one':
                            if other_paths:
                                out.append('There must be no more than one element or attribute matched at ``{0}`` or ``{1}``.'.format(case_path, human_list(other_paths)))
                            else:
                                out.append('There must be no more than one element or attribute matched at ``{0}``.'.format(case_path))
                        elif rule == 'sum':
                            sum_total = case['sum']
                            if other_paths:
                                all_paths = [case_path] + other_paths
                                out.append('The sum of values matched at ``{0}`` must be ``{1}``.'.format(human_list(all_paths, 'and'), sum_total))
                            else:
                                out.append('The sum of values matched at ``{0}`` must be ``{2}``.'.format(case_path, sum_total))
                        else: print('Not implemented', case_path, rule, case['paths'])
            elif rule == 'date_order':
                if show_all or simplify_xpath(case['less']) == reduced_path or simplify_xpath(case['more']) == reduced_path:
                    if case['less'] == 'NOW':
                        out.append('``{0}`` must not be in the past.'.format(case['more']))
                    elif case['more'] == 'NOW':
                        out.append('``{0}`` must not be in the future.'.format(case['less']))
                    else:
                        out.append('``{0}`` must be before or the same as ``{1}``'.format(case['less'], case['more']))
            else: print('Not implemented', case_path, rule, case['paths'])
    return out

