# ============================================================================
# FILE: matcher_matchfuzzy.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from pynvim import Nvim

from deoplete.base.filter import Base
from deoplete.util import UserContext, Candidates


class Filter(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'matcher_matchfuzzy'
        self.description = 'matchfuzzy() matcher'

    def filter(self, context: UserContext) -> Candidates:
        if not self.vim.call('exists', '*matchfuzzy'):
            return []

        return list(self.vim.call(
                        'matchfuzzy', context['candidates'],
                        context['complete_str'], {'key': 'word'}
                ))
