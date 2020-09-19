# ============================================================================
# FILE: __init__.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from enum import auto, IntFlag
import typing

from defx.context import Context
from defx.defx import Defx
from defx.view import View


class ActionAttr(IntFlag):
    REDRAW = auto()
    MARK = auto()
    NO_TAGETS = auto()
    CURSOR_TARGET = auto()
    TREE = auto()
    NONE = 0


class ActionTable(typing.NamedTuple):
    func: typing.Callable[[View, Defx, Context], None]
    attr: ActionAttr = ActionAttr.NONE


def do_action(view: View, defx: Defx,
              action_name: str, context: Context) -> bool:
    """
    Do "action_name" action.
    """
    actions: typing.Dict[str, ActionTable] = defx._source.kind.get_actions()

    if action_name not in actions:
        return True

    action = actions[action_name]

    selected_candidates = [x for x in view._candidates if x['is_selected']]
    if (selected_candidates and
            ActionAttr.NO_TAGETS not in action.attr and
            ActionAttr.TREE not in action.attr):
        # Clear marks
        for candidate in selected_candidates:
            candidate['is_selected'] = False
        view.redraw()

    if ActionAttr.CURSOR_TARGET in action.attr:
        # Use cursor candidate only
        cursor_candidate = view.get_cursor_candidate(context.cursor)
        if not cursor_candidate:
            return True
        context = context._replace(
            targets=[cursor_candidate],
        )

    action.func(view, defx, context)

    if action_name != 'repeat':
        view._prev_action = action_name

    if ActionAttr.MARK in action.attr:
        # Update marks
        view.update_candidates()
        view.redraw()
    elif ActionAttr.TREE in action.attr:
        view.update_candidates()
        view.redraw()
    elif ActionAttr.REDRAW in action.attr:
        # Redraw
        view.redraw(True)
    return False
