# ============================================================================
# FILE: util.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

import importlib.util
import os
import typing
from pathlib import Path
from pynvim import Nvim

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
    vim.call('defx#util#print_error', expr)


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
