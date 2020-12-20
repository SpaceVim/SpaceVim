# ============================================================================
# FILE: defx/history.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

import typing

from defx.util import Nvim, UserContext, Candidates
from denite.source.base import Base


class Source(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'defx/history'
        self.kind = 'command'
        self._histories: typing.List[str] = []

    def on_init(self, context: UserContext) -> None:
        options = self.vim.current.buffer.options
        if 'filetype' not in options or options['filetype'] != 'defx':
            return

        self._histories = reversed(self.vim.vars['defx#_histories'])

    def gather_candidates(self, context: UserContext) -> Candidates:
        return [{
            'word': x,
            'abbr': f'{source_name}:{x}/',
            'action__command': ('call defx#call_action' +
                                f"('cd', ['{source_name}', '{x}'])"),
            'action__path': x,
        } for [source_name, x] in self._histories]
