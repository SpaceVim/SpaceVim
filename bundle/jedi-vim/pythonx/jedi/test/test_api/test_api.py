"""
Test all things related to the ``jedi.api`` module.
"""

import os
from textwrap import dedent

import pytest
from pytest import raises
from parso import cache

from jedi import preload_module
from jedi.inference.gradual import typeshed
from test.helpers import test_dir, get_example_dir


def test_preload_modules():
    def check_loaded(*module_names):
        for grammar_cache in cache.parser_cache.values():
            if None in grammar_cache:
                break
        # Filter the typeshed parser cache.
        typeshed_cache_count = sum(
            1 for path in grammar_cache
            if path is not None and str(path).startswith(str(typeshed.TYPESHED_PATH))
        )
        # +1 for None module (currently used)
        assert len(grammar_cache) - typeshed_cache_count == len(module_names) + 1
        for i in module_names:
            assert [i in str(k) for k in grammar_cache.keys() if k is not None]

    old_cache = cache.parser_cache.copy()
    cache.parser_cache.clear()

    try:
        preload_module('sys')
        check_loaded()  # compiled (c_builtin) modules shouldn't be in the cache.
        preload_module('types', 'token')
        check_loaded('types', 'token')
    finally:
        cache.parser_cache.update(old_cache)


def test_empty_script(Script):
    assert Script('')


def test_line_number_errors(Script):
    """
    Script should raise a ValueError if line/column numbers are not in a
    valid range.
    """
    s = 'hello'
    # lines
    with raises(ValueError):
        Script(s).complete(2, 0)
    with raises(ValueError):
        Script(s).complete(0, 0)

    # columns
    with raises(ValueError):
        Script(s).infer(1, len(s) + 1)
    with raises(ValueError):
        Script(s).goto(1, -1)

    # ok
    Script(s).get_signatures(1, 0)
    Script(s).get_references(1, len(s))


def _check_number(Script, source, result='float'):
    completions = Script(source).complete()
    assert completions[0].parent().name == result


def test_completion_on_number_literals(Script):
    # No completions on an int literal (is a float).
    assert [c.name for c in Script('1. ').complete()] \
        == ['and', 'if', 'in', 'is', 'not', 'or']

    # Multiple points after an int literal basically mean that there's a float
    # and a call after that.
    _check_number(Script, '1..')
    _check_number(Script, '1.0.')

    # power notation
    _check_number(Script, '1.e14.')
    _check_number(Script, '1.e-3.')
    _check_number(Script, '9e3.')
    assert Script('1.e3..').complete() == []
    assert Script('1.e-13..').complete() == []


def test_completion_on_hex_literals(Script):
    assert Script('0x1..').complete() == []
    _check_number(Script, '0x1.', 'int')  # hexdecimal
    # Completing binary literals doesn't work if they are not actually binary
    # (invalid statements).
    assert Script('0b2.b').complete() == []
    _check_number(Script, '0b1.', 'int')  # binary

    _check_number(Script, '0x2e.', 'int')
    _check_number(Script, '0xE7.', 'int')
    _check_number(Script, '0xEa.', 'int')
    # theoretically, but people can just check for syntax errors:
    assert Script('0x.').complete() == []


def test_completion_on_complex_literals(Script):
    assert Script('1j..').complete() == []
    _check_number(Script, '1j.', 'complex')
    _check_number(Script, '44.j.', 'complex')
    _check_number(Script, '4.0j.', 'complex')
    # No dot no completion - I thought, but 4j is actually a literal after
    # which a keyword like or is allowed. Good times, haha!
    # However this has been disabled again, because it apparently annoyed
    # users. So no completion after j without a space :)
    assert not Script('4j').complete()
    assert ({c.name for c in Script('4j ').complete()}
            == {'if', 'and', 'in', 'is', 'not', 'or'})


def test_goto_non_name(Script, environment):
    assert Script('for').goto() == []

    assert Script('assert').goto() == []
    assert Script('True').goto() == []


def test_infer_on_non_name(Script):
    assert Script('import x').infer(column=0) == []


def test_infer_on_generator(Script, environment):
    script = Script('def x(): yield 1\ny=x()\ny')
    def_, = script.infer()
    assert def_.name == 'Generator'
    def_, = script.infer(only_stubs=True)
    assert def_.name == 'Generator'


def test_goto_definition_not_multiple(Script):
    """
    There should be only one result if it leads back to the same
    origin (e.g. instance method)
    """

    s = dedent('''\
            import random
            class A():
                def __init__(self, a):
                    self.a = 3

                def foo(self):
                    pass

            if random.randint(0, 1):
                a = A(2)
            else:
                a = A(1)
            a''')
    assert len(Script(s).infer()) == 1


def test_reference_description(Script):
    descs = [u.description for u in Script("foo = ''; foo").get_references()]
    assert set(descs) == {"foo = ''", 'foo'}


def test_get_line_code(Script):
    def get_line_code(source, line=None, **kwargs):
        # On Windows replace \r
        return Script(source).complete(line=line)[0].get_line_code(**kwargs).replace('\r', '')

    # On builtin
    assert get_line_code('abs') == 'def abs(__x: SupportsAbs[_T]) -> _T: ...\n'

    # On custom code
    first_line = 'def foo():\n'
    line = '    foo'
    code = first_line + line
    assert get_line_code(code) == first_line

    # With before/after
    code = code + '\nother_line'
    assert get_line_code(code, line=2) == first_line
    assert get_line_code(code, line=2, after=1) == first_line + line + '\n'
    assert get_line_code(code, line=2, after=2, before=1) == code
    # Should just be the whole thing, since there are no more lines on both
    # sides.
    assert get_line_code(code, line=2, after=3, before=3) == code


def test_get_line_code_on_builtin(Script, disable_typeshed):
    abs_ = Script('abs').complete()[0]
    assert abs_.name == 'abs'
    assert abs_.get_line_code() == ''
    assert abs_.line is None


def test_goto_follow_imports(Script):
    code = dedent("""
    import inspect
    inspect.isfunction""")
    definition, = Script(code).goto(column=0, follow_imports=True)
    assert definition.module_path.name == 'inspect.py'
    assert (definition.line, definition.column) == (1, 0)

    definition, = Script(code).goto(follow_imports=True)
    assert definition.module_path.name == 'inspect.py'
    assert (definition.line, definition.column) > (1, 0)

    code = '''def param(p): pass\nparam(1)'''
    start_pos = 1, len('def param(')

    script = Script(code)
    definition, = script.goto(*start_pos, follow_imports=True)
    assert (definition.line, definition.column) == start_pos
    assert definition.name == 'p'
    result, = definition.goto()
    assert result.name == 'p'
    result, = definition.infer()
    assert result.name == 'int'
    result, = result.infer()
    assert result.name == 'int'

    definition, = script.goto(*start_pos)
    assert (definition.line, definition.column) == start_pos

    d, = Script('a = 1\na').goto(follow_imports=True)
    assert d.name == 'a'


def test_goto_module(Script):
    def check(line, expected, follow_imports=False):
        script = Script(path=path)
        module, = script.goto(line=line, follow_imports=follow_imports)
        assert module.module_path == expected

    base_path = get_example_dir('simple_import')
    path = base_path.joinpath('__init__.py')

    check(1, base_path.joinpath('module.py'))
    check(1, base_path.joinpath('module.py'), follow_imports=True)
    check(5, base_path.joinpath('module2.py'))


def test_goto_definition_cursor(Script):

    s = ("class A():\n"
         "    def _something(self):\n"
         "        return\n"
         "    def different_line(self,\n"
         "                   b):\n"
         "        return\n"
         "A._something\n"
         "A.different_line"
         )

    in_name = 2, 9
    under_score = 2, 8
    cls = 2, 7
    should1 = 7, 10
    diff_line = 4, 10
    should2 = 8, 10

    def get_def(pos):
        return [d.description for d in Script(s).infer(*pos)]

    in_name = get_def(in_name)
    under_score = get_def(under_score)
    should1 = get_def(should1)
    should2 = get_def(should2)

    diff_line = get_def(diff_line)

    assert should1 == in_name
    assert should1 == under_score

    assert should2 == diff_line

    assert get_def(cls) == []


def test_no_statement_parent(Script):
    source = dedent("""
    def f():
        pass

    class C:
        pass

    variable = f if random.choice([0, 1]) else C""")
    defs = Script(source).infer(column=3)
    defs = sorted(defs, key=lambda d: d.line)
    assert [d.description for d in defs] == ['def f', 'class C']


def test_backslash_continuation_and_bracket(Script):
    code = dedent(r"""
    x = 0
    a = \
      [1, 2, 3, (x)]""")

    lines = code.splitlines()
    column = lines[-1].index('(')
    def_, = Script(code).infer(line=len(lines), column=column)
    assert def_.name == 'int'


def test_goto_follow_builtin_imports(Script):
    s = Script('import sys; sys')
    d, = s.goto(follow_imports=True)
    assert d.in_builtin_module() is True
    d, = s.goto(follow_imports=True, follow_builtin_imports=True)
    assert d.in_builtin_module() is True


def test_docstrings_for_completions(Script):
    for c in Script('').complete():
        assert isinstance(c.docstring(), str)


def test_fuzzy_completion(Script):
    script = Script('string =  "hello"\nstring.upper')
    assert ['isupper',
            'upper'] == [comp.name for comp in script.complete(fuzzy=True)]


def test_math_fuzzy_completion(Script, environment):
    script = Script('import math\nmath.og')
    expected = ['copysign', 'log', 'log10', 'log1p', 'log2']
    completions = script.complete(fuzzy=True)
    assert expected == [comp.name for comp in completions]
    for c in completions:
        assert c.complete is None


def test_file_fuzzy_completion(Script):
    path = os.path.join(test_dir, 'completion')
    script = Script('"{}/ep08_i'.format(path))
    expected = [
        'pep0484_basic.py"',
        'pep0484_generic_mismatches.py"',
        'pep0484_generic_parameters.py"',
        'pep0484_generic_passthroughs.py"',
        'pep0484_typing.py"',
    ]
    assert expected == [comp.name for comp in script.complete(fuzzy=True)]


@pytest.mark.parametrize(
    'code, column', [
        ('"foo"', 0),
        ('"foo"', 3),
        ('"foo"', None),
        ('"""foo"""', 5),
        ('"""foo"""', 1),
        ('"""foo"""', 2),
    ]
)
def test_goto_on_string(Script, code, column):
    script = Script(code)
    assert not script.infer(column=column)
    assert not script.goto(column=column)


def test_multi_goto(Script):
    script = Script('x = 1\ny = 1.0\nx\ny')
    x, = script.goto(line=3)
    y, = script.goto(line=4)
    assert x.line == 1
    assert y.line == 2


@pytest.mark.parametrize(
    'code, column, expected', [
        ('str() ', 3, 'str'),
        ('str() ', 4, 'str'),
        ('str() ', 5, 'str'),
        ('str() ', 6, None),
        ('str(    ) ', 6, None),
        ('   1', 1, None),
        ('str(1) ', 3, 'str'),
        ('str(1) ', 4, 'int'),
        ('str(1) ', 5, 'int'),
        ('str(1) ', 6, 'str'),
        ('str(1) ', 7, None),
        ('str( 1) ', 4, 'str'),
        ('str( 1) ', 5, 'int'),
        ('str(+1) ', 4, 'str'),
        ('str(+1) ', 5, 'int'),
        ('str(1, 1.) ', 3, 'str'),
        ('str(1, 1.) ', 4, 'int'),
        ('str(1, 1.) ', 5, 'int'),
        ('str(1, 1.) ', 6, None),
        ('str(1, 1.) ', 7, 'float'),
    ]
)
def test_infer_after_parentheses(Script, code, column, expected):
    completions = Script(code).infer(column=column)
    if expected is None:
        assert completions == []
    else:
        assert [c.name for c in completions] == [expected]
