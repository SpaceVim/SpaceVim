# ============================================================================
# FILE: converter_auto_delimiter.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

import typing

from deoplete.base.filter import Base
from deoplete.util import Nvim, UserContext, Candidates


class Filter(Base):
    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'converter_auto_delimiter'
        self.description = 'auto delimiter converter'
        self.vars = {
            'delimiters': ['/'],
        }

    def filter(self, context: UserContext) -> Candidates:
        delimiters: typing.List[str] = self.get_var(  # type: ignore
            'delimiters')
        for candidate, delimiter in [
                [x, last_find(x['abbr'], delimiters)]
                for x in context['candidates']
                if 'abbr' in x and x['abbr'] and
                not last_find(x['word'], delimiters) and
                last_find(x['abbr'], delimiters)]:
            candidate['word'] += delimiter
        return context['candidates']  # type: ignore


def last_find(s: str, needles: typing.List[str]) -> typing.Optional[str]:
    for needle in needles:
        if len(s) >= len(needle) and s[-len(needle):] == needle:
            return needle
    return None
