# ============================================================================
# FILE: base.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

# For backward compatibility
from deoplete.base.source import Base as _Base
from deoplete.util import Nvim


class Base(_Base):
    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)
