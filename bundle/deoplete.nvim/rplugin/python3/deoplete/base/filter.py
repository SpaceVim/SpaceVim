# ============================================================================
# FILE: filter.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

import typing

from abc import abstractmethod
from deoplete.logger import LoggingMixin
from deoplete.util import error_vim, Nvim, UserContext, Candidates


class Base(LoggingMixin):

    def __init__(self, vim: Nvim) -> None:
        self.vim = vim
        self.name = 'base'
        self.description = ''
        self.vars: typing.Dict[str, typing.Any] = {}

    def on_event(self, context: UserContext) -> None:
        pass

    def get_var(self, var_name: str) -> typing.Optional[typing.Any]:
        custom_vars = self.vim.call(
            'deoplete#custom#_get_filter', self.name)
        if var_name in custom_vars:
            return custom_vars[var_name]
        if var_name in self.vars:
            return self.vars[var_name]
        return None

    @abstractmethod
    def filter(self, context: UserContext) -> Candidates:
        return []

    def print_error(self, expr: typing.Any) -> None:
        error_vim(self.vim, expr)
