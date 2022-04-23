# ============================================================================
# FILE: around.py
# AUTHOR: Khalidov Oleg <brooth at gmail.com>
# License: MIT license
# ============================================================================

from pynvim import Nvim
import re

from deoplete.base.source import Base
from deoplete.util import parse_buffer_pattern, getlines
from deoplete.util import UserContext, Candidates


class Source(Base):
    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)
        self.name = 'around'
        self.rank = 300
        self.vars = {
            'mark_above': '[A]',
            'mark_below': '[A]',
            'mark_changes': '[A]',
            'range_above': 20,
            'range_below': 20,
        }
        custom_vars = self.vim.call(
            'deoplete#custom#_get_source_vars', self.name
        )
        if custom_vars:
            self.vars.update(custom_vars)

    def gather_candidates(self, context: UserContext) -> Candidates:
        line = context['position'][1]
        candidates: Candidates = []

        # lines above
        words = parse_buffer_pattern(
            reversed(
                getlines(
                    self.vim, max([1, line - self.vars['range_above']]), line
                )
            ),
            context['keyword_pattern'],
        )
        candidates += [
            {'word': x, 'menu': self.vars['mark_above']} for x in words
        ]

        # grab ':changes' command output
        p = re.compile(r'[\s\d]+')
        lines = set()
        for change_line in [
            x[p.search(x).span()[1]:]  # type: ignore
            for x in self.vim.call('execute', 'changes').split('\n')[2:]
            if p.search(x)
        ]:
            if change_line and change_line != '-invalid-':
                lines.add(change_line)

        words = parse_buffer_pattern(lines, context['keyword_pattern'])
        candidates += [
            {'word': x, 'menu': self.vars['mark_changes']} for x in words
        ]

        # lines below
        words = parse_buffer_pattern(
            getlines(self.vim, line, line + self.vars['range_below']),
            context['keyword_pattern'],
        )
        candidates += [
            {'word': x, 'menu': self.vars['mark_below']} for x in words
        ]

        return candidates
