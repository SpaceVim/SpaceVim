"""
Tests for :attr:`.BaseName.full_name`.

There are three kinds of test:

#. Test classes derived from :class:`MixinTestFullName`.
   Child class defines :attr:`.operation` to alter how
   the api definition instance is created.

#. :class:`TestFullDefinedName` is to test combination of
   ``obj.full_name`` and ``jedi.defined_names``.

#. Misc single-function tests.
"""

import textwrap
from unittest import TestCase

import pytest

import jedi


class MixinTestFullName(object):
    operation = None

    @pytest.fixture(autouse=True)
    def init(self, Script, environment):
        self.Script = Script
        self.environment = environment

    def check(self, source, desired):
        script = self.Script(textwrap.dedent(source))
        definitions = getattr(script, self.operation)()
        for d in definitions:
            self.assertEqual(d.full_name, desired)

    def test_os_path_join(self):
        self.check('import os; os.path.join', 'os.path.join')

    def test_builtin(self):
        self.check('TypeError', 'builtins.TypeError')


class TestFullNameWithGotoDefinitions(MixinTestFullName, TestCase):
    operation = 'infer'

    def test_tuple_mapping(self):
        self.check("""
        import re
        any_re = re.compile('.*')
        any_re""", 'typing.Pattern')

    def test_from_import(self):
        self.check('from os import path', 'os.path')


class TestFullNameWithCompletions(MixinTestFullName, TestCase):
    operation = 'complete'


class TestFullDefinedName(TestCase):
    """
    Test combination of ``obj.full_name`` and ``jedi.Script.get_names``.
    """
    @pytest.fixture(autouse=True)
    def init(self, environment):
        self.environment = environment

    def check(self, source, desired):
        script = jedi.Script(textwrap.dedent(source), environment=self.environment)
        definitions = script.get_names()
        full_names = [d.full_name for d in definitions]
        self.assertEqual(full_names, desired)

    def test_local_names(self):
        self.check("""
        def f(): pass
        class C: pass
        """, ['__main__.f', '__main__.C'])

    def test_imports(self):
        self.check("""
        import os
        from os import path
        from os.path import join
        from os import path as opath
        """, ['os', 'os.path', 'os.path.join', 'os.path'])


def test_sub_module(Script, jedi_path):
    """
    ``full_name needs to check sys.path to actually find it's real path module
    path.
    """
    sys_path = [jedi_path]
    project = jedi.Project('.', sys_path=sys_path)
    defs = Script('from jedi.api import classes; classes', project=project).infer()
    assert [d.full_name for d in defs] == ['jedi.api.classes']
    defs = Script('import jedi.api; jedi.api', project=project).infer()
    assert [d.full_name for d in defs] == ['jedi.api']


def test_os_path(Script):
    d, = Script('from os.path import join').complete()
    assert d.full_name == 'os.path.join'
    d, = Script('import os.p').complete()
    assert d.full_name == 'os.path'


def test_os_issues(Script):
    """Issue #873"""
    # nt is not found, because it's deleted
    assert [c.name for c in Script('import os\nos.nt''').complete()] == []


def test_param_name(Script):
    name, = Script('class X:\n def foo(bar): bar''').goto()
    assert name.type == 'param'
    assert name.full_name is None


def test_variable_in_func(Script):
    names = Script('def f(): x = 3').get_names(all_scopes=True)
    x = names[-1]
    assert x.name == 'x'
    assert x.full_name == '__main__.f.x'
