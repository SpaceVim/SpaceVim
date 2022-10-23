from functools import partial
from test.helpers import get_example_dir
from jedi.api.project import Project

import pytest


@pytest.fixture
def ScriptInStubFolder(Script):
    path = get_example_dir('stub_packages')
    project = Project(path, sys_path=[path], smart_sys_path=False)
    return partial(Script, project=project)


@pytest.mark.parametrize(
    ('code', 'expected'), [
        ('from no_python import foo', ['int']),
        ('from with_python import stub_only', ['str']),
        ('from with_python import python_only', ['int']),
        ('from with_python import both', ['int']),
        ('from with_python import something_random', []),
        ('from with_python.module import in_sub_module', ['int']),
    ]
)
def test_find_stubs_infer(ScriptInStubFolder, code, expected):
    defs = ScriptInStubFolder(code).infer()
    assert [d.name for d in defs] == expected


func_without_stub_doc = 'func_without_stub(a)\n\nnostubdoc'
func_with_stub_doc = 'func_with_stub(b: int) -> float\n\nwithstubdoc'


@pytest.mark.parametrize(
    ('code', 'expected'), [
        ('from with_python import stub_only', ''),
        ('from with_python import python_only', ''),
        ('from with_python import both', ''),

        ('import with_python; with_python.func_without_stub', ''),
        ('import with_python.module; with_python.module.func_without_stub', func_without_stub_doc),
        ('from with_python import module; module.func_without_stub', func_without_stub_doc),
        ('from with_python.module import func_without_stub', func_without_stub_doc),
        ('from with_python.module import func_without_stub as f; f', func_without_stub_doc),
        ('from with_python.module import func_without_stub; func_without_stub',
         func_without_stub_doc),
        ('from with_python import func_without_stub', ''),
        ('from with_python import func_without_stub as f; f', ''),
        ('from with_python import func_without_stub; func_without_stub', ''),

        ('import with_python; with_python.func_with_stub', func_with_stub_doc),
        ('import with_python.module; with_python.module.func_with_stub', func_with_stub_doc),
        ('from with_python import module; module.func_with_stub', func_with_stub_doc),
        ('from with_python.module import func_with_stub', func_with_stub_doc),
        ('from with_python.module import func_with_stub as f; f', func_with_stub_doc),
        ('from with_python.module import func_with_stub; func_with_stub', func_with_stub_doc),
        ('from with_python import func_with_stub', func_with_stub_doc),
        ('from with_python import func_with_stub as f; f', func_with_stub_doc),
        ('from with_python import func_with_stub; func_with_stub', func_with_stub_doc),
    ]
)
def test_docstrings(ScriptInStubFolder, code, expected):
    d, = ScriptInStubFolder(code).help()
    assert d.docstring() == expected
