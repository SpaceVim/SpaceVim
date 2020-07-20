# ============================================================================
# FILE: converter_reorder_attr.py
# AUTHOR: @reaysawa
# License: MIT license
# ============================================================================

import re
import typing

from deoplete.base.filter import Base
from deoplete.util import Nvim, UserContext, Candidates


class Filter(Base):
    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'converter_reorder_attr'
        self.description = 'Reorder candidates based on their attributes'
        self.vars = {
            'attrs_order': {},
        }

    @staticmethod
    def filter_attrs(candidates: Candidates,
                     preferred_order_attrs: typing.Dict[str, typing.Any],
                     max_list_size: int = 500) -> Candidates:
        context_candidates = candidates[:]
        new_candidates = []
        new_candidates_len = 0

        for attr in preferred_order_attrs.keys():
            for expr in preferred_order_attrs[attr]:
                disabled = expr[0] == '!'
                if disabled:
                    expr = expr[1:]

                expr = re.compile(expr)
                size = len(context_candidates)
                i = 0
                while i < size:
                    candidate = context_candidates[i]
                    if attr in candidate and expr.search(candidate[attr]):
                        candidate = context_candidates.pop(i)
                        # Popping will make 'i' effectively go forward an extra
                        # time; because of that, decrease for now and wait for
                        # the +1 at the bottom to balance that out.
                        i -= 1
                        size -= 1
                        if not disabled:
                            new_candidates.append(candidate)
                            new_candidates_len += 1
                            # Stop filtering if the maximum has been achieved
                            if new_candidates_len == max_list_size:
                                return new_candidates
                    i += 1

            # Add remaining at the bottom
            new_candidates.extend(context_candidates)
            # Go to the next attribute with the new list order
            context_candidates = new_candidates

        return new_candidates

    def filter(self, context: UserContext) -> Candidates:
        preferred_order_attrs = self.get_var(  # type: ignore
            'attrs_order').get(context['filetype'], [])
        if not context['candidates'] or not preferred_order_attrs:
            return context['candidates']  # type: ignore

        max_list_size = self.vim.call(
            'deoplete#custom#_get_option', 'max_list'
        )

        return self.filter_attrs(
            context['candidates'], preferred_order_attrs, max_list_size
        )
