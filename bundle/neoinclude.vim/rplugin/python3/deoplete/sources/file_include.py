#=============================================================================
# FILE: file_include.py
# AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
#=============================================================================

from .base import Base

import deoplete.util

class Source(Base):
    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'file/include'
        self.mark = '[FI]'
        self.is_bytepos = True
        self.min_pattern_length = 0

    def get_complete_position(self, context):
        return self.vim.call(
            'neoinclude#file_include#get_complete_position', context['input'])

    def gather_candidates(self, context):
        return self.vim.call(
            'neoinclude#file_include#get_include_files', context['input'])
