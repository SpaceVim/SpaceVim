#!/usr/bin/env python3
"""
|jedi| is mostly being tested by what I would call "integration tests". These
tests are testing type inference with the public API. This makes a
lot of sense for |jedi|. Also, it is hard to write doctests/unittests for
the internal data structures.

There are different kinds of tests:

- completions / inference ``#?``
- goto: ``#!``
- references: ``#<``

How to run tests?
+++++++++++++++++

Jedi uses pytest_ to run unit and integration tests.  To run tests,
simply run ``pytest``.

.. _pytest: http://pytest.org

Most integration test cases are located in the ``test/completion`` directory
and each test case starts with one of these comments:

- ``#?`` (completions / inference)
- ``#!`` (goto)
- ``#<`` (references)

There is also support for third party libraries. In a normal test run they are
not being executed, you have to provide a ``--thirdparty`` option.

In addition to pytest's ``-k`` and ``-m`` options, you can use the
``-T`` (``--test-files`) option to specify which test cases should run.
It takes the format of ``FILE_NAME[:LINE[,LINE[,...]]]`` where
``FILE_NAME`` is a file in ``test/completion`` and ``LINE`` is a line
number of the test comment.  Here are some examples:

Run tests only in ``completion/basic.py`` and ``completion/imports.py``::

    pytest test/test_integration.py -T basic.py -T imports.py

Run test at line 4, 6, and 8 in ``completion/basic.py``::

    pytest test/test_integration.py -T basic.py:4,6,8

See ``pytest --help`` for more information.

If you want to debug a test, just use the ``--pdb`` option.

Alternate Test Runner
+++++++++++++++++++++

If you don't like the output of ``pytest``, there's an alternate test runner
that you can start by running ``./run.py``. The above example could be run by::

    ./run.py basic 4 6 8 50-80

The advantage of this runner is simplicity and more customized error reports.

Auto-Completion Tests
+++++++++++++++++++++

Uses a comment to specify a test on the next line. The comment defines the
expected completions. The comment always begins with `#?`. The last row
symbolizes the cursor. For example::

    #? ['upper']
    a = 'foo'; a.upp

Inference Tests
+++++++++++++++

Inference tests look very simliar. The difference is that inference tests don't
use brackets::

    #? int()
    ab = 3; ab

Goto Tests
++++++++++

Goto Tests look like this::

    abc = 1
    #! ['abc=1']
    abc

Additionally it is possible to specify the column by adding a number, which
describes the position of the test (otherwise it's just the end of line)::

    #! 2 ['abc=1']
    abc

Reference Tests
+++++++++++++++

Tests look like this::

    abc = 1
    #< (1,0), (3,0)
    abc
"""
import os
import re
import sys
import operator
if sys.version_info < (3, 8):
    literal_eval = eval
else:
    from ast import literal_eval
from io import StringIO
from functools import reduce
from unittest.mock import ANY
from pathlib import Path

import parso
from _pytest.outcomes import Skipped
import pytest

import jedi
from jedi import debug
from jedi.api.classes import Name
from jedi.api.completion import get_user_context
from jedi import parser_utils
from jedi.api.environment import get_default_environment, get_system_environment
from jedi.inference.gradual.conversion import convert_values
from jedi.inference.analysis import Warning

test_dir = Path(__file__).absolute().parent

TEST_COMPLETIONS = 0
TEST_INFERENCE = 1
TEST_GOTO = 2
TEST_REFERENCES = 3


grammar36 = parso.load_grammar(version='3.6')


class BaseTestCase(object):
    def __init__(self, skip_version_info=None):
        self._skip_version_info = skip_version_info
        self._skip = None

    def set_skip(self, reason):
        self._skip = reason

    def get_skip_reason(self, environment):
        if self._skip is not None:
            return self._skip

        if self._skip_version_info is None:
            return

        comp_map = {
            '==': 'eq',
            '<=': 'le',
            '>=': 'ge',
            '<': 'lt',
            '>': 'gt',
        }
        min_version, operator_ = self._skip_version_info
        operation = getattr(operator, comp_map[operator_])
        if not operation(environment.version_info[:2], min_version):
            return "Python version %s %s.%s" % (
                operator_, min_version[0], min_version[1]
            )


class IntegrationTestCase(BaseTestCase):
    def __init__(self, test_type, correct, line_nr, column, start, line,
                 path=None, skip_version_info=None):
        super().__init__(skip_version_info)
        self.test_type = test_type
        self.correct = correct
        self.line_nr = line_nr
        self.column = column
        self.start = start
        self.line = line
        self.path = path
        self._project = jedi.Project(test_dir)

    @property
    def module_name(self):
        return os.path.splitext(os.path.basename(self.path))[0]

    @property
    def line_nr_test(self):
        """The test is always defined on the line before."""
        return self.line_nr - 1

    def __repr__(self):
        return '<%s: %s:%s %r>' % (self.__class__.__name__, self.path,
                                   self.line_nr_test, self.line.rstrip())

    def script(self, environment):
        return jedi.Script(
            self.source,
            path=self.path,
            environment=environment,
            project=self._project
        )

    def run(self, compare_cb, environment=None):
        testers = {
            TEST_COMPLETIONS: self.run_completion,
            TEST_INFERENCE: self.run_inference,
            TEST_GOTO: self.run_goto,
            TEST_REFERENCES: self.run_get_references,
        }
        if (self.path.endswith('pytest.py') or self.path.endswith('conftest.py')) \
                and environment.executable != os.path.realpath(sys.executable):
            # It's not guarantueed that pytest is installed in test
            # environments, if we're not running in the same environment that
            # we're already in, so just skip that case.
            pytest.skip()
        return testers[self.test_type](compare_cb, environment)

    def run_completion(self, compare_cb, environment):
        completions = self.script(environment).complete(self.line_nr, self.column)
        # import cProfile; cProfile.run('...')

        comp_str = {c.name for c in completions}
        for r in completions:
            # Test if this access raises an error
            assert isinstance(r.type, str)
        return compare_cb(self, comp_str, set(literal_eval(self.correct)))

    def run_inference(self, compare_cb, environment):
        script = self.script(environment)
        inference_state = script._inference_state

        def comparison(definition):
            suffix = '()' if definition.type == 'instance' else ''
            return definition.full_name + suffix

        def definition(correct, correct_start, path):
            should_be = set()
            for match in re.finditer('(?:[^ ]+)', correct):
                string = match.group(0)
                parser = grammar36.parse(string, start_symbol='eval_input', error_recovery=False)
                parser_utils.move(parser.get_root_node(), self.line_nr)
                node = parser.get_root_node()
                module_context = script._get_module_context()
                user_context = get_user_context(module_context, (self.line_nr, 0))
                node.parent = user_context.tree_node
                results = convert_values(user_context.infer_node(node))
                if not results:
                    raise Exception('Could not resolve %s on line %s'
                                    % (match.string, self.line_nr - 1))

                should_be |= set(Name(inference_state, r.name) for r in results)
            debug.dbg('Finished getting types', color='YELLOW')

            # Because the objects have different ids, `repr`, then compare.
            should = set(comparison(r) for r in should_be)
            return should

        should = definition(self.correct, self.start, script.path)
        result = script.infer(self.line_nr, self.column)
        is_str = set(comparison(r) for r in result)
        for r in result:
            # Test if this access raises an error
            assert isinstance(r.type, str)
        return compare_cb(self, is_str, should)

    def run_goto(self, compare_cb, environment):
        result = self.script(environment).goto(self.line_nr, self.column)
        comp_str = str(sorted(str(r.description) for r in result))
        return compare_cb(self, comp_str, self.correct)

    def run_get_references(self, compare_cb, environment):
        result = self.script(environment).get_references(self.line_nr, self.column)
        self.correct = self.correct.strip()
        compare = sorted(
            (('stub:' if r.is_stub() else '')
             + re.sub(r'^completion\.', '', r.module_name),
             r.line,
             r.column)
            for r in result
        )
        wanted = []
        if not self.correct:
            positions = []
        else:
            positions = literal_eval(self.correct)
        for pos_tup in positions:
            if type(pos_tup[0]) == str:
                # this means that there is a module specified
                if pos_tup[1] == ...:
                    pos_tup = pos_tup[0], ANY, pos_tup[2]
                wanted.append(pos_tup)
            else:
                line = pos_tup[0]
                if pos_tup[0] is not None:
                    line += self.line_nr
                wanted.append((self.module_name, line, pos_tup[1]))

        return compare_cb(self, compare, sorted(wanted))


class StaticAnalysisCase(BaseTestCase):
    """
    Static Analysis cases lie in the static_analysis folder.
    The tests also start with `#!`, like the inference tests.
    """
    def __init__(self, path):
        self._path = path
        self.name = os.path.basename(path)
        with open(path) as f:
            self._source = f.read()

        skip_version_info = None
        for line in self._source.splitlines():
            skip_version_info = skip_python_version(line) or skip_version_info

        super().__init__(skip_version_info)

    def collect_comparison(self):
        cases = []
        for line_nr, line in enumerate(self._source.splitlines(), 1):
            match = re.match(r'(\s*)#! (\d+ )?(.*)$', line)
            if match is not None:
                column = int(match.group(2) or 0) + len(match.group(1))
                cases.append((line_nr + 1, column, match.group(3)))
        return cases

    def run(self, compare_cb, environment):
        def typ_str(inst):
            return 'warning ' if isinstance(inst, Warning) else ''

        analysis = jedi.Script(
            self._source,
            path=self._path,
            environment=environment,
        )._analysis()
        analysis = [(r.line, r.column, typ_str(r) + r.name)
                    for r in analysis]
        compare_cb(self, analysis, self.collect_comparison())

    def __repr__(self):
        return "<%s: %s>" % (self.__class__.__name__, os.path.basename(self._path))


def skip_python_version(line):
    # check for python minimal version number
    match = re.match(r" *# *python *([<>]=?|==) *(\d+(?:\.\d+)?)$", line)
    if match:
        minimal_python_version = tuple(map(int, match.group(2).split(".")))
        return minimal_python_version, match.group(1)
    return None


def collect_file_tests(path, lines, lines_to_execute):
    def makecase(t):
        return IntegrationTestCase(t, correct, line_nr, column,
                                   start, line, path=path,
                                   skip_version_info=skip_version_info)

    start = None
    correct = None
    test_type = None
    skip_version_info = None
    for line_nr, line in enumerate(lines, 1):
        if correct is not None:
            r = re.match(r'^(\d+)\s*(.*)$', correct)
            if r:
                column = int(r.group(1))
                correct = r.group(2)
                start += r.regs[2][0]  # second group, start index
            else:
                column = len(line) - 1  # -1 for the \n
            if test_type == '!':
                yield makecase(TEST_GOTO)
            elif test_type == '<':
                yield makecase(TEST_REFERENCES)
            elif correct.startswith('['):
                yield makecase(TEST_COMPLETIONS)
            else:
                yield makecase(TEST_INFERENCE)
            correct = None
        else:
            skip_version_info = skip_python_version(line) or skip_version_info
            try:
                r = re.search(r'(?:^|(?<=\s))#([?!<])\s*([^\n]*)', line)
                # test_type is ? for completion and ! for goto
                test_type = r.group(1)
                correct = r.group(2)
                # Quick hack to make everything work (not quite a bloody unicorn hack though).
                if correct == '':
                    correct = ' '
                start = r.start()
            except AttributeError:
                correct = None
            else:
                # Skip the test, if this is not specified test.
                for l in lines_to_execute:
                    if isinstance(l, tuple) and l[0] <= line_nr <= l[1] \
                            or line_nr == l:
                        break
                else:
                    if lines_to_execute:
                        correct = None


def collect_dir_tests(base_dir, test_files, check_thirdparty=False):
    for f_name in os.listdir(base_dir):
        files_to_execute = [a for a in test_files.items() if f_name.startswith(a[0])]
        lines_to_execute = reduce(lambda x, y: x + y[1], files_to_execute, [])
        if f_name.endswith(".py") and (not test_files or files_to_execute):
            skip = None
            if check_thirdparty:
                lib = f_name.replace('_.py', '')
                try:
                    # there is always an underline at the end.
                    # It looks like: completion/thirdparty/pylab_.py
                    __import__(lib)
                except ImportError:
                    skip = 'Thirdparty-Library %s not found.' % lib

            path = os.path.join(base_dir, f_name)

            with open(path, newline='') as f:
                source = f.read()

            for case in collect_file_tests(path, StringIO(source),
                                           lines_to_execute):
                case.source = source
                if skip:
                    case.set_skip(skip)
                yield case


docoptstr = """
Using run.py to make debugging easier with integration tests.

An alternative testing format, which is much more hacky, but very nice to
work with.

Usage:
    run.py [--pdb] [--debug] [--thirdparty] [--env <dotted>] [<rest>...]
    run.py --help

Options:
    -h --help       Show this screen.
    --pdb           Enable pdb debugging on fail.
    -d, --debug     Enable text output debugging (please install ``colorama``).
    --thirdparty    Also run thirdparty tests (in ``completion/thirdparty``).
    --env <dotted>  A Python version, like 3.9, 3.8, etc.
"""
if __name__ == '__main__':
    import docopt
    arguments = docopt.docopt(docoptstr)

    import time
    t_start = time.time()

    if arguments['--debug']:
        jedi.set_debug_function()

    # get test list, that should be executed
    test_files = {}
    last = None
    for arg in arguments['<rest>']:
        match = re.match(r'(\d+)-(\d+)', arg)
        if match:
            start, end = match.groups()
            test_files[last].append((int(start), int(end)))
        elif arg.isdigit():
            if last is None:
                continue
            test_files[last].append(int(arg))
        else:
            test_files[arg] = []
            last = arg

    # completion tests:
    dir_ = os.path.dirname(os.path.realpath(__file__))
    completion_test_dir = os.path.join(dir_, '../test/completion')
    completion_test_dir = os.path.abspath(completion_test_dir)
    tests_fail = 0

    # execute tests
    cases = list(collect_dir_tests(completion_test_dir, test_files))
    if test_files or arguments['--thirdparty']:
        completion_test_dir += '/thirdparty'
        cases += collect_dir_tests(completion_test_dir, test_files, True)

    def file_change(current, tests, fails):
        if current is None:
            current = ''
        else:
            current = os.path.basename(current)
        print('{:25} {} tests and {} fails.'.format(current, tests, fails))

    def report(case, actual, desired):
        if actual == desired:
            return 0
        else:
            print("\ttest fail @%d, actual = %s, desired = %s"
                  % (case.line_nr - 1, actual, desired))
            return 1

    if arguments['--env']:
        environment = get_system_environment(arguments['--env'])
    else:
        # Will be 3.6.
        environment = get_default_environment()

    import traceback
    current = cases[0].path if cases else None
    count = fails = 0
    for c in cases:
        if c.get_skip_reason(environment):
            continue
        if current != c.path:
            file_change(current, count, fails)
            current = c.path
            count = fails = 0

        try:
            if c.run(report, environment):
                tests_fail += 1
                fails += 1
        except Exception:
            traceback.print_exc()
            print("\ttest fail @%d" % (c.line_nr - 1))
            tests_fail += 1
            fails += 1
            if arguments['--pdb']:
                import pdb
                pdb.post_mortem()
        except Skipped:
            pass

        count += 1

    file_change(current, count, fails)

    print('\nSummary: (%s fails of %s tests) in %.3fs'
          % (tests_fail, len(cases), time.time() - t_start))

    exit_code = 1 if tests_fail else 0
    sys.exit(exit_code)
