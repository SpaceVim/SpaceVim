# ============================================================================
# FILE: defx/drive.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from pathlib import Path
import typing

from defx.util import Nvim, UserContext, Candidates
from denite.source.base import Base


class Source(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'defx/drive'
        self.kind = 'command'
        self._drives: typing.List[str] = []

    def on_init(self, context: UserContext) -> None:
        options = self.vim.current.buffer.options
        if 'filetype' not in options or options['filetype'] != 'defx':
            return

        self._drives = self.vim.vars['defx#_drives']

    def gather_candidates(self, context: UserContext) -> Candidates:
        return [{
            'word': x,
            'abbr': x + '/',
            'action__command': f"call defx#call_action('cd', ['{x}'])",
            'action__path': x,
        } for x in self._drives if Path(x).exists()]
