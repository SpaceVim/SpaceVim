# ============================================================================
# FILE: mark.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from defx.base.column import Base
from defx.context import Context
from defx.util import Nvim

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

    def get(self, context: Context,
            candidate: typing.Dict[str, typing.Any]) -> str:
        icon: str = ' ' * self.vars['length']
        if candidate['is_selected']:
            icon = self.vars['selected_icon']
        elif not os.access(str(candidate['action__path']), os.W_OK):
            icon = self.vars['readonly_icon']
        return icon

    def length(self, context: Context) -> int:
        return typing.cast(int, self.vars['length'])

    def syntaxes(self) -> typing.List[str]:
        return [self.syntax_name + '_' + x for x in self._syntaxes]

    def highlight_commands(self) -> typing.List[str]:
        commands: typing.List[str] = []
        for icon, highlight in {
                'readonly': 'Comment',
                'selected': 'Statement',
        }.items():
            commands.append(
                ('syntax match {0}_{1} /[{2}]/ ' +
                 'contained containedin={0}').format(
                    self.syntax_name, icon, self.vars[icon + '_icon']))
            commands.append(
                'highlight default link {}_{} {}'.format(
                    self.syntax_name, icon, highlight))
        return commands
