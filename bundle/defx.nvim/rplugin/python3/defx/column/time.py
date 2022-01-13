# ============================================================================
# FILE: time.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from defx.base.column import Base, Highlights
from defx.context import Context
from defx.util import Nvim, readable, Candidate
from defx.view import View

import time
import typing


class Column(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'time'
        self.vars = {
            'format': '%y.%m.%d %H:%M',
        }
        self.has_get_with_highlights = True

        self._length = 0

    def on_init(self, view: View, context: Context) -> None:
        self._length = self.vim.call('strwidth',
                                     time.strftime(self.vars['format']))

    def get_with_highlights(
        self, context: Context, candidate: Candidate
    ) -> typing.Tuple[str, Highlights]:
        path = candidate['action__path']
        if not readable(path):
            return (str(' ' * self._length), [])
        text = time.strftime(self.vars['format'],
                             time.localtime(path.stat().st_mtime))
        return (text, [(self.highlight_name, self.start, self._length)])

    def length(self, context: Context) -> int:
        return self._length

    def highlight_commands(self) -> typing.List[str]:
        commands: typing.List[str] = []
        commands.append(
            f'highlight default link {self.highlight_name} Identifier')
        return commands
