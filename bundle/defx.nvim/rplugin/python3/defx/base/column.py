# ============================================================================
# FILE: column.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

import typing

from abc import abstractmethod

from defx.context import Context
from defx.util import Nvim, Candidate
from defx.util import error
from defx.view import View

Highlights = typing.List[typing.Tuple[str, int, int]]


class Base:

    def __init__(self, vim: Nvim) -> None:
        self.vim: Nvim = vim
        self.name: str = 'base'
        self.syntax_name: str = ''
        self.highlight_name: str = ''
        self.start: int = -1
        self.end: int = -1
        self.vars: typing.Dict[str, typing.Any] = {}
        self.is_start_variable: bool = False
        self.is_stop_variable: bool = False
        self.is_within_variable: bool = False
        self.has_get_with_highlights: bool = False

    def on_init(self, view: View, context: Context) -> None:
        pass

    def on_redraw(self, view: View, context: Context) -> None:
        pass

    def get(self, context: Context, candidate: Candidate) -> str:
        return ''

    def get_with_variable_text(
            self, context: Context, variable_text: str, candidate: Candidate
    ) -> typing.Tuple[str, Highlights]:
        return ('', [])

    def get_with_highlights(
        self, context: Context, candidate: Candidate
    ) -> typing.Tuple[str, Highlights]:
        return ('', [])

    @abstractmethod
    def length(self, context: Context) -> int:
        pass

    def syntaxes(self) -> typing.List[str]:
        return []

    def highlight_commands(self) -> typing.List[str]:
        return []

    def debug(self, expr: typing.Any) -> None:
        error(self.vim, expr)
