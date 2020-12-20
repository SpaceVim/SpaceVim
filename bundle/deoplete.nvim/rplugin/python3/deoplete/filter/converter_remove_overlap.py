# ============================================================================
# FILE: converter_remove_overlap.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

import re
import typing

from deoplete.base.filter import Base
from deoplete.util import Nvim, UserContext, Candidates


class Filter(Base):
    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'converter_remove_overlap'
        self.description = 'remove overlap converter'

    def filter(self, context: UserContext) -> Candidates:
        if not context['next_input']:
            return context['candidates']  # type: ignore
        next_input_words = [x for x in re.split(
            r'([a-zA-Z_]+|\W)', context['next_input']) if x]

        check_pairs = []
        if self.vim.call('searchpair', '(', '', ')', 'bnw'):
            check_pairs.append(['(', ')'])
        if self.vim.call('searchpair', '[', '', ']', 'bnw'):
            check_pairs.append(['[', ']'])

        for [overlap, candidate, word] in [
                [x, y, y['word']] for x, y
                in [[overlap_length(x['word'], next_input_words), x]
                    for x in context['candidates']] if x > 0]:
            if [x for x in check_pairs if x[0] in word and x[1] in word]:
                continue
            if 'abbr' not in candidate:
                candidate['abbr'] = word
            candidate['word'] = word[: -overlap]
        return context['candidates']  # type: ignore


def overlap_length(left: str, next_input_words: typing.List[str]) -> int:
    pos = len(next_input_words)
    while pos > 0 and not left.endswith(''.join(next_input_words[:pos])):
        pos -= 1
    return len(''.join(next_input_words[:pos]))
