# ============================================================================
# FILE: converter_truncate_abbr.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from deoplete.base.filter import Base
from deoplete.util import truncate_skipping, Nvim, UserContext, Candidates


class Filter(Base):
    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'converter_truncate_abbr'
        self.description = 'truncate abbr converter'

    def filter(self, context: UserContext) -> Candidates:
        max_width = context['max_abbr_width']
        if max_width <= 0:
            return context['candidates']  # type: ignore

        footer_width = max_width / 3
        for candidate in context['candidates']:
            candidate['abbr'] = truncate_skipping(
                candidate.get('abbr', candidate['word']),
                max_width, '..', footer_width)
        return context['candidates']  # type: ignore
