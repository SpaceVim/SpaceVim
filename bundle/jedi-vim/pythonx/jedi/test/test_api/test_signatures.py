import pytest

_tuple_code = 'from typing import Tuple\ndef f(x: Tuple[int]): ...\nf'


@pytest.mark.parametrize(
    'code, expected_params, execute_annotation', [
        ('def f(x: 1, y): ...\nf', [None, None], True),
        ('def f(x: 1, y): ...\nf', ['instance int', None], False),
        ('def f(x: int): ...\nf', ['instance int'], True),
        ('from typing import List\ndef f(x: List[int]): ...\nf', ['instance list'], True),
        ('from typing import List\ndef f(x: List[int]): ...\nf', ['class list'], False),
        (_tuple_code, ['instance tuple'], True),
        (_tuple_code, ['class Tuple'], False),
        ('x=str\ndef f(p: x): ...\nx=int\nf', ['instance int'], True),

        ('def f(*args, **kwargs): ...\nf', [None, None], False),
        ('def f(*args: int, **kwargs: str): ...\nf', ['class int', 'class str'], False),
    ]
)
def test_param_annotation(Script, code, expected_params, execute_annotation):
    func, = Script(code).goto()
    sig, = func.get_signatures()
    for p, expected in zip(sig.params, expected_params):
        annotations = p.infer_annotation(execute_annotation=execute_annotation)
        if expected is None:
            assert not annotations
        else:
            annotation, = annotations
            assert annotation.description == expected


@pytest.mark.parametrize(
    'code, expected_params', [
        ('def f(x=1, y=int, z): pass\nf', ['instance int', 'class int', None]),
        ('def f(*args, **kwargs): pass\nf', [None, None]),
        ('x=1\ndef f(p=x): pass\nx=""\nf', ['instance int']),
    ]
)
def test_param_default(Script, code, expected_params):
    func, = Script(code).goto()
    sig, = func.get_signatures()
    for p, expected in zip(sig.params, expected_params):
        annotations = p.infer_default()
        if expected is None:
            assert not annotations
        else:
            annotation, = annotations
            assert annotation.description == expected


@pytest.mark.parametrize(
    'code, index, param_code, kind', [
        ('def f(x=1): pass\nf', 0, 'x=1', 'POSITIONAL_OR_KEYWORD'),
        ('def f(*args:int): pass\nf', 0, '*args: int', 'VAR_POSITIONAL'),
        ('def f(**kwargs: List[x]): pass\nf', 0, '**kwargs: List[x]', 'VAR_KEYWORD'),
        ('def f(*, x:int=5): pass\nf', 0, 'x: int=5', 'KEYWORD_ONLY'),
        ('def f(*args, x): pass\nf', 1, 'x', 'KEYWORD_ONLY'),
    ]
)
def test_param_kind_and_name(code, index, param_code, kind, Script):
    func, = Script(code).goto()
    sig, = func.get_signatures()
    param = sig.params[index]
    assert param.to_string() == param_code
    assert param.kind.name == kind


def test_staticmethod(Script):
    s, = Script('staticmethod(').get_signatures()
    assert s.to_string() == 'staticmethod(f: Callable[..., Any])'
