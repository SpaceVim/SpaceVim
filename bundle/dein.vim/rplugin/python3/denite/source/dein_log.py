# ============================================================================
# FILE: dein_log.py
# AUTHOR: delphinus <delphinus@remora.cx>
# License: MIT license
# ============================================================================

import re
from .base import Base

HEADER_RE = re.compile(r'^\s*[a-zA-Z_]\w*://')
SPACE_RE = re.compile(r'^\s+')
DEIN_LOG_SYNTAX_HIGHLIGHT = [
    {'name': 'Progress', 're': r'\[[ =]\+\]', 'link': 'String'},
    {'name': 'Source', 're': r'|.\{-}|', 'link': 'Type'},
    {'name': 'URI', 're': r'-> diff URI', 'link': 'Underlined'},
    ]


class Source(Base):

    def __init__(self, vim):
        super().__init__(vim)

        self.name = 'dein/log'

    def on_init(self, context):
        context['__source_log'] = []

    def gather_candidates(self, context):
        dein_context = self.vim.call('dein#install#_get_context')
        context['is_async'] = bool(dein_context)
        if context['args'] and context['args'][0] == '!':
            log_func = 'dein#install#_get_updates_log'
        else:
            log_func = 'dein#install#_get_log'
        logs = self.vim.call(log_func)

        def make_candidates(row):
            return {
                'word': ' -> diff URI',
                'kind': 'file',
                'action__path': SPACE_RE.sub('', row),
                } if HEADER_RE.match(row) else {'word': row, 'kind': 'word'}

        rows = len(context['__source_log'])
        candidates = list(map(make_candidates, logs[rows:]))
        context['__source_log'] = logs

        # Needs wait to call Vim output handlers
        self.vim.command('sleep 100m')
        return candidates

    def highlight(self):
        for syn in DEIN_LOG_SYNTAX_HIGHLIGHT:
            self.vim.command(
                'syntax match {0}_{1} /{2}/ contained containedin={0}'
                .format(self.syntax_name, syn['name'], syn['re']))
            self.vim.command(
                'highlight default link {0}_{1} {2}'
                .format(self.syntax_name, syn['name'], syn['link']))
