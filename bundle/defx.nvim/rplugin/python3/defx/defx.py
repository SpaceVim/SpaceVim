# ============================================================================
# FILE: defx.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

import typing

from defx.base.source import Base as Source
from defx.source.file.list import Source as SourceList
from defx.source.file import Source as SourceFile
from defx.context import Context
from defx.sort import sort
from defx.util import Nvim
from defx.util import cd, error
from pathlib import Path


Candidate = typing.Dict[str, typing.Any]


class Defx(object):

    def __init__(self, vim: Nvim, context: Context,
                 source_name: str, cwd: str, index: int) -> None:
        self._vim = vim
        self._context = context
        self._cwd = self._vim.call('getcwd')
        self.cd(cwd)

        self._source: Source = (SourceList(self._vim)
                                if source_name == 'file/list'
                                else SourceFile(self._vim))
        self._index = index
        self._enabled_ignored_files = not context.show_ignored_files
        self._filtered_files = context.filtered_files.split(',')
        self._ignored_files = context.ignored_files.split(',')
        self._cursor_history: typing.Dict[str, Path] = {}
        self._sort_method: str = self._context.sort
        self._mtime: int = -1
        self._opened_candidates: typing.Set[str] = set()
        self._selected_candidates: typing.Set[str] = set()
        self._nested_candidates: typing.Set[str] = set()

        self._init_source()

    def _init_source(self) -> None:
        custom = self._vim.call('defx#custom#_get')['source']
        name = self._source.name
        if name in custom:
            self._source.vars.update(custom[name])

    def debug(self, expr: typing.Any) -> None:
        error(self._vim, expr)

    def cd(self, path: str) -> None:
        self._cwd = str(Path(self._cwd).joinpath(path))

        if self._context.auto_cd and Path(path).is_dir():
            cd(self._vim, path)

    def get_root_candidate(self) -> Candidate:
        """
        Returns root candidate
        """
        if not self._source:
            return {}

        root = self._source.get_root_candidate(self._context, Path(self._cwd))
        root['is_root'] = True
        root['is_opened_tree'] = False
        root['is_selected'] = False
        root['level'] = 0
        root['root_marker'] = self._context.root_marker + (
            self._source.name + ':' if self._source.name != 'file' else '')
        root['word'] = root['root_marker'] + root['word']

        return root

    def tree_candidates(
            self, path: str, base_level: int, max_level: int
    ) -> typing.List[Candidate]:
        gathered_candidates = self.gather_candidates_recursive(
            path, base_level, max_level)

        if not self._opened_candidates and not self._nested_candidates:
            return gathered_candidates

        candidates = []
        for candidate in gathered_candidates:
            candidates.append(candidate)
            candidate['level'] = base_level
            candidate_path = str(candidate['action__path'])

            if not candidate['is_directory']:
                continue
            if (candidate_path not in self._opened_candidates and
                    candidate_path not in self._nested_candidates):
                continue

            children = self.tree_candidates(
                candidate_path, base_level + 1, max_level)

            candidate['is_opened_tree'] = True
            candidates += children
        return candidates

    def gather_candidates_recursive(
            self, path: str, base_level: int, max_level: int
    ) -> typing.List[Candidate]:

        candidates = self._gather_candidates(path, base_level)
        if base_level >= max_level:
            return candidates

        ret = []
        for candidate in candidates:
            ret.append(candidate)
            if candidate['is_directory']:
                candidate['is_opened_tree'] = True
                ret += self.gather_candidates_recursive(
                    str(candidate['action__path']), base_level + 1, max_level)
        return ret

    def _gather_candidates(
            self, path: str, base_level: int = 0) -> typing.List[Candidate]:
        """
        Returns file candidates
        """
        if not self._source:
            return []

        candidates = self._source.gather_candidates(
            self._context, Path(path))

        if self._filtered_files != ['']:
            new_candidates = []
            for candidate in candidates:
                matched = False
                for glob in self._filtered_files:
                    if candidate['action__path'].match(glob):
                        matched = True
                        break
                if matched or candidate['is_directory']:
                    new_candidates.append(candidate)
            candidates = new_candidates

        if self._enabled_ignored_files:
            for glob in self._ignored_files:
                candidates = [x for x in candidates
                              if not x['action__path'].match(glob)]

        for candidate in candidates:
            candidate['is_opened_tree'] = False
            candidate['is_root'] = False
            candidate['is_selected'] = False
            candidate['level'] = base_level

        return sort(self._sort_method, candidates)
