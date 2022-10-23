#!/usr/bin/env python
"""
Refactoring tests work a little bit similar to integration tests. But the idea
is here to compare two versions of code. If you want to add a new test case,
just look at the existing ones in the ``test/refactor`` folder and copy them.
"""
import os
import platform
import re

from parso import split_lines

from functools import reduce
import jedi
from .helpers import test_dir


class RefactoringCase(object):

    def __init__(self, name, code, line_nr, index, path, kwargs, type_, desired_result):
        self.name = name
        self._code = code
        self._line_nr = line_nr
        self._index = index
        self._path = path
        self._kwargs = kwargs
        self.type = type_
        self._desired_result = desired_result

    def get_desired_result(self):

        if platform.system().lower() == 'windows' and self.type == 'diff':
            # Windows uses backslashes to separate paths.
            lines = split_lines(self._desired_result, keepends=True)
            for i, line in enumerate(lines):
                if re.search(' import_tree/', line):
                    lines[i] = line.replace('/', '\\')
            return ''.join(lines)
        return self._desired_result

    @property
    def refactor_type(self):
        f_name = os.path.basename(self._path)
        return f_name.replace('.py', '')

    def refactor(self, environment):
        project = jedi.Project(os.path.join(test_dir, 'refactor'))
        script = jedi.Script(self._code, path=self._path, project=project, environment=environment)
        refactor_func = getattr(script, self.refactor_type)
        return refactor_func(self._line_nr, self._index, **self._kwargs)

    def __repr__(self):
        return '<%s: %s:%s>' % (self.__class__.__name__,
                                self.name, self._line_nr - 1)


def _collect_file_tests(code, path, lines_to_execute):
    r = r'^# -{5,} ?([^\n]*)\n((?:(?!\n# \+{5,}).)*\n)' \
        r'# \+{5,}\n((?:(?!\n# -{5,}).)*\n)'
    match = None
    for match in re.finditer(r, code, re.DOTALL | re.MULTILINE):
        name = match.group(1).strip()
        first = match.group(2)
        second = match.group(3)

        # get the line with the position of the operation
        p = re.match(r'((?:(?!#\?).)*)#\? (\d*)( error| text|) ?([^\n]*)', first, re.DOTALL)
        if p is None:
            raise Exception("Please add a test start.")
            continue
        until = p.group(1)
        index = int(p.group(2))
        type_ = p.group(3).strip() or 'diff'
        if p.group(4):
            kwargs = eval(p.group(4))
        else:
            kwargs = {}

        line_nr = until.count('\n') + 2
        if lines_to_execute and line_nr - 1 not in lines_to_execute:
            continue

        yield RefactoringCase(name, first, line_nr, index, path, kwargs, type_, second)
    if match is None:
        raise Exception(f"Didn't match any test for {path}, {code!r}")
    if match.end() != len(code):
        raise Exception(f"Didn't match until the end of the file in {path}")


def collect_dir_tests(base_dir, test_files):
    for f_name in os.listdir(base_dir):
        files_to_execute = [a for a in test_files.items() if a[0] in f_name]
        lines_to_execute = reduce(lambda x, y: x + y[1], files_to_execute, [])
        if f_name.endswith(".py") and (not test_files or files_to_execute):
            path = os.path.join(base_dir, f_name)
            with open(path, newline='') as f:
                code = f.read()
            for case in _collect_file_tests(code, path, lines_to_execute):
                yield case
