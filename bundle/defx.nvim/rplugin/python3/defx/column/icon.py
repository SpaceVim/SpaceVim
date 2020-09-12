# ============================================================================
# FILE: icon.py
# AUTHOR: GuoPan Zhao <zgpio@qq.com>
#         Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from defx.base.column import Base, Highlights
from defx.context import Context
from defx.util import Nvim, Candidate, len_bytes

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
        self.has_get_with_highlights = True

        self._syntaxes = [
            'directory_icon',
            'opened_icon',
            'root_icon',
        ]
        self._highlights = {
            'directory': 'Special',
            'opened': 'Special',
            'root': 'Identifier',
        }

    def get_with_highlights(
        self, context: Context, candidate: Candidate
    ) -> typing.Tuple[str, Highlights]:
        if candidate['is_opened_tree']:
            return (self.vars['opened_icon'],
                    [(f'{self.highlight_name}_opened_icon',
                      self.start, len_bytes(self.vars['opened_icon']))])
        elif candidate['is_root']:
            return (self.vars['root_icon'],
                    [(f'{self.highlight_name}_root_icon',
                      self.start, len_bytes(self.vars['root_icon']))])
        elif candidate['is_directory']:
            return (self.vars['directory_icon'],
                    [(f'{self.highlight_name}_directory_icon',
                      self.start, len_bytes(self.vars['directory_icon']))])

        return (' ', [])

    def length(self, context: Context) -> int:
        return typing.cast(int, self.vars['length'])

    def syntaxes(self) -> typing.List[str]:
        return [self.syntax_name + '_' + x for x in self._syntaxes]

    def highlight_commands(self) -> typing.List[str]:
        commands: typing.List[str] = []
        for icon, highlight in self._highlights.items():
            commands.append(
                'highlight default link {}_{}_icon {}'.format(
                    self.highlight_name, icon, highlight))

        return commands
