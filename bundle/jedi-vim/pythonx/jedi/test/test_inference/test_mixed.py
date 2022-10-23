from typing import Generic, TypeVar, List

import pytest

import jedi
from jedi.inference.value import ModuleValue


def interpreter(code, namespace, *args, **kwargs):
    return jedi.Interpreter(code, [namespace], *args, **kwargs)


def test_on_code():
    from functools import wraps
    i = interpreter("wraps.__code__", {'wraps': wraps})
    assert i.infer()


def test_generics_without_definition():
    # Used to raise a recursion error
    T = TypeVar('T')

    class Stack(Generic[T]):
        def __init__(self):
            self.items = []  # type: List[T]

        def push(self, item):
            self.items.append(item)

        def pop(self):
            # type: () -> T
            return self.items.pop()

    class StackWrapper():
        def __init__(self):
            self.stack = Stack()
            self.stack.push(1)

    s = StackWrapper()
    assert not interpreter('s.stack.pop().', locals()).complete()


@pytest.mark.parametrize(
    'code, expected', [
        ('Foo().method()', 'str'),
        ('Foo.method()', 'str'),
        ('foo.method()', 'str'),
        ('Foo().read()', 'str'),
        ('Foo.read()', 'str'),
        ('foo.read()', 'str'),
    ]
)
def test_generics_methods(code, expected, class_findable):
    T = TypeVar("T")

    class Reader(Generic[T]):
        @classmethod
        def read(cls) -> T:
            return cls()

        def method(self) -> T:
            return 1

    class Foo(Reader[str]):
        def transform(self) -> int:
            return 42

    foo = Foo()

    defs = jedi.Interpreter(code, [locals()]).infer()
    if class_findable:
        def_, = defs
        assert def_.name == expected
    else:
        assert not defs


def test_mixed_module_cache():
    """Caused by #1479"""
    interpreter = jedi.Interpreter('jedi', [{'jedi': jedi}])
    d, = interpreter.infer()
    assert d.name == 'jedi'
    inference_state = interpreter._inference_state
    jedi_module, = inference_state.module_cache.get(('jedi',))
    assert isinstance(jedi_module, ModuleValue)


def test_signature():
    """
    For performance reasons we use the signature of the compiled object and not
    the tree object.
    """
    def some_signature(foo):
        pass

    from inspect import Signature, Parameter
    some_signature.__signature__ = Signature([
        Parameter('bar', kind=Parameter.KEYWORD_ONLY, default=1)
    ])

    s, = jedi.Interpreter('some_signature', [locals()]).goto()
    assert s.docstring() == 'some_signature(*, bar=1)'


def test_compiled_signature_annotation_string():
    import typing

    def func(x: typing.Type, y: typing.Union[typing.Type, int]):
        pass
    func.__name__ = 'not_func'

    s, = jedi.Interpreter('func()', [locals()]).get_signatures(1, 5)
    assert s.params[0].description == 'param x: Type'
    assert s.params[1].description == 'param y: Union[Type, int]'
