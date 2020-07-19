# ============================================================================
# FILE: defx/session.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from defx.util import Nvim, UserContext, Candidates
from denite.kind.command import Kind as Command
from denite.source.base import Base


class Source(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'defx/session'
        self.kind = Kind(vim)

    def on_init(self, context: UserContext) -> None:
        self._winid = self.vim.call('win_getid')
        self._bufnr = self.vim.call('bufnr', '%')

    def gather_candidates(self, context: UserContext) -> Candidates:
        sessions = self.vim.call(
            'getbufvar', self._bufnr, 'defx#_sessions', [])
        if not sessions:
            return []

        max_name = max([self.vim.call('strwidth', x['name'])
                        for x in sessions])
        word_format = '{0:<' + str(max_name) + '} - {1}'
        return [{
            'word': word_format.format(x['name'], x['path']),
            'action__command': "call defx#call_action('cd', '{}')".format(
                x['path']),
            'action__path': x['path'],
            'source__winid': self._winid,
        } for x in sessions]


class Kind(Command):
    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'defx/session'
        self.persist_actions += ['delete']
        self.redraw_actions += ['delete']

    def action_delete(self, context: UserContext) -> Candidates:
        winid = self.vim.call('win_getid')

        for candidate in context['targets']:
            self.vim.call('win_gotoid', candidate['source__winid'])
            self.vim.call('defx#call_action', 'delete_session',
                          candidate['action__path'])

        self.vim.call('win_gotoid', winid)
