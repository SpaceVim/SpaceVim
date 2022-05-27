# ============================================================================
# FILE: matcher_length.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from pynvim import Nvim

from deoplete.base.filter import Base
from deoplete.util import UserContext, Candidates


class Filter(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'matcher_length'
        self.description = 'length matcher'

    def filter(self, context: UserContext) -> Candidates:
        input_len = len(context['complete_str'])
        return [x for x in context['candidates']
                if len(x['word']) > input_len]
