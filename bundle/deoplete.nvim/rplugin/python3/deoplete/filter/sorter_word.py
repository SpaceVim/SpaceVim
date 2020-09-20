# ============================================================================
# FILE: sorter_word.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from deoplete.base.filter import Base
from deoplete.util import Nvim, UserContext, Candidates


class Filter(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'sorter_word'
        self.description = 'word sorter'

    def filter(self, context: UserContext) -> Candidates:
        return sorted(context['candidates'],
                      key=lambda x: x['word'].swapcase())
