from jedi.inference.compiled import CompiledValue

import pytest


@pytest.mark.parametrize('source', [
    pytest.param('1 == 1'),
    pytest.param('1.0 == 1'),
    # Unfortunately for now not possible, because it's a typeshed object.
    pytest.param('... == ...', marks=pytest.mark.xfail),
])
def test_equals(Script, environment, source):
    script = Script(source)
    node = script._module_node.children[0]
    first, = script._get_module_context().infer_node(node)
    assert isinstance(first, CompiledValue) and first.get_safe_value() is True
