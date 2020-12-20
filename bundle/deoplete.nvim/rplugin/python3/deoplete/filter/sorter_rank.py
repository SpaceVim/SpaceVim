# ============================================================================
# FILE: sorter_rank.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

import re
import typing

from deoplete.base.filter import Base
from deoplete.util import getlines
from deoplete.util import Nvim, UserContext, Candidates, Candidate


LINES_MAX = 150


class Filter(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'sorter_rank'
        self.description = 'rank sorter'
        self._cache: typing.Dict[str, typing.Set[int]] = {}

    def on_event(self, context: UserContext) -> None:
        self._cache = {}
        start = max([1, context['position'][1] - LINES_MAX])
        linenr = start
        for line in getlines(self.vim, start, start + LINES_MAX):
            for m in re.finditer(context['keyword_pattern'], line):
                k = m.group(0)
                if k not in self._cache:
                    self._cache[k] = set()
                self._cache[k].add(linenr)
            linenr += 1

    def filter(self, context: UserContext) -> Candidates:
        complete_str = context['complete_str'].lower()
        linenr = context['position'][1]

        def compare(x: Candidate) -> int:
            word = x['word']
            matched = int(complete_str in word.lower())
            score = -matched * 40
            if word in self._cache:
                mru = min([abs(x - linenr) for x in self._cache[word]])
                mru -= LINES_MAX
                score += mru * 10
            return score
        return sorted(context['candidates'], key=compare)
