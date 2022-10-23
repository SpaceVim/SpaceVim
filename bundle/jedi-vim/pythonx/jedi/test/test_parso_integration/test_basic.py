from textwrap import dedent

import pytest
from parso import parse


def test_form_feed_characters(Script):
    s = "\f\nclass Test(object):\n    pass"
    Script(s).get_signatures(line=2, column=18)


def check_p(src):
    module_node = parse(src)
    assert src == module_node.get_code()
    return module_node


def test_if(Script):
    src = dedent('''\
    def func():
        x = 3
        if x:
            def y():
                return x
        return y()

    func()
    ''')

    # Two parsers needed, one for pass and one for the function.
    check_p(src)
    assert [d.name for d in Script(src).infer(8, 6)] == ['int']


def test_class_and_if(Script):
    src = dedent("""\
    class V:
        def __init__(self):
            pass

        if 1:
            c = 3

    def a_func():
        return 1

    # COMMENT
    a_func()""")
    check_p(src)
    assert [d.name for d in Script(src).infer()] == ['int']


def test_add_to_end(Script):
    """
    The diff parser doesn't parse everything again. It just updates with the
    help of caches, this is an example that didn't work.
    """

    a = dedent("""\
    class Abc():
        def abc(self):
            self.x = 3

    class Two(Abc):
        def g(self):
            self
    """)      # ^ here is the first completion

    b = "    def h(self):\n" \
        "        self."

    def complete(code, line=None, column=None):
        script = Script(code, path='example.py')
        assert script.complete(line, column)

    complete(a, 7, 12)
    complete(a + b)

    a = a[:-1] + '.\n'
    complete(a, 7, 13)
    complete(a + b)


def test_tokenizer_with_string_literal_backslash(Script):
    c = Script("statement = u'foo\\\n'; statement").infer()
    assert c[0]._name._value.get_safe_value() == 'foo'


def test_ellipsis_without_getitem(Script, environment):
    def_, = Script('x=...;x').infer()

    assert def_.name == 'ellipsis'
