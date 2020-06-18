# ============================================================================
# FILE: matcher_fuzzy.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

import re

from deoplete.base.filter import Base
from deoplete.util import (
    fuzzy_escape, binary_search_begin, binary_search_end)
from deoplete.util import Nvim, UserContext, Candidates


class Filter(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'matcher_fuzzy'
        self.description = 'fuzzy matcher'

    def filter(self, context: UserContext) -> Candidates:
        complete_str = context['complete_str']
        if context['ignorecase']:
            complete_str = complete_str.lower()
        if not complete_str:
            return context['candidates']  # type: ignore

        if context['is_sorted']:
            begin = binary_search_begin(
                context['candidates'], complete_str[0])
            end = binary_search_end(
                context['candidates'], complete_str[0])
            if begin < 0 or end < 0:
                return []
            candidates = context['candidates'][begin:end+1]
        else:
            candidates = context['candidates']

        p = re.compile(fuzzy_escape(complete_str, context['camelcase']))
        if context['ignorecase']:
            return [x for x in candidates if p.match(x['word'].lower())]
        else:
            return [x for x in candidates if p.match(x['word'])]
