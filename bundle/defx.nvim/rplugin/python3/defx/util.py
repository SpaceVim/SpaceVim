# ============================================================================
# FILE: util.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from pathlib import Path
from pynvim import Nvim
from sys import executable, base_exec_prefix
import importlib.util
import os
import shutil
import typing

UserContext = typing.Dict[str, typing.Any]
Candidate = typing.Dict[str, typing.Any]
Candidates = typing.List[Candidate]


def cd(vim: Nvim, path: str) -> None:
    vim.call('defx#util#cd', path)


def cwd_input(vim: Nvim, cwd: str, prompt: str,
              text: str = '', completion: str = '') -> str:
    """
    Returns the absolute input path in cwd.
    """
    save_cwd = vim.call('getcwd')
    cd(vim, cwd)

    filename: str = str(vim.call('defx#util#input', prompt, text, completion))
    filename = filename.strip()

    cd(vim, save_cwd)

    return filename


def error(vim: Nvim, expr: typing.Any) -> None:
    """
    Prints the error messages to Vim/Nvim's :messages buffer.
    """
    if isinstance(expr, set):
        expr = [str(x) for x in expr]
    vim.call('defx#util#print_error', str(expr))


def confirm(vim: Nvim, question: str) -> bool:
    """
    Confirm action
    """
    option: int = vim.call('defx#util#confirm',
                           question, '&Yes\n&No\n&Cancel', 2)
    return option == 1


def import_plugin(path: Path, source: str,
                  classname: str) -> typing.Any:
    """Import defx plugin source class.

    If the class exists, add its directory to sys.path.
    """
    module_name = 'defx.%s.%s' % (source, path.stem)

    spec = importlib.util.spec_from_file_location(module_name, str(path))
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)  # type: ignore
    cls = getattr(module, classname, None)
    return cls


def readable(path: Path) -> bool:
    """
    Check {path} is readable.
    """
    try:
        if os.access(str(path), os.R_OK) and path.stat():
            return True
        else:
            return False
    except Exception:
        return False


def safe_call(fn: typing.Callable[..., typing.Any],
              fallback: typing.Optional[bool] = None) -> typing.Any:
    """
    Ignore OSError when calling {fn}
    """
    try:
        return fn()
    except OSError:
        return fallback


def get_python_exe() -> str:
    if 'py' in str(Path(executable).name):
        return executable

    for exe in ['python3', 'python']:
        which = shutil.which(exe)
        if which is not None:
            return which

    for name in (Path(base_exec_prefix).joinpath(v) for v in [
            'python3', 'python',
            str(Path('bin').joinpath('python3')),
            str(Path('bin').joinpath('python')),
    ]):
        if name.exists():
            return str(name)

    # return sys.executable anyway. This may not work on windows
    return executable


def strwidth(vim: Nvim, word: str) -> int:
    return (int(vim.call('strwidth', word))
            if len(word) != len(bytes(word, 'utf-8',
                                      'surrogatepass')) else len(word))


def len_bytes(word: str) -> int:
    return len(bytes(word, 'utf-8', 'surrogatepass'))
