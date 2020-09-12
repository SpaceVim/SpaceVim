# ============================================================================
# FILE: file/list.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from pathlib import Path
import typing

from defx.base.source import Base
from defx.source.file import Source as File
from defx.context import Context
from defx.util import error, readable, safe_call, Nvim


class Source(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'file/list'

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
            'is_directory': False,
            'action__path': path,
        }

    def gather_candidates(
            self, context: Context, path: Path
    ) -> typing.List[typing.Dict[str, typing.Any]]:
        if not readable(path):
            error(self.vim, f'"{path}" is not readable file.')
            return []

        if path.is_dir():
            # Fallback to file source
            return File(self.vim).gather_candidates(context, path)

        candidates = []
        with path.open() as f:
            for line in f:
                entry = Path(line.rstrip('\n'))
                if not entry.exists():
                    continue
                candidates.append({
                    'word': str(entry) + (
                        '/' if safe_call(entry.is_dir, False) else ''),
                    'is_directory': safe_call(entry.is_dir, False),
                    'action__path': entry,
                })
        return candidates
