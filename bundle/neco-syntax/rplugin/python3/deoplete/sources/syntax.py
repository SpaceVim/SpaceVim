#=============================================================================
# FILE: syntax.py
# AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
#=============================================================================

from deoplete.base.source import Base

import deoplete.util

class Source(Base):
    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'syntax'
        self.mark = '[S]'
        self.__include_files = {}
        self.vim.call('necosyntax#initialize')

    def on_event(self, context):
        self.__include_files[context['filetype']] = [
            { 'word': x } for x in
            self.vim.call('necosyntax#gather_candidates')]

    def gather_candidates(self, context):
        return self.__include_files.get(context['filetype'], [])
