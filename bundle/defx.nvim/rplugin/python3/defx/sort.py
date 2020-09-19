# ============================================================================
# FILE: sort.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

import re
import typing

from defx.util import readable


def sort(
        method: str, candidates: typing.List[typing.Dict[str, typing.Any]]
) -> typing.List[typing.Dict[str, typing.Any]]:
    dirs = _sort_method(
        method, [x for x in candidates if x['is_directory']])
    files = _sort_method(
        method, [x for x in candidates if not x['is_directory']])
    return dirs + files


def _sort_method(
        method: str, candidates: typing.List[typing.Dict[str, typing.Any]]
) -> typing.List[typing.Dict[str, typing.Any]]:
    key = method.lower()
    if key not in SORT_METHODS:
        return candidates

    candidates = SORT_METHODS[key](candidates)
    if re.match(r'[A-Z]', method):
        candidates = list(reversed(candidates))
    return candidates


def _extension(
        candidates: typing.List[typing.Dict[str, typing.Any]]
) -> typing.List[typing.Dict[str, typing.Any]]:
    return sorted(candidates, key=lambda x: x['action__path'].suffix)


def _filename(
        candidates: typing.List[typing.Dict[str, typing.Any]]
) -> typing.List[typing.Dict[str, typing.Any]]:

    def numeric_key(v: str) -> typing.List[typing.Any]:
        keys = re.split(r'(\d+)', v)
        keys[1::2] = [int(x) for x in keys[1::2]]  # type: ignore
        return keys

    return sorted(candidates, key=lambda x: numeric_key(x['word'].lower()))


def _size(
        candidates: typing.List[typing.Dict[str, typing.Any]]
) -> typing.List[typing.Dict[str, typing.Any]]:
    return sorted(candidates, key=(lambda x:
                                   x['action__path'].stat().st_size
                                   if readable(x['action__path']) else -1))


def _time(
        candidates: typing.List[typing.Dict[str, typing.Any]]
) -> typing.List[typing.Dict[str, typing.Any]]:
    return sorted(candidates, key=(lambda x:
                                   x['action__path'].stat().st_mtime
                                   if readable(x['action__path']) else 0))


SORT_METHODS = {
    'extension': _extension,
    'filename': _filename,
    'size': _size,
    'time': _time,
}
