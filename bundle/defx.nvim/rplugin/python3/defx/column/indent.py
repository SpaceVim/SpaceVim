# ============================================================================
# FILE: indent.py
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

        self.name = 'indent'
        self.vars = {
            'indent': ' ',
        }
        self.is_start_variable = True

    def get(self, context: Context,
            candidate: typing.Dict[str, typing.Any]) -> str:
        return str(self.vars['indent'] * candidate['level'])

    def length(self, context: Context) -> int:
        return int(max([x['level'] for x in context.targets]))
