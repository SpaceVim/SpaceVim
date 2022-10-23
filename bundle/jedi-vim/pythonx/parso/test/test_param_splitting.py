'''
To make the life of any analysis easier, we are generating Param objects
instead of simple parser objects.
'''

from textwrap import dedent

from parso import parse


def assert_params(param_string, **wanted_dct):
    source = dedent('''
    def x(%s):
        pass
    ''') % param_string

    module = parse(source)
    funcdef = next(module.iter_funcdefs())
    dct = dict((p.name.value, p.default and p.default.get_code())
               for p in funcdef.get_params())
    assert dct == wanted_dct
    assert module.get_code() == source


def test_split_params_with_separation_star():
    assert_params('x, y=1, *, z=3', x=None, y='1', z='3')
    assert_params('*, x', x=None)
    assert_params('*')


def test_split_params_with_stars():
    assert_params('x, *args', x=None, args=None)
    assert_params('**kwargs', kwargs=None)
    assert_params('*args, **kwargs', args=None, kwargs=None)


def test_kw_only_no_kw(works_in_py):
    """
    Parsing this should be working. In CPython the parser also parses this and
    in a later step the AST complains.
    """
    module = works_in_py.parse('def test(arg, *):\n    pass')
    if module is not None:
        func = module.children[0]
        open_, p1, asterisk, close = func._get_param_nodes()
        assert p1.get_code('arg,')
        assert asterisk.value == '*'
