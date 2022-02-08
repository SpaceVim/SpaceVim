# ============================================================================
# FILE: file_mru.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from .base import Base


class Source(Base):

    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'file_mru'
        self.kind = 'file'
        self.sorters = []
        self.vars = {
            'fnamemodify': ':~',
        }

    def gather_candidates(self, context):
        candidates = self.vim.call('neomru#_gather_file_candidates')

        def time_format(x):
            return self.vim.call('getftime', x)

        def path_format(x):
            return self.vim.call('fnamemodify', x, self.vars['fnamemodify'])

        if self.vim.vars['neomru#time_format'] == '':
            return [{
                'word': path_format(x),
                'abbr': path_format(x),
                'action__path': x
            } for x in candidates]
        else:
            return [{
                'word': path_format(x),
                'abbr': self.vim.call('neomru#_abbr',
                    path_format(x), time_format(x)),
                'action__path': x
            } for x in candidates]
