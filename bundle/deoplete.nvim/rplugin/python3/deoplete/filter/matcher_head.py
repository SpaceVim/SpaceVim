# ============================================================================
# FILE: matcher_head.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from pynvim import Nvim

from deoplete.base.filter import Base
from deoplete.util import binary_search_begin, binary_search_end
from deoplete.util import UserContext, Candidates


class Filter(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'matcher_head'
        self.description = 'head matcher'

    def filter(self, context: UserContext) -> Candidates:
        complete_str = context['complete_str']
        if context['ignorecase']:
            complete_str = complete_str.lower()

        if context['is_sorted']:
            begin = binary_search_begin(
                context['candidates'], complete_str)
            end = binary_search_end(
                context['candidates'], complete_str)
            if begin < 0 or end < 0:
                return []
            candidates = context['candidates'][begin:end+1]

            if context['ignorecase']:
                return list(candidates)
        else:
            candidates = context['candidates']

        if context['ignorecase']:
            return [x for x in context['candidates']
                    if x['word'].lower().startswith(complete_str)]
        else:
            return [x for x in context['candidates']
                    if x['word'].startswith(complete_str)]
