"""
To easily verify if our normalizer raises the right error codes, just use the
tests of pydocstyle.
"""

import difflib
import re
from functools import total_ordering
from typing import Iterator, Tuple

import parso
from parso.utils import python_bytes_to_unicode


@total_ordering
class WantedIssue:
    def __init__(self, code: str, line: int, column: int) -> None:
        self.code = code
        self._line = line
        self._column = column

    def __eq__(self, other):
        return self.code == other.code and self.start_pos == other.start_pos

    def __lt__(self, other: 'WantedIssue') -> bool:
        return self.start_pos < other.start_pos or self.code < other.code

    def __hash__(self) -> int:
        return hash(str(self.code) + str(self._line) + str(self._column))

    @property
    def start_pos(self) -> Tuple[int, int]:
        return self._line, self._column


def collect_errors(code: str) -> Iterator[WantedIssue]:
    for line_nr, line in enumerate(code.splitlines(), 1):
        match = re.match(r'(\s*)#: (.*)$', line)
        if match is not None:
            codes = match.group(2)
            for code in codes.split():
                code, _, add_indent = code.partition(':')
                column = int(add_indent or len(match.group(1)))

                code, _, add_line = code.partition('+')
                ln = line_nr + 1 + int(add_line or 0)

                yield WantedIssue(code[1:], ln, column)


def test_normalizer_issue(normalizer_issue_case):
    def sort(issues):
        issues = sorted(issues, key=lambda i: (i.start_pos, i.code))
        return ["(%s, %s): %s" % (i.start_pos[0], i.start_pos[1], i.code)
                for i in issues]

    with open(normalizer_issue_case.path, 'rb') as f:
        code = python_bytes_to_unicode(f.read())

    desired = sort(collect_errors(code))

    grammar = parso.load_grammar(version=normalizer_issue_case.python_version)
    module = grammar.parse(code)
    issues = grammar._get_normalizer_issues(module)
    actual = sort(issues)

    diff = '\n'.join(difflib.ndiff(desired, actual))
    # To make the pytest -v diff a bit prettier, stop pytest to rewrite assert
    # statements by executing the comparison earlier.
    _bool = desired == actual
    assert _bool, '\n' + diff
