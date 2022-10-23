import os
import sys

import pytest

import jedi
from jedi.api.environment import get_default_environment, find_virtualenvs, \
    InvalidPythonEnvironment, find_system_environments, \
    get_system_environment, create_environment, InterpreterEnvironment, \
    get_cached_default_environment


def test_sys_path():
    assert get_default_environment().get_sys_path()


def test_find_system_environments():
    envs = list(find_system_environments())
    assert len(envs)
    for env in envs:
        assert env.version_info
        assert env.get_sys_path()
        parser_version = env.get_grammar().version_info
        assert parser_version[:2] == env.version_info[:2]


@pytest.mark.parametrize(
    'version',
    ['3.6', '3.7', '3.8', '3.9']
)
def test_versions(version):
    try:
        env = get_system_environment(version)
    except InvalidPythonEnvironment:
        if int(version.replace('.', '')) == str(sys.version_info[0]) + str(sys.version_info[1]):
            # At least the current version has to work
            raise
        pytest.skip()

    assert version == str(env.version_info[0]) + '.' + str(env.version_info[1])
    assert env.get_sys_path()


def test_load_module(inference_state):
    access_path = inference_state.compiled_subprocess.load_module(
        dotted_name='math',
        sys_path=inference_state.get_sys_path()
    )
    name, access_handle = access_path.accesses[0]

    assert access_handle.py__bool__() is True
    assert access_handle.get_api_type() == 'module'
    with pytest.raises(AttributeError):
        access_handle.py__mro__()


def test_error_in_environment(inference_state, Script, environment):
    if isinstance(environment, InterpreterEnvironment):
        pytest.skip("We don't catch these errors at the moment.")

    # Provoke an error to show how Jedi can recover from it.
    with pytest.raises(jedi.InternalError):
        inference_state.compiled_subprocess._test_raise_error(KeyboardInterrupt)
    # The second time it should raise an InternalError again.
    with pytest.raises(jedi.InternalError):
        inference_state.compiled_subprocess._test_raise_error(KeyboardInterrupt)
    # Jedi should still work.
    def_, = Script('str').infer()
    assert def_.name == 'str'


def test_stdout_in_subprocess(inference_state, Script):
    inference_state.compiled_subprocess._test_print(stdout='.')
    Script('1').infer()


def test_killed_subprocess(inference_state, Script, environment):
    if isinstance(environment, InterpreterEnvironment):
        pytest.skip("We cannot kill our own process")
    # Just kill the subprocess.
    inference_state.compiled_subprocess._compiled_subprocess._get_process().kill()
    # Since the process was terminated (and nobody knows about it) the first
    # Jedi call fails.
    with pytest.raises(jedi.InternalError):
        Script('str').infer()

    def_, = Script('str').infer()
    # Jedi should now work again.
    assert def_.name == 'str'


def test_not_existing_virtualenv(monkeypatch):
    """Should not match the path that was given"""
    path = '/foo/bar/jedi_baz'
    monkeypatch.setenv('VIRTUAL_ENV', path)
    assert get_default_environment().executable != path


def test_working_venv(venv_path, monkeypatch):
    monkeypatch.setenv('VIRTUAL_ENV', venv_path)
    assert get_default_environment().path == venv_path


def test_scanning_venvs(venv_path):
    parent_dir = os.path.dirname(venv_path)
    assert any(venv.path == venv_path
               for venv in find_virtualenvs([parent_dir]))


def test_create_environment_venv_path(venv_path):
    environment = create_environment(venv_path)
    assert environment.path == venv_path


def test_create_environment_executable():
    environment = create_environment(sys.executable)
    assert environment.executable == sys.executable


def test_get_default_environment_from_env_does_not_use_safe(tmpdir, monkeypatch):
    fake_python = os.path.join(str(tmpdir), 'fake_python')
    with open(fake_python, 'w', newline='') as f:
        f.write('')

    def _get_subprocess(self):
        if self._start_executable != fake_python:
            raise RuntimeError('Should not get called!')
        self.executable = fake_python
        self.path = 'fake'

    monkeypatch.setattr('jedi.api.environment.Environment._get_subprocess',
                        _get_subprocess)

    monkeypatch.setenv('VIRTUAL_ENV', fake_python)
    env = get_default_environment()
    assert env.path == 'fake'


@pytest.mark.parametrize('virtualenv', ['', 'fufuuuuu', sys.prefix])
def test_get_default_environment_when_embedded(monkeypatch, virtualenv):
    # When using Python embedded, sometimes the executable is not a Python
    # executable.
    executable_name = 'RANDOM_EXE'
    monkeypatch.setattr(sys, 'executable', executable_name)
    monkeypatch.setenv('VIRTUAL_ENV', virtualenv)
    env = get_default_environment()
    assert env.executable != executable_name


def test_changing_venv(venv_path, monkeypatch):
    monkeypatch.setitem(os.environ, 'VIRTUAL_ENV', venv_path)
    get_cached_default_environment()
    monkeypatch.setitem(os.environ, 'VIRTUAL_ENV', sys.executable)
    assert get_cached_default_environment().executable == sys.executable
