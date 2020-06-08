# ============================================================================
# FILE: file.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

import copy
import importlib
from pathlib import Path
import shutil
import time
import typing

from defx.action import ActionAttr
from defx.action import ActionTable
from defx.base.kind import Base
from defx.clipboard import ClipboardAction
from defx.context import Context
from defx.defx import Defx
from defx.util import cd, cwd_input, confirm, error
from defx.util import readable, Nvim
from defx.view import View

_action_table: typing.Dict[str, ActionTable] = {}

ACTION_FUNC = typing.Callable[[View, Defx, Context], None]


def action(name: str, attr: ActionAttr = ActionAttr.NONE
           ) -> typing.Callable[[ACTION_FUNC], ACTION_FUNC]:
    def wrapper(func: ACTION_FUNC) -> ACTION_FUNC:
        _action_table[name] = ActionTable(func=func, attr=attr)

        def inner_wrapper(view: View, defx: Defx, context: Context) -> None:
            return func(view, defx, context)
        return inner_wrapper
    return wrapper


class Kind(Base):

    def __init__(self, vim: Nvim) -> None:
        self.vim = vim
        self.name = 'file'

    def get_actions(self) -> typing.Dict[str, ActionTable]:
        actions = copy.copy(super().get_actions())
        actions.update(_action_table)
        return actions


def check_overwrite(view: View, dest: Path, src: Path) -> Path:
    s_stat = src.stat()
    s_mtime = s_stat.st_mtime
    view.print_msg(f' src: {src} {s_stat.st_size} bytes')
    view.print_msg(f'      {time.strftime("%c", time.localtime(s_mtime))}')
    d_stat = dest.stat()
    d_mtime = d_stat.st_mtime
    view.print_msg(f'dest: {dest} {d_stat.st_size} bytes')
    view.print_msg(f'      {time.strftime("%c", time.localtime(d_mtime))}')

    choice: int = view._vim.call('defx#util#confirm',
                                 f'{dest} already exists.  Overwrite?',
                                 '&Force\n&No\n&Rename\n&Time\n&Underbar', 0)
    ret: Path = Path('')
    if choice == 1:
        ret = dest
    elif choice == 2:
        ret = Path('')
    elif choice == 3:
        ret = Path(view._vim.call('input', f'{src} -> ', str(dest),
                                  ('dir' if src.is_dir() else 'file')))
    elif choice == 4 and d_mtime < s_mtime:
        ret = src
    elif choice == 5:
        ret = Path(str(dest) + '_')
    return ret


@action(name='cd')
def _cd(view: View, defx: Defx, context: Context) -> None:
    """
    Change the current directory.
    """
    path = Path(context.args[0]) if context.args else Path.home()
    path = Path(defx._cwd).joinpath(path).resolve()
    if not readable(path) or not path.is_dir():
        error(view._vim, f'{path} is not readable directory')
        return

    prev_cwd = defx._cwd
    view.cd(defx, str(path), context.cursor)
    if context.args and context.args[0] == '..':
        view.search_file(Path(prev_cwd), defx._index)


@action(name='change_vim_cwd', attr=ActionAttr.NO_TAGETS)
def _change_vim_cwd(view: View, defx: Defx, context: Context) -> None:
    """
    Change the current working directory.
    """
    cd(view._vim, defx._cwd)


@action(name='check_redraw', attr=ActionAttr.NO_TAGETS)
def _check_redraw(view: View, defx: Defx, context: Context) -> None:
    root = defx.get_root_candidate()['action__path']
    if not root.exists():
        return
    mtime = root.stat().st_mtime
    if mtime != defx._mtime:
        view.redraw(True)


@action(name='copy')
def _copy(view: View, defx: Defx, context: Context) -> None:
    if not context.targets:
        return

    message = 'Copy to the clipboard: {}'.format(
        str(context.targets[0]['action__path'])
        if len(context.targets) == 1
        else str(len(context.targets)) + ' files')
    view.print_msg(message)

    view._clipboard.action = ClipboardAction.COPY
    view._clipboard.candidates = context.targets


@action(name='drop')
def _drop(view: View, defx: Defx, context: Context) -> None:
    """
    Open like :drop.
    """
    cwd = view._vim.call('getcwd')
    command = context.args[0] if context.args else 'edit'

    for target in context.targets:
        path = target['action__path']

        if path.is_dir():
            view.cd(defx, str(path), context.cursor)
            continue

        bufnr = view._vim.call('bufnr', f'^{path}$')
        winids = view._vim.call('win_findbuf', bufnr)

        if winids:
            view._vim.call('win_gotoid', winids[0])
        else:
            if context.prev_winid != view._winid and view._vim.call(
                    'win_id2win', context.prev_winid):
                view._vim.call('win_gotoid', context.prev_winid)
            else:
                view._vim.command('wincmd w')
            try:
                path = path.relative_to(cwd)
            except ValueError:
                pass
            view._vim.call('defx#util#execute_path', command, str(path))


@action(name='execute_command', attr=ActionAttr.NO_TAGETS)
def _execute_command(view: View, defx: Defx, context: Context) -> None:
    """
    Execute the command.
    """
    save_cwd = view._vim.call('getcwd')
    cd(view._vim, defx._cwd)

    command = context.args[0] if context.args else view._vim.call(
        'input', 'Command: ', '', 'shellcmd')

    output = view._vim.call('system', command)
    if output:
        view.print_msg(output)

    cd(view._vim, save_cwd)


@action(name='execute_system')
def _execute_system(view: View, defx: Defx, context: Context) -> None:
    """
    Execute the file by system associated command.
    """
    for target in context.targets:
        view._vim.call('defx#util#open', str(target['action__path']))


@action(name='move')
def _move(view: View, defx: Defx, context: Context) -> None:
    if not context.targets:
        return

    message = 'Move to the clipboard: {}'.format(
        str(context.targets[0]['action__path'])
        if len(context.targets) == 1
        else str(len(context.targets)) + ' files')
    view.print_msg(message)

    view._clipboard.action = ClipboardAction.MOVE
    view._clipboard.candidates = context.targets


@action(name='new_directory')
def _new_directory(view: View, defx: Defx, context: Context) -> None:
    """
    Create a new directory.
    """
    candidate = view.get_cursor_candidate(context.cursor)
    if not candidate:
        return

    if candidate['is_opened_tree'] or candidate['is_root']:
        cwd = str(candidate['action__path'])
    else:
        cwd = str(Path(candidate['action__path']).parent)

    new_filename = cwd_input(
        view._vim, cwd,
        'Please input a new directory name: ', '', 'file')
    if not new_filename:
        return
    filename = Path(cwd).joinpath(new_filename)

    if not filename:
        return
    if filename.exists():
        error(view._vim, f'{filename} already exists')
        return

    filename.mkdir(parents=True)
    view.redraw(True)
    view.search_file(filename, defx._index)


@action(name='new_file')
def _new_file(view: View, defx: Defx, context: Context) -> None:
    """
    Create a new file and it's parent directories.
    """
    candidate = view.get_cursor_candidate(context.cursor)
    if not candidate:
        return

    if candidate['is_opened_tree'] or candidate['is_root']:
        cwd = str(candidate['action__path'])
    else:
        cwd = str(Path(candidate['action__path']).parent)

    new_filename = cwd_input(
        view._vim, cwd,
        'Please input a new filename: ', '', 'file')
    if not new_filename:
        return
    isdir = new_filename[-1] == '/'
    filename = Path(cwd).joinpath(new_filename)

    if not filename:
        return
    if filename.exists():
        error(view._vim, f'{filename} already exists')
        return

    if isdir:
        filename.mkdir(parents=True)
    else:
        filename.parent.mkdir(parents=True, exist_ok=True)
        filename.touch()

    view.redraw(True)
    view.search_file(filename, defx._index)


@action(name='new_multiple_files')
def _new_multiple_files(view: View, defx: Defx, context: Context) -> None:
    """
    Create multiple files.
    """
    candidate = view.get_cursor_candidate(context.cursor)
    if not candidate:
        return

    if candidate['is_opened_tree'] or candidate['is_root']:
        cwd = str(candidate['action__path'])
    else:
        cwd = str(Path(candidate['action__path']).parent)

    save_cwd = view._vim.call('getcwd')
    cd(view._vim, cwd)

    str_filenames: str = view._vim.call(
        'input', 'Please input new filenames: ', '', 'file')
    cd(view._vim, save_cwd)

    if not str_filenames:
        return None

    for name in str_filenames.split():
        is_dir = name[-1] == '/'

        filename = Path(cwd).joinpath(name)
        if filename.exists():
            error(view._vim, f'{filename} already exists')
            continue

        if is_dir:
            filename.mkdir(parents=True)
        else:
            if not filename.parent.exists():
                filename.parent.mkdir(parents=True)
            filename.touch()

    view.redraw(True)
    view.search_file(filename, defx._index)


@action(name='open')
def _open(view: View, defx: Defx, context: Context) -> None:
    """
    Open the file.
    """
    cwd = view._vim.call('getcwd')
    command = context.args[0] if context.args else 'edit'
    for target in context.targets:
        path = target['action__path']

        if path.is_dir():
            view.cd(defx, str(path), context.cursor)
            continue

        try:
            path = path.relative_to(cwd)
        except ValueError:
            pass
        view._vim.call('defx#util#execute_path', command, str(path))


@action(name='open_directory')
def _open_directory(view: View, defx: Defx, context: Context) -> None:
    """
    Open the directory.
    """
    if context.args:
        path = Path(context.args[0])
    else:
        for target in context.targets:
            path = target['action__path']

    if path.is_dir():
        view.cd(defx, str(path), context.cursor)


@action(name='paste', attr=ActionAttr.NO_TAGETS)
def _paste(view: View, defx: Defx, context: Context) -> None:
    candidate = view.get_cursor_candidate(context.cursor)
    if not candidate:
        return

    if candidate['is_opened_tree'] or candidate['is_root']:
        cwd = str(candidate['action__path'])
    else:
        cwd = str(Path(candidate['action__path']).parent)

    action = view._clipboard.action
    dest = None
    for index, candidate in enumerate(view._clipboard.candidates):
        path = candidate['action__path']
        dest = Path(cwd).joinpath(path.name)
        if dest.exists():
            overwrite = check_overwrite(view, dest, path)
            if overwrite == Path(''):
                continue
            dest = overwrite

        if path == dest:
            continue

        view.print_msg(
            f'[{index + 1}/{len(view._clipboard.candidates)}] {path}')
        if action == ClipboardAction.COPY:
            if path.is_dir():
                shutil.copytree(str(path), dest)
            else:
                shutil.copy2(str(path), dest)
        elif action == ClipboardAction.MOVE:
            shutil.move(str(path), cwd)
        view._vim.command('redraw')
    view._vim.command('echo')

    view.redraw(True)
    if dest:
        view.search_file(dest, defx._index)


@action(name='remove', attr=ActionAttr.REDRAW)
def _remove(view: View, defx: Defx, context: Context) -> None:
    """
    Delete the file or directory.
    """
    if not context.targets:
        return

    force = context.args[0] == 'force' if context.args else False
    if not force:
        message = 'Are you sure you want to delete {}?'.format(
            str(context.targets[0]['action__path'])
            if len(context.targets) == 1
            else str(len(context.targets)) + ' files')
        if not confirm(view._vim, message):
            return

    for target in context.targets:
        path = target['action__path']

        if path.is_dir():
            shutil.rmtree(str(path))
        else:
            path.unlink()


@action(name='remove_trash')
def _remove_trash(view: View, defx: Defx, context: Context) -> None:
    """
    Delete the file or directory.
    """
    if not context.targets:
        return

    if not importlib.util.find_spec('send2trash'):
        error(view._vim, '"Send2Trash" is not installed')
        return

    force = context.args[0] == 'force' if context.args else False
    if not force:
        message = 'Are you sure you want to delete {}?'.format(
            str(context.targets[0]['action__path'])
            if len(context.targets) == 1
            else str(len(context.targets)) + ' files')
        if not confirm(view._vim, message):
            return

    import send2trash
    for target in context.targets:
        send2trash.send2trash(str(target['action__path']))
    view.redraw(True)


@action(name='rename')
def _rename(view: View, defx: Defx, context: Context) -> None:
    """
    Rename the file or directory.
    """

    if len(context.targets) > 1:
        # ex rename
        view._vim.call('defx#exrename#create_buffer',
                       [{'action__path': str(x['action__path'])}
                        for x in context.targets],
                       {'buffer_name': 'defx'})
        return

    for target in context.targets:
        old = target['action__path']
        new_filename = cwd_input(
            view._vim, defx._cwd,
            f'Old name: {old}\nNew name: ', str(old), 'file')
        view._vim.command('redraw')
        if not new_filename:
            return
        new = Path(defx._cwd).joinpath(new_filename)
        if not new or new == old:
            continue
        if str(new).lower() != str(old).lower() and new.exists():
            error(view._vim, f'{new} already exists')
            continue

        old.rename(new)

        view.redraw(True)
        view.search_file(new, defx._index)
