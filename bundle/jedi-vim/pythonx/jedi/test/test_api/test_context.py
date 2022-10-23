import pytest


def _iter_hierarchy(context):
    def iter(context):
        while context is not None:
            yield context
            context = context.parent()

    return reversed(list(iter(context)))


func_code = '''\
def func1(x, y):
    pass

def func2():
 what ?
i = 3
    
def func3():
    1'''
cls_code = '''\
class Foo:
    def x():
        def y():
            pass
'''
cls_nested = '''\
class C:
    class D:
        def f():
            pass
'''
lambda_ = '''\
def x():
    (lambda x:
     lambda: y
    )
'''
comprehension = '''
def f(x):
    [x
    for
    x
    in x
    ]'''

with_brackets = '''\
def x():
    [

    ]
'''


@pytest.mark.parametrize(
    'code, line, column, full_name, expected_parents', [
        ('', None, None, 'myfile', []),
        (' ', None, 0, 'myfile', []),

        (func_code, 1, 0, 'myfile', []),
        (func_code, 1, None, 'myfile.func1', ['func1']),
        (func_code, 1, 1, 'myfile.func1', ['func1']),
        (func_code, 1, 4, 'myfile.func1', ['func1']),
        (func_code, 1, 10, 'myfile.func1', ['func1']),

        (func_code, 3, 0, 'myfile', []),
        (func_code, 5, None, 'myfile.func2', ['func2']),
        (func_code, 6, None, 'myfile', []),
        (func_code, 7, None, 'myfile', []),
        (func_code, 9, None, 'myfile.func3', ['func3']),

        (cls_code, None, None, 'myfile', []),
        (cls_code + ' ', None, None, 'myfile.Foo', ['Foo']),
        (cls_code + ' ' * 3, None, None, 'myfile.Foo', ['Foo']),
        (cls_code + ' ' * 4, None, None, 'myfile.Foo', ['Foo']),
        (cls_code + ' ' * 5, None, None, 'myfile.Foo.x', ['Foo', 'x']),
        (cls_code + ' ' * 8, None, None, 'myfile.Foo.x', ['Foo', 'x']),
        (cls_code + ' ' * 12, None, None, None, ['Foo', 'x', 'y']),

        (cls_code, 4, 0, 'myfile', []),
        (cls_code, 4, 3, 'myfile.Foo', ['Foo']),
        (cls_code, 4, 4, 'myfile.Foo', ['Foo']),
        (cls_code, 4, 5, 'myfile.Foo.x', ['Foo', 'x']),
        (cls_code, 4, 8, 'myfile.Foo.x', ['Foo', 'x']),
        (cls_code, 4, 12, None, ['Foo', 'x', 'y']),
        (cls_code, 1, 1, 'myfile.Foo', ['Foo']),

        (cls_nested, 4, None, 'myfile.C.D.f', ['C', 'D', 'f']),
        (cls_nested, 4, 3, 'myfile.C', ['C']),

        (lambda_, 2, 9, 'myfile.x', ['x']),  # the lambda keyword
        (lambda_, 2, 13, 'myfile.x', ['x']),  # the lambda param
        (lambda_, 3, 0, 'myfile', []),  # Within brackets, but they are ignored.
        (lambda_, 3, 8, 'myfile.x', ['x']),
        (lambda_, 3, None, 'myfile.x', ['x']),

        (comprehension, 2, None, 'myfile.f', ['f']),
        (comprehension, 3, None, 'myfile.f', ['f']),
        (comprehension, 4, None, 'myfile.f', ['f']),
        (comprehension, 5, None, 'myfile.f', ['f']),
        (comprehension, 6, None, 'myfile.f', ['f']),

        # Brackets are just ignored.
        (with_brackets, 3, None, 'myfile', []),
        (with_brackets, 4, 4, 'myfile.x', ['x']),
        (with_brackets, 4, 5, 'myfile.x', ['x']),
    ]
)
def test_context(Script, code, line, column, full_name, expected_parents):
    context = Script(code, path='/foo/myfile.py').get_context(line, column)
    assert context.full_name == full_name
    parent_names = [d.name for d in _iter_hierarchy(context)]
    assert parent_names == ['myfile'] + expected_parents
