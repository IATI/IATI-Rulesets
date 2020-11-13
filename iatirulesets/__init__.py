from __future__ import print_function
import re
import datetime
from lxml import etree as ET
from decimal import Decimal
from dateutil.relativedelta import relativedelta


def get_text(element_or_attribute):
    """ Helper function: Returns the text of the given lxml element or attribute """
    # use .text only after checking is an element
    if type(element_or_attribute) == ET._Element:
        return element_or_attribute.text
    else:
        return element_or_attribute


xsDateRegex = re.compile('(-?[0-9]{4,})-([0-9]{2})-([0-9]{2})')
xsDateTimeRegex = re.compile('(-?[0-9]{4,})-([0-9]{2})-([0-9]{2})T([0-9]{2}):([0-9]{2}):([0-9]{2})')


class Rules(object):
    def __init__(self, element, case):
        self.element = element
        if 'paths' in case:
            self.nested_matches = [element.xpath(path) for path in case['paths']]
            self.path_matches = sum(self.nested_matches, [])
            self.path_matches_text = list(map(get_text, self.path_matches))

    def no_more_than_one(self, case):
        return len(self.path_matches) <= 1

    def atleast_one(self, case):
        return len(self.path_matches) >= 1

    def only_one_of(self, case):
        for excluded in case['excluded']:
            if self.element.xpath(excluded):
                # no elements from group A can be present
                # if group B exists
                return not len(self.path_matches)
            else:
                # if no element from group B exists
                # then at least one and no more than one element
                # from group A can exist
                if len(self.path_matches) == 1:
                    return True
                else:
                    return False

    def one_or_all(self, case):
        if len(self.element.xpath(case['one'])) > 0:
            return True
        elif case['all'] == 'lang':
            for narrative in self.element.xpath("descendant::narrative"):
                if not narrative.xpath("@xml:lang"):
                    return False
        elif case['all'] == 'sector':
            for transaction in self.element.xpath("transaction"):
                if not transaction.xpath("sector"):
                    return False
        elif case['all'] == 'currency':
            currency_paths = ["value", "forecast", "loan-status"]
            for cpath in currency_paths:
                for currency in self.element.xpath("descendant::" + cpath):
                    if not currency.xpath("@currency"):
                        return False
        return True

    def dependent(self, case):
        return all(len(m) != 0 for m in self.nested_matches) or all(len(m) == 0 for m in self.nested_matches)

    def unique(self, case):
        return len(self.path_matches_text) <= len(set(self.path_matches_text))

    def strict_sum(self, case):
        return sum(map(Decimal, map(get_text, self.path_matches))) == Decimal(case['sum'])

    def loop(self, case):
        for rule, sub_cases in case['do'].items():
            for sub_case in sub_cases['cases']:
                subs = {sub: sub_case[sub] for sub in case['subs']}
                for val in list(set(self.element.xpath(case['foreach']))):
                    for k, v in subs.items():
                        if type(v) is list:
                            sub_case[k] = [vi.replace('$1', val) for vi in v]
                        else:
                            sub_case[k] = v.replace('$1', val)
                    result = test_rule(None, self.element, rule, sub_case)['result']
                    if not result:
                        return False
        return True

    def sum(self, case):
        return not(len(self.path_matches)) or sum(map(Decimal, map(get_text, self.path_matches))) == Decimal(case['sum'])

    def _parse_date(self, date_xpath):
        if date_xpath == 'TODAY':
            return datetime.date.today()
        else:
            date_elements = self.element.xpath(date_xpath)
            if len(date_elements) < 1:
                return None
            date_text = date_elements[0]
            if date_text:
                m1 = xsDateRegex.match(date_text)
                return datetime.date(*map(int, m1.groups()))
            else:
                return None

    def date_order(self, case):
        less = self._parse_date(case['less'])
        more = self._parse_date(case['more'])
        if less is None or more is None:
            return None
        else:
            return less <= more

    def time_limit(self, case):
        if self.element.xpath(case['start']) and self.element.xpath(case['end']):
            start = self._parse_date(case['start'])
            end = self._parse_date(case['end'])
            delta = relativedelta(end, start)
            if delta.years == 1:
                return (delta.years + delta.months + delta.days) <= 1
            return (relativedelta(end, start).years) <= 1

    def date_now(self, case):
        datetime_element = self.element.xpath(case['date'])
        if len(datetime_element) > 0:
            m1 = xsDateTimeRegex.match(datetime_element[0])
            mapped_datetime = datetime.datetime(*map(int, m1.groups()))
            return mapped_datetime < datetime.datetime.now()
        else:
            return None

    def between_dates(self, case):
        if self.element.xpath(case['date']):
            return self._parse_date(case['start']) < self._parse_date(case['date']) < self._parse_date(case['end'])

    def _regex_matches(self, case):
        return [re.search(case['regex'], get_text(path_match)) for path_match in self.path_matches]

    def regex_matches(self, case):
        return all([m is not None for m in self._regex_matches(case)])

    def regex_no_matches(self, case):
        return all([m is None for m in self._regex_matches(case)])

    def startswith(self, case):
        start = get_text(self.element.xpath(case['start'])[0])
        for path_match in self.path_matches:
            if not get_text(path_match).startswith(start):
                return False
        return True

    def no_percent(self, case):
        return all("%" not in item for item in self.path_matches_text)

    def if_then(self, case):
        return self.element.xpath(case['then']) if self.element.xpath(case['if']) else True

    def range(self, case):
        # if min/max are missing, we use val as the sentinel
        # so we can check also that val is at_least_value or no_more_than_value
        return all(
            [
                Decimal(case.get('min', val)) <= Decimal(val) <= Decimal(case.get('max', val))
                for val in self.path_matches_text
            ]
        )


def test_rule(context_xpath, element, rule, case):
    """
    Tests a specific rule type for a specific case.

    """
    if 'condition' in case and not element.xpath(case['condition']):
        result = None
    else:
        rules_ = Rules(element, case)
        result = getattr(rules_, rule)(case)
    return {
        'result': result,
        'element': element,
        'context': context_xpath,
        'rule': rule,
        'case': case
    }


def test_ruleset_verbose(ruleset, tree):
    for context_xpath, rules in ruleset.items():
        for element in tree.xpath(context_xpath):
            for rule in rules:
                cases = rules[rule]['cases']
                for case in cases:
                    yield test_rule(context_xpath, element, rule, case)


def test_ruleset(ruleset, tree, verbose=False):
    """
    Default behaviour: Returns ``True`` or ``False`` depending on whether a ruleset passes or fails.

    If verbose=True: Returns an iterator which yields a dictionary for each test.

    """
    if verbose:
        return test_ruleset_verbose(ruleset, tree)
    else:
        return all(x['result'] for x in test_ruleset_verbose(ruleset, tree) if x['result'] is not None)


def test_ruleset_subelement(ruleset, element, *args, **kwargs):
    fakeroot = ET.Element('fakeroot')
    fakeroot.append(element)
    return test_ruleset(ruleset, ET.ElementTree(fakeroot), *args, **kwargs)
