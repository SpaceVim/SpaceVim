# ============================================================================
# FILE: kind.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

import json
import re
import typing
from pathlib import Path

from defx.action import ActionAttr
from defx.action import ActionTable
from defx.action import do_action
from defx.context import Context
from defx.defx import Defx
from defx.session import Session
from defx.util import Nvim
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


class Base:

    def __init__(self, vim: Nvim) -> None:
        self.vim = vim
        self.name = 'base'

    def get_actions(self) -> typing.Dict[str, ActionTable]:
        return _action_table


@action(name='add_session', attr=ActionAttr.NO_TAGETS)
def _add_session(view: View, defx: Defx, context: Context) -> None:
    path = context.args[0] if context.args else defx._cwd
    if path[-1] == '/':
        # Remove the last slash
        path = path[: -1]

    opened_candidates = [] if context.args else list(defx._opened_candidates)
    opened_candidates.sort()

    session: Session
    if path in view._sessions:
        old_session = view._sessions[path]
        session = Session(
            name=old_session.name, path=old_session.path,
            opened_candidates=opened_candidates)
    else:
        name = Path(path).name
        session = Session(
            name=name, path=path,
            opened_candidates=opened_candidates)
        view.print_msg(f'session "{name}" is created')

    view._sessions[session.path] = session

    _save_session(view, defx, context)


@action(name='call', attr=ActionAttr.REDRAW)
def _call(view: View, defx: Defx, context: Context) -> None:
    """
    Call the function.
    """
    function = context.args[0] if context.args else None
    if not function:
        return

    dict_context = context._asdict()
    dict_context['cwd'] = defx._cwd
    dict_context['targets'] = [
        str(x['action__path']) for x in context.targets]
    view._vim.call(function, dict_context)


@action(name='clear_select_all', attr=ActionAttr.MARK | ActionAttr.NO_TAGETS)
def _clear_select_all(view: View, defx: Defx, context: Context) -> None:
    for candidate in [x for x in view._candidates
                      if x['_defx_index'] == defx._index]:
        candidate['is_selected'] = False


@action(name='close_tree', attr=ActionAttr.TREE | ActionAttr.CURSOR_TARGET)
def _close_tree(view: View, defx: Defx, context: Context) -> None:
    for target in context.targets:
        if target['is_directory'] and target['is_opened_tree']:
            view.close_tree(target['action__path'], defx._index)
        else:
            view.close_tree(target['action__path'].parent, defx._index)
            view.search_file(target['action__path'].parent, defx._index)


@action(name='delete_session', attr=ActionAttr.NO_TAGETS)
def _delete_session(view: View, defx: Defx, context: Context) -> None:
    if not context.args:
        return

    session_name = context.args[0]
    if session_name not in view._sessions:
        return
    view._sessions.pop(session_name)

    _save_session(view, defx, context)


@action(name='load_session', attr=ActionAttr.NO_TAGETS)
def _load_session(view: View, defx: Defx, context: Context) -> None:
    session_file = Path(context.session_file)
    if not context.session_file or not session_file.exists():
        return

    loaded_session = json.loads(session_file.read_text())
    if 'sessions' not in loaded_session:
        return

    view._sessions = {}
    for path, session in loaded_session['sessions'].items():
        view._sessions[path] = Session(**session)

    view._vim.current.buffer.vars['defx#_sessions'] = [
        x._asdict() for x in view._sessions.values()
    ]


@action(name='multi')
def _multi(view: View, defx: Defx, context: Context) -> None:
    for arg in context.args:
        args: typing.List[str]
        if isinstance(arg, list):
            args = arg
        else:
            args = [arg]
        do_action(view, defx, args[0], context._replace(args=args[1:]))


@action(name='check_redraw', attr=ActionAttr.NO_TAGETS)
def _nop(view: View, defx: Defx, context: Context) -> None:
    pass


@action(name='open_tree', attr=ActionAttr.TREE | ActionAttr.CURSOR_TARGET)
def _open_tree(view: View, defx: Defx, context: Context) -> None:
    nested = False
    recursive_level = 0
    toggle = False
    for arg in context.args:
        if arg == 'nested':
            nested = True
        elif arg == 'recursive':
            recursive_level = 20
        elif re.search(r'recursive:\d+', arg):
            recursive_level = int(arg.split(':')[1])
        elif arg == 'toggle':
            toggle = True

    for target in [x for x in context.targets if x['is_directory']]:
        if toggle and not target['is_directory'] or target['is_opened_tree']:
            _close_tree(view, defx, context._replace(targets=[target]))
        else:
            view.open_tree(target['action__path'],
                           defx._index, nested, recursive_level)


@action(name='open_tree_recursive',
        attr=ActionAttr.TREE | ActionAttr.CURSOR_TARGET)
def _open_tree_recursive(view: View, defx: Defx, context: Context) -> None:
    level = context.args[0] if context.args else '20'
    _open_tree(view, defx, context._replace(
        args=context.args + ['recursive:' + level]))


@action(name='open_or_close_tree',
        attr=ActionAttr.TREE | ActionAttr.CURSOR_TARGET)
def _open_or_close_tree(view: View, defx: Defx, context: Context) -> None:
    _open_tree(view, defx, context._replace(args=context.args + ['toggle']))


@action(name='print')
def _print(view: View, defx: Defx, context: Context) -> None:
    for target in context.targets:
        view.print_msg(str(target['action__path']))


@action(name='quit', attr=ActionAttr.NO_TAGETS)
def _quit(view: View, defx: Defx, context: Context) -> None:
    view.quit()


@action(name='redraw', attr=ActionAttr.NO_TAGETS)
def _redraw(view: View, defx: Defx, context: Context) -> None:
    view.redraw(True)


@action(name='repeat', attr=ActionAttr.MARK)
def _repeat(view: View, defx: Defx, context: Context) -> None:
    do_action(view, defx, view._prev_action, context)


@action(name='resize', attr=ActionAttr.NO_TAGETS)
def _resize(view: View, defx: Defx, context: Context) -> None:
    if not context.args:
        return

    view._context = view._context._replace(winwidth=int(context.args[0]))
    view._resize_window()
    view.redraw(True)


@action(name='save_session', attr=ActionAttr.NO_TAGETS)
def _save_session(view: View, defx: Defx, context: Context) -> None:
    view._vim.current.buffer.vars['defx#_sessions'] = [
        x._asdict() for x in view._sessions.values()
    ]

    if not context.session_file:
        return

    session_file = Path(context.session_file)
    session_file.write_text(json.dumps({
        'version': view._session_version,
        'sessions': {x: y._asdict() for x, y in view._sessions.items()}
    }))


@action(name='search', attr=ActionAttr.NO_TAGETS)
def _search(view: View, defx: Defx, context: Context) -> None:
    if not context.args or not context.args[0]:
        return

    search_path = context.args[0]
    path = Path(search_path)
    parents: typing.List[Path] = []
    while view.get_candidate_pos(
            path, defx._index) < 0 and path.parent != path:
        path = path.parent
        parents.append(path)

    for parent in reversed(parents):
        view.open_tree(parent, defx._index, False, 0)

    view.update_candidates()
    view.redraw()
    view.search_file(Path(search_path), defx._index)


@action(name='toggle_columns', attr=ActionAttr.REDRAW)
def _toggle_columns(view: View, defx: Defx, context: Context) -> None:
    """
    Toggle the current columns.
    """
    columns = (context.args[0] if context.args else '').split(':')
    if not columns:
        return
    current_columns = [x.name for x in view._columns]
    if columns == current_columns:
        # Use default columns
        columns = context.columns.split(':')
    view._init_columns(columns)


@action(name='toggle_ignored_files', attr=ActionAttr.REDRAW)
def _toggle_ignored_files(view: View, defx: Defx, context: Context) -> None:
    defx._enabled_ignored_files = not defx._enabled_ignored_files


@action(name='toggle_select', attr=ActionAttr.MARK | ActionAttr.NO_TAGETS)
def _toggle_select(view: View, defx: Defx, context: Context) -> None:
    candidate = view.get_cursor_candidate(context.cursor)
    if not candidate:
        return

    candidate['is_selected'] = not candidate['is_selected']


@action(name='toggle_select_all', attr=ActionAttr.MARK | ActionAttr.NO_TAGETS)
def _toggle_select_all(view: View, defx: Defx, context: Context) -> None:
    for candidate in [x for x in view._candidates
                      if not x['is_root'] and
                      x['_defx_index'] == defx._index]:
        candidate['is_selected'] = not candidate['is_selected']


@action(name='toggle_select_visual',
        attr=ActionAttr.MARK | ActionAttr.NO_TAGETS)
def _toggle_select_visual(view: View, defx: Defx, context: Context) -> None:
    if context.visual_start <= 0 or context.visual_end <= 0:
        return

    start = context.visual_start - 1
    end = min([context.visual_end, len(view._candidates)])
    for candidate in [x for x in view._candidates[start:end]
                      if not x['is_root'] and
                      x['_defx_index'] == defx._index]:
        candidate['is_selected'] = not candidate['is_selected']


@action(name='toggle_sort', attr=ActionAttr.MARK | ActionAttr.NO_TAGETS)
def _toggle_sort(view: View, defx: Defx, context: Context) -> None:
    """
    Toggle the current sort method.
    """
    sort = context.args[0] if context.args else ''
    if sort == defx._sort_method:
        # Use default sort method
        defx._sort_method = context.sort
    else:
        defx._sort_method = sort


@action(name='yank_path')
def _yank_path(view: View, defx: Defx, context: Context) -> None:
    yank = '\n'.join([str(x['action__path']) for x in context.targets])
    view._vim.call('setreg', '"', yank)
    if (view._vim.call('has', 'clipboard') or
            view._vim.call('has', 'xterm_clipboard')):
        view._vim.call('setreg', '+', yank)
    view.print_msg('Yanked:\n' + yank)
