# ============================================================================
# FILE: icon.py
# AUTHOR: GuoPan Zhao <zgpio@qq.com>
#         Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from defx.base.column import Base
from defx.context import Context
from defx.util import Nvim

import typing


class Column(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'icon'
        self.vars = {
            'length': 1,
            'directory_icon': '+',
            'opened_icon': '-',
            'root_icon': ' ',
        }
        self._syntaxes = [
            'directory_icon',
            'opened_icon',
            'root_icon',
        ]

    def get(self, context: Context,
            candidate: typing.Dict[str, typing.Any]) -> str:
        icon: str = ' '
        if candidate['is_opened_tree']:
            icon = self.vars['opened_icon']
        elif candidate['is_root']:
            icon = self.vars['root_icon']
        elif candidate['is_directory']:
            icon = self.vars['directory_icon']

        return icon

    def length(self, context: Context) -> int:
        return typing.cast(int, self.vars['length'])

    def syntaxes(self) -> typing.List[str]:
        return [self.syntax_name + '_' + x for x in self._syntaxes]

    def highlight_commands(self) -> typing.List[str]:
        commands: typing.List[str] = []
        for icon, highlight in {
                'directory': 'Special',
                'opened': 'Special',
                'root': 'Identifier',
        }.items():
            commands.append(
                ('syntax match {0}_{1}_icon /[{2}]{3}/ ' +
                 'contained containedin={0}').format(
                     self.syntax_name, icon, self.vars[icon + '_icon'],
                     ' ' if self.is_within_variable else ''
                 ))
            commands.append(
                'highlight default link {}_{}_icon {}'.format(
                    self.syntax_name, icon, highlight))

        return commands
