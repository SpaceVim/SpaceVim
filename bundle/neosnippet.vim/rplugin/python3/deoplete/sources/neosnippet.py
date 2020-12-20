#=============================================================================
# FILE: neosnippet.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
#=============================================================================

import re
from deoplete.base.source import Base


class Source(Base):
    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'neosnippet'
        self.mark = '[ns]'
        self.rank = 200
        self.__cache = {}

    def on_event(self, context):
        self.__cache[context['filetype']] = self.vim.eval(
            'values(neosnippet#helpers#get_completion_snippets())')
        for candidate in self.__cache[context['filetype']]:
            candidate['dup'] = 1
            candidate['menu'] = candidate['menu_abbr']

    def gather_candidates(self, context):
        candidates = self.__cache.get(context['filetype'], [])
        if context['filetype'] not in self.__cache:
            self.on_event(context)
        m1 = re.match(r'\w+$', context['complete_str'])
        m2 = re.match(r'\S+$', context['complete_str'])
        if m1 and m2 and m1.group(0) != m2.group(0):
            candidates = [x for x in candidates if x['options']['word']]
        return candidates
