# ============================================================================
# FILE: matcher_full_fuzzy.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from pynvim import Nvim
import re

from deoplete.base.filter import Base
from deoplete.util import fuzzy_escape, UserContext, Candidates


class Filter(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'matcher_full_fuzzy'
        self.description = 'full fuzzy matcher'

    def filter(self, context: UserContext) -> Candidates:
        complete_str = context['complete_str']
        if context['ignorecase']:
            complete_str = complete_str.lower()
        p = re.compile(fuzzy_escape(complete_str, context['camelcase']))
        if context['ignorecase']:
            return [x for x in context['candidates']
                    if p.search(x['word'].lower())]
        else:
            return [x for x in context['candidates']
                    if p.search(x['word'])]
