# ============================================================================
# FILE: neosnippet.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from .base import Base


class Source(Base):

    def __init__(self, vim):
        super().__init__(vim)

        self.name = 'neosnippet'
        self.kind = 'word'

        self._snippets = []

    def on_init(self, context):
        self._snippets = self.vim.eval(
            'values(neosnippet#helpers#get_completion_snippets())')

    def gather_candidates(self, context):
        candidates = []
        for snippet in self._snippets:
            candidates.append({
                'word': snippet['word'],
                'abbr': '{:<50} {}'.format(snippet['word'], snippet['menu_abbr']),
                'action__text': snippet['word'],
            })
        return candidates
