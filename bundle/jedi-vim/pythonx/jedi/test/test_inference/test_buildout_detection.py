import os
from textwrap import dedent
from pathlib import Path

from jedi.inference.sys_path import _get_parent_dir_with_file, \
    _get_buildout_script_paths, check_sys_path_modifications

from ..helpers import get_example_dir


def check_module_test(Script, code):
    module_context = Script(code)._get_module_context()
    return check_sys_path_modifications(module_context)


def test_parent_dir_with_file(Script):
    path = Path(get_example_dir('buildout_project', 'src', 'proj_name'))
    parent = _get_parent_dir_with_file(path, 'buildout.cfg')
    assert parent is not None
    assert str(parent).endswith(os.path.join('test', 'examples', 'buildout_project'))


def test_buildout_detection(Script):
    path = Path(get_example_dir('buildout_project', 'src', 'proj_name'))
    paths = list(_get_buildout_script_paths(path.joinpath('module_name.py')))
    assert len(paths) == 1
    appdir_path = os.path.normpath(os.path.join(path, '../../bin/app'))
    assert str(paths[0]) == appdir_path


def test_append_on_non_sys_path(Script):
    code = dedent("""
        class Dummy(object):
            path = []

        d = Dummy()
        d.path.append('foo')""")

    paths = check_module_test(Script, code)
    assert not paths
    assert 'foo' not in paths


def test_path_from_invalid_sys_path_assignment(Script):
    code = dedent("""
        import sys
        sys.path = 'invalid'""")

    paths = check_module_test(Script, code)
    assert not paths
    assert 'invalid' not in paths


def test_sys_path_with_modifications(Script):
    path = get_example_dir('buildout_project', 'src', 'proj_name', 'module_name.py')
    code = dedent("""
        import os
    """)

    paths = Script(code, path=path)._inference_state.get_sys_path()
    assert os.path.abspath('/tmp/.buildout/eggs/important_package.egg') in paths


def test_path_from_sys_path_assignment(Script):
    code = dedent(f"""
        #!/usr/bin/python

        import sys
        sys.path[0:0] = [
          {os.path.abspath('/usr/lib/python3.8/site-packages')!r},
          {os.path.abspath('/home/test/.buildout/eggs/important_package.egg')!r},
          ]

        path[0:0] = [1]

        import important_package

        if __name__ == '__main__':
            sys.exit(important_package.main())""")

    paths = check_module_test(Script, code)
    assert 1 not in paths
    assert os.path.abspath('/home/test/.buildout/eggs/important_package.egg') \
        in map(str, paths)
