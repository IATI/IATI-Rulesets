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
                            cond = case.get('condition', None)
                            cond = '.' if not cond else ' if {}'.format(cond)
                            
                            if other_paths:
                                out.append('Either ``{0}`` or ``{1}`` must be present{2}'.format(case_path, human_list(other_paths), cond))
                                break
                            else:
                                out.append('``{0}`` must be present{1}'.format(case_path, cond))
                        elif rule == 'only_one_of':
                            out.append('``{0}`` must not be present alongisde ``{1}``.'.format(case_path, human_list(case['excluded'], 'and')))
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
                                out.append('The sum of values matched at ``{0}`` and ``{1}`` must be ``{2}``.'.format(case_path, human_list(other_paths, 'and'), sum_total))
                                break
                            else:
                                out.append('The sum of values matched at ``{0}`` must be ``{2}``.'.format(case_path, sum_total))
                        elif rule == 'strict_sum':
                            out.append('The sum of values matched at ``{0}`` must be ``{1}``.'.format(case_path, case['sum']))
                        elif rule == 'no_percent':
                            out.append('``{0}`` must not contain a ``%`` sign.'.format(case_path))
                        elif rule == 'range':
                            out.append('The value of each of the elements described by ``paths`` must be at least ``min`` and no more than ``max`` (inclusive).')
                        else:
                            print('Not implemented', rule, reduced_path)
            else:
                # rather than checking line-by-line wether reduced_path is in either one of the specific cases
                # we do a generic check to assess we're rendering the right rule for the right element
                if rule == 'date_order':
                    if show_all or reduced_path == case['less'] or reduced_path == case['more']:
                        if case['less'] == 'NOW':
                            out.append('``{0}`` must not be in the past.'.format(case['more']))
                        elif case['more'] == 'NOW':
                            out.append('``{0}`` must not be in the future.'.format(case['less']))
                        else:
                            out.append('``{0}`` must be before or the same as ``{1}``'.format(case['less'], case['more']))
                
                elif rule == 'time_limit':
                    if show_all or reduced_path == case['start'] or reduced_path == case['end']:
                        out.append('The time between ``{0}`` and ``{1}`` must not be over a year'.format(case['start'], case['end']))
                
                elif rule == 'date_now':
                    if show_all or reduced_path == case['date']:
                        out.append('``{0}`` must not be more recent than the current date'.format(case['date']))
                
                elif rule == 'if_then':
                    if_case = extract_from_expr(case['if'])
                    if show_all or (if_case.startswith(reduced_path) or if_case.endswith(reduced_path)):
                        out.append('If ``{0}`` evaluates to true, then ``{1}`` must evaluate to true.'.format(case['if'], case['then']))
                
                elif rule == 'one_or_all':
                    if show_all or reduced_path == case['one']:
                        out.append('``{0}`` must exist, otherwise all ``{1}`` must exist.'.format(case['one'], case['all']))
                
                elif rule == 'evaluates_to_true':
                    eval_case = extract_from_expr(case['eval'])
                    if show_all or (eval_case.startswith(reduced_path) or eval_case.endswith(reduced_path)):
                        out.append('``{0}`` must resolve to true.'.format(case['eval']))
                
                elif rule == 'between_dates':
                    if show_all or reduced_path == case['date']:
                        out.append('The ``{0}`` must be between the ``{1}`` and ``{2}`` dates.'.format(case['date'],case['start'],case['end']))
                
                elif rule == 'loop':
                    continue
                #   commenting this out and skipping until the way we render this is fixed
                #   out.append('All elements in ``{0}`` are evaluated under the rules inside ``{1}``.'.format(case['foreach'],case['do']))
                else:
                    print('Not implemented', rule, reduced_path)
    return out
