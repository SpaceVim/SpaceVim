import pytest

from jedi import settings
from jedi.inference.compiled import CompiledValueName
from jedi.inference.compiled.value import CompiledModule


@pytest.fixture()
def auto_import_json(monkeypatch):
    monkeypatch.setattr(settings, 'auto_import_modules', ['json'])


def test_base_auto_import_modules(auto_import_json, Script):
    loads, = Script('import json; json.loads').infer()
    assert isinstance(loads._name, CompiledValueName)
    value, = loads._name.infer()
    assert isinstance(value.parent_context._value, CompiledModule)


def test_auto_import_modules_imports(auto_import_json, Script):
    main, = Script('from json import tool; tool.main').infer()
    assert isinstance(main._name, CompiledValueName)


def test_cropped_file_size(monkeypatch, get_names, Script):
    code = 'class Foo(): pass\n'
    monkeypatch.setattr(
        settings,
        '_cropped_file_size',
        len(code)
    )

    foo, = get_names(code + code)
    assert foo.line == 1

    # It should just not crash if we are outside of the cropped range.
    script = Script(code + code + 'Foo')
    assert not script.infer()
    assert 'Foo' in [c.name for c in script.complete()]
