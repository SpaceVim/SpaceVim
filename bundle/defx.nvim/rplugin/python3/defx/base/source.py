# ============================================================================
# FILE: source.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

import typing

from abc import ABC, abstractmethod
from defx.context import Context
from defx.util import Nvim
from defx.util import error
from pathlib import Path


class Base(ABC):

    def __init__(self, vim: Nvim) -> None:
        self.vim = vim
        self.name = 'base'

        from defx.base.kind import Base as Kind
        self.kind: Kind = Kind(self.vim)

        self.vars: typing.Dict[str, typing.Any] = {}

    @abstractmethod
    def get_root_candidate(
            self, context: Context, path: Path
    ) -> typing.Dict[str, typing.Any]:
        pass

    @abstractmethod
    def gather_candidates(
            self, context: Context, path: Path
    ) -> typing.List[typing.Dict[str, typing.Any]]:
        pass

    def debug(self, expr: typing.Any) -> None:
        error(self.vim, expr)
