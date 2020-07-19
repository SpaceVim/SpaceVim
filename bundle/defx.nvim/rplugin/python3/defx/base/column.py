# ============================================================================
# FILE: column.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

import typing

from abc import abstractmethod

from defx.context import Context
from defx.util import Nvim
from defx.util import error
from defx.view import View


class Base:

    def __init__(self, vim: Nvim) -> None:
        self.vim: Nvim = vim
        self.name: str = 'base'
        self.syntax_name: str = ''
        self.start: int = -1
        self.end: int = -1
        self.vars: typing.Dict[str, typing.Any] = {}
        self.is_start_variable: bool = False
        self.is_stop_variable: bool = False
        self.is_within_variable: bool = False

    def on_init(self, view: View, context: Context) -> None:
        pass

    def on_redraw(self, view: View, context: Context) -> None:
        pass

    def get(self, context: Context,
            candidate: typing.Dict[str, typing.Any]) -> str:
        return ''

    def get_with_variable_text(
            self, context: Context, variable_text: str,
            candidate: typing.Dict[str, typing.Any]) -> str:
        return ''

    @abstractmethod
    def length(self, context: Context) -> int:
        pass

    def syntaxes(self) -> typing.List[str]:
        return []

    def highlight_commands(self) -> typing.List[str]:
        return []

    def debug(self, expr: typing.Any) -> None:
        error(self.vim, expr)
