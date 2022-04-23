# ============================================================================
# FILE: converter_auto_delimiter.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from pynvim import Nvim
import typing

from deoplete.base.filter import Base
from deoplete.util import UserContext, Candidates


class Filter(Base):
    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'converter_auto_delimiter'
        self.description = 'auto delimiter converter'
        self.vars = {
            'delimiters': ['/'],
        }

    def filter(self, context: UserContext) -> Candidates:
        delimiters: typing.List[str] = self.get_var('delimiters')
        for candidate, delimiter in [
                [x, last_find(x['abbr'], delimiters)]
                for x in context['candidates']
                if 'abbr' in x and x['abbr'] and
                not last_find(x['word'], delimiters) and
                last_find(x['abbr'], delimiters)]:
            candidate['word'] += delimiter
        return list(context['candidates'])


def last_find(s: str, needles: typing.List[str]) -> typing.Optional[str]:
    for needle in needles:
        if len(s) >= len(needle) and s[-len(needle):] == needle:
            return needle
    return None
