# ============================================================================
# FILE: mark.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from defx.base.column import Base, Highlights
from defx.context import Context
from defx.util import Nvim, Candidate, len_bytes

import os
import typing


class Column(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'mark'
        self.vars = {
            'length': 1,
            'readonly_icon': 'X',
            'selected_icon': '*',
        }
        self._syntaxes = [
            'directory',
            'opened',
            'readonly',
            'selected',
        ]
        self.has_get_with_highlights = True

        self._icons = {
            'readonly': 'Comment',
            'selected': 'Statement',
        }

    def get_with_highlights(
        self, context: Context, candidate: Candidate
    ) -> typing.Tuple[str, Highlights]:
        if candidate['is_selected']:
            return (str(self.vars['selected_icon']),
                    [(f'{self.highlight_name}_selected',
                      self.start, len_bytes(self.vars['selected_icon']))])
        elif not os.access(str(candidate['action__path']), os.W_OK):
            return (str(self.vars['readonly_icon']),
                    [(f'{self.highlight_name}_readonly',
                      self.start, len_bytes(self.vars['readonly_icon']))])
        return (' ' * self.vars['length'], [])

    def length(self, context: Context) -> int:
        return typing.cast(int, self.vars['length'])

    def syntaxes(self) -> typing.List[str]:
        return [self.syntax_name + '_' + x for x in self._syntaxes]

    def highlight_commands(self) -> typing.List[str]:
        commands: typing.List[str] = []
        for icon, highlight in self._icons.items():
            commands.append(
                'highlight default link {}_{} {}'.format(
                    self.highlight_name, icon, highlight))
        return commands
