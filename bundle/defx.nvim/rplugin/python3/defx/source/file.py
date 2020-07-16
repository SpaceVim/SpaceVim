# ============================================================================
# FILE: file.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from pathlib import Path
import typing

from defx.base.source import Base
from defx.context import Context
from defx.util import error, readable, safe_call, Nvim


class Source(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'file'

        from defx.kind.file import Kind
        self.kind: Kind = Kind(self.vim)

        self.vars = {
            'root': None,
        }

    def get_root_candidate(
            self, context: Context, path: Path
    ) -> typing.Dict[str, typing.Any]:
        word = self.vim.call('fnamemodify', str(path), ':~')
        if self.vim.call('defx#util#is_windows'):
            word = word.replace('\\', '/')
        if word[-1:] != '/':
            word += '/'
        if self.vars['root']:
            word = self.vim.call(self.vars['root'], str(path))
        word = word.replace('\n', '\\n')

        return {
            'word': word,
            'is_directory': True,
            'action__path': path,
        }

    def gather_candidates(
            self, context: Context, path: Path
    ) -> typing.List[typing.Dict[str, typing.Any]]:
        candidates = []
        if not readable(path) or not path.is_dir():
            error(self.vim, f'"{path}" is not readable directory.')
            return []
        for entry in path.iterdir():
            candidates.append({
                'word': entry.name.replace('\n', '\\n') + (
                    '/' if safe_call(entry.is_dir, False) else ''),
                'is_directory': safe_call(entry.is_dir, False),
                'action__path': entry,
            })
        return candidates
