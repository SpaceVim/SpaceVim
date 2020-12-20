# ============================================================================
# FILE: file.py
# AUTHOR: Felipe Morales <hel.sheep at gmail.com>
#         Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

import os
import re
import typing
from os.path import exists, dirname

from deoplete.base.source import Base
from deoplete.util import expand, Nvim, UserContext, Candidates


class Source(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'file'
        self.mark = '[F]'
        self.min_pattern_length = 0
        self.rank = 150
        self.events: typing.List[str] = ['InsertEnter']
        self.vars = {
            'enable_buffer_path': True,
            'force_completion_length': -1,
        }

        self._isfname = ''

    def on_event(self, context: UserContext) -> None:
        self._isfname = self.vim.call(
            'deoplete#util#vimoption2python_not',
            self.vim.options['isfname'])

    def get_complete_position(self, context: UserContext) -> int:
        pos = int(context['input'].rfind('/'))
        force_completion_length = int(
            self.get_var('force_completion_length'))  # type: ignore
        if pos < 0 and force_completion_length >= 0:
            fmt = '[a-zA-Z0-9.-]{{{}}}$'.format(force_completion_length)
            m = re.search(fmt, context['input'])
            if m:
                return m.start()
        return pos if pos < 0 else pos + 1

    def gather_candidates(self, context: UserContext) -> Candidates:
        if not self._isfname:
            self.on_event(context)

        input_str = (context['input']
                     if context['input'].rfind('/') >= 0
                     else './')

        p = self._longest_path_that_exists(context, input_str)
        if not p or p == '/' or re.search('//+$', p):
            return []
        complete_str = self._substitute_path(context, dirname(p) + '/')
        if not os.path.isdir(complete_str):
            return []
        hidden = context['complete_str'].find('.') == 0
        contents: typing.List[typing.Any] = [[], []]
        try:
            for item in sorted(os.listdir(complete_str), key=str.lower):
                if not hidden and item[0] == '.':
                    continue
                contents[not os.path.isdir(complete_str + item)].append(item)
        except PermissionError:
            pass

        dirs, files = contents
        return [{'word': x, 'abbr': x + '/'} for x in dirs
                ] + [{'word': x} for x in files]

    def _longest_path_that_exists(self, context: UserContext,
                                  input_str: str) -> str:
        input_str = re.sub(r'[^/]*$', '', input_str)
        data = re.split(r'((?:%s+|(?:(?<![\w\s/\.])(?:~|\.{1,2})?/)+))' %
                        self._isfname, input_str)
        data = [''.join(data[i:]) for i in range(len(data))]
        existing_paths = sorted(filter(lambda x: exists(
            dirname(self._substitute_path(context, x))), data))
        return existing_paths[-1] if existing_paths else ''

    def _substitute_path(self, context: UserContext, path: str) -> str:
        m = re.match(r'(\.{1,2})/+', path)
        if m:
            if self.get_var('enable_buffer_path') and context['bufpath']:
                base = context['bufpath']
            else:
                base = os.path.join(context['cwd'], 'x')

            for _ in m.group(1):
                base = dirname(base)
            return os.path.abspath(os.path.join(
                base, path[len(m.group(0)):])) + '/'
        return expand(path)
