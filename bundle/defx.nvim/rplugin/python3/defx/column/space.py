# ============================================================================
# FILE: space.py
# AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from defx.base.column import Base
from defx.context import Context
from defx.util import Nvim

import typing


class Column(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'space'

    def get(self, context: Context,
            candidate: typing.Dict[str, typing.Any]) -> str:
        return ' '

    def length(self, context: Context) -> int:
        return 1
