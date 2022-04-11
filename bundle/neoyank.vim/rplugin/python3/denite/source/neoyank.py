# ============================================================================
# FILE: neoyank.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from .base import Base
import re


class Source(Base):

    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'neoyank'
        self.kind = 'word'

    def gather_candidates(self, context):
        self.vim.call('neoyank#update')
        candidates = []
        for [register, history] in self.vim.call(
                'neoyank#_get_yank_histories').items():
            candidates += [{
                'word': register + ': ' + re.sub(r'\n', r'\\n', x[0])[:200],
                'action__text': x[0],
                'action__regtype': x[1],
            } for x in history]
        return candidates
