from __future__ import print_function
import re
import copy

def human_list(other_paths, separator='or'):
    if len(other_paths) == 1:
        return other_paths[0]
    else:
        return '`` {0} ``'.format(separator).join(other_paths)

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
                                break
                        elif rule == 'atleast_one':
                            if other_paths:
                                out.append('Either ``{0}`` or ``{1}`` must be present.'.format(case_path, human_list(other_paths)))
                                break
                            else:
                                out.append('``{0}`` must be present.'.format(case_path))
                        elif rule == 'only_one_of':
                            out.append('``{0}`` must not be present alongisde ``{1}``.'.format(case_path, human_list(case['excluded'], 'and')))
                        elif rule == 'startswith':
                            out.append('``{0}`` should start with the value in ``{1}``'.format(case_path, case['start']))
                        elif rule == 'regex_matches':
                            out.append('``{0}`` should match the regex ``{1}``'.format(case_path, case['regex']))
                        elif rule == 'sum':
                            sum_total = case['sum']
                            if other_paths:
                                out.append('The sum of values matched at ``{0}`` and ``{1}`` must be ``{2}``.'.format(case_path, human_list(other_paths, 'and'), sum_total))
                                break
                            else:
                                out.append('The sum of values matched at ``{0}`` must be ``{2}``.'.format(case_path, sum_total))
                        elif rule == 'strict_sum':
                            out.append('The sum of values matched at ``{0}`` must be ``{1}``.'.format(case_path, case['sum']))
                        elif rule == 'no_percent':
                            out.append('```{0}``` must not contain a ``%`` sign.'.format(case_path))
                        elif rule == 'evaluates_to_true':
                            out.append('The conditional expression must evaluate to true.')
                        elif rule == 'date_order':
                            if show_all or simplify_xpath(case['less']) == reduced_path or simplify_xpath(case['more']) == reduced_path:
                                if case['less'] == 'NOW':
                                    out.append('``{0}`` must not be in the past.'.format(case['more']))
                                elif case['more'] == 'NOW':
                                    out.append('``{0}`` must not be in the future.'.format(case['less']))
                                else:
                                    out.append('``{0}`` must be before or the same as ``{1}``'.format(case['less'], case['more']))
                        elif rule == 'time_limit':
                            out.append('The time between ``{0}`` and {1} must not be over a year'.format(case['start'], case['end']))
                        elif rule == 'date_now':
                            out.append('``{0}`` must not be more recent than the current date'.format(case['date']))
                        elif rule == 'if_then':
                            out.append('If ``{0}`` evaluates to true, then ``{1}`` must evaluate to true.'.format(case['if'], case['then']))
                        elif rule == 'one_or_all':
                            out.append('``{0}`` must exist, otherwise all ``{1}`` must exist.'.format(case['one'], case['all']))
                        elif rule == 'evaluates_to_true':
                            out.append('Each expression defined in ``{0}`` must resolve to true.'.format(case['eval']))
                        elif rule == 'between_dates':
                            out.append('The ``{0}`` must be between the ``{1}`` and ``{2}`` dates.'.format(case['date'],case['start'],case['end']))
                        elif rule == 'loop':
                            out.append('All elements in ``{0}`` are evaluated under the rules inside ``{1}``.'.format(case['foreach'],case['do']))
                        else:
                            print('Not implemented', case_path, rule, case['paths'])
    return out
