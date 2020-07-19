# ============================================================================
# FILE: converter_truncate_info.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from deoplete.base.filter import Base
from deoplete.util import truncate_skipping, Nvim, UserContext, Candidates


class Filter(Base):
    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'converter_truncate_info'
        self.description = 'truncate info converter'

    def filter(self, context: UserContext) -> Candidates:
        max_width = context['max_info_width']
        if not context['candidates'] or max_width <= 0:
            return context['candidates']  # type: ignore

        footer_width = 1
        for candidate in context['candidates']:
            candidate['info'] = truncate_skipping(
                candidate.get('info', ''),
                max_width, '..', footer_width)
        return context['candidates']  # type: ignore
