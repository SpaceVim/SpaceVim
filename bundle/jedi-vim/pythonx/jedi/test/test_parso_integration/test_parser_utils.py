import gc
from pathlib import Path

from jedi import parser_utils
from parso import parse
from parso.cache import parser_cache
from parso.python import tree

import pytest


class TestCallAndName:
    def get_call(self, source):
        # Get the simple_stmt and then the first one.
        node = parse(source).children[0]
        if node.type == 'simple_stmt':
            return node.children[0]
        return node

    def test_name_and_call_positions(self):
        name = self.get_call('name\nsomething_else')
        assert name.value == 'name'
        assert name.start_pos == (1, 0)
        assert name.end_pos == (1, 4)

        leaf = self.get_call('1.0\n')
        assert leaf.value == '1.0'
        assert parser_utils.safe_literal_eval(leaf.value) == 1.0
        assert leaf.start_pos == (1, 0)
        assert leaf.end_pos == (1, 3)

    def test_call_type(self):
        call = self.get_call('hello')
        assert isinstance(call, tree.Name)

    def test_literal_type(self):
        literal = self.get_call('1.0')
        assert isinstance(literal, tree.Literal)
        assert type(parser_utils.safe_literal_eval(literal.value)) == float

        literal = self.get_call('1')
        assert isinstance(literal, tree.Literal)
        assert type(parser_utils.safe_literal_eval(literal.value)) == int

        literal = self.get_call('"hello"')
        assert isinstance(literal, tree.Literal)
        assert parser_utils.safe_literal_eval(literal.value) == 'hello'


def test_hex_values_in_docstring():
    source = r'''
        def foo(object):
            """
             \xff
            """
            return 1
        '''

    doc = parser_utils.clean_scope_docstring(next(parse(source).iter_funcdefs()))
    assert doc == '\xff'


@pytest.mark.parametrize(
    'code,signature', [
        ('def my_function(x, typed: Type, z):\n return', 'my_function(x, typed: Type, z)'),
        ('def my_function(x, y, z) -> str:\n return', 'my_function(x, y, z) -> str'),
        ('lambda x, y, z: x + y * z\n', '<lambda>(x, y, z)')
    ])
def test_get_signature(code, signature):
    node = parse(code, version='3.8').children[0]
    if node.type == 'simple_stmt':
        node = node.children[0]
    assert parser_utils.get_signature(node) == signature


def test_parser_cache_clear(Script):
    """
    If parso clears its cache, Jedi should not keep those resources, they
    should be freed.
    """
    script = Script("a = abs\na", path=Path(__file__).parent / 'parser_cache_test_foo.py')
    script.complete()
    module_id = id(script._module_node)
    del parser_cache[script._inference_state.grammar._hashed][script.path]
    del script

    gc.collect()
    assert module_id not in [id(m) for m in gc.get_referrers(tree.Module)]
