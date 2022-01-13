# ============================================================================
# FILE: context.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

import typing


class Context(typing.NamedTuple):
    args: typing.List[str] = []
    auto_cd: bool = False
    auto_recursive_level: int = 0
    buffer_name: str = 'default'
    close: bool = False
    columns: str = ''
    cursor: int = 0
    direction: str = ''
    drives: typing.List[str] = []
    filtered_files: str = ''
    focus: bool = False
    floating_preview: bool = False
    ignored_files: str = ''
    listed: bool = False
    new: bool = False
    prev_bufnr: int = 0
    prev_last_bufnr: int = 0
    prev_winid: int = 0
    preview_height: int = 0
    preview_width: int = 0
    profile: bool = False
    resume: bool = False
    root_marker: str = ''
    search: str = ''
    session_file: str = ''
    show_ignored_files: bool = False
    sort: str = ''
    split: str = 'no'
    targets: typing.List[typing.Dict[str, typing.Any]] = []
    toggle: bool = False
    variable_length: int = 0
    visual_end: int = 0
    visual_start: int = 0
    with_highlights: bool = True
    wincol: int = 0
    winheight: int = 0
    winrelative: str = 'editor'
    winrow: int = 0
    winwidth: int = 0
    vertical_preview: bool = False
