# ============================================================================
# FILE: session.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

import typing


class Session(typing.NamedTuple):
    name: str = ''
    path: str = ''
    opened_candidates: typing.List[str] = []
