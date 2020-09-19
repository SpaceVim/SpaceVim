# ============================================================================
# FILE: unite.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from .base import Base
from copy import copy
from re import sub


class Source(Base):

    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'unite'
        self.kind = 'unite'

    def gather_candidates(self, context):
        if not context['args']:
            return []
        candidates = self.vim.call('unite#get_candidates',
                                   [context['args']])
        # Convert the attributes for compatibility.
        for candidate in candidates:
            candidate['source__candidate'] = copy(candidate)
            candidate['kind'] = 'unite'
            candidate['word'] = sub(r'\n.*', r'', candidate['word'])
            candidate['abbr'] = candidate['source'] + ': ' + sub(
                r'\n.*', r'', candidate.get('abbr', candidate['word']))
        return candidates
