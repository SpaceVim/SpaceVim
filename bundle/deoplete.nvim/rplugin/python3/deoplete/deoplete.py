# ============================================================================
# FILE: deoplete.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

import copy
import glob
import os
import typing

import deoplete.parent
from deoplete import logger
from deoplete.context import Context
from deoplete.util import error, error_tb, Nvim

UserContext = typing.Dict[str, typing.Any]
Candidates = typing.Dict[str, typing.Any]
Parent = typing.Union[deoplete.parent.SyncParent, deoplete.parent.AsyncParent]


class Deoplete(logger.LoggingMixin):

    def __init__(self, vim: Nvim):
        self.name = 'core'

        self._vim = vim
        self._runtimepath = ''
        self._runtimepath_list: typing.List[str] = []
        self._custom: typing.Dict[str, typing.Dict[str, typing.Any]] = {}
        self._loaded_paths: typing.Set[str] = set()
        self._prev_results: typing.Dict[int, Candidates] = {}
        self._prev_input = ''
        self._prev_next_input = ''
        self._context: typing.Optional[Context] = None
        self._parents: typing.List[Parent] = []
        self._parent_count = 0
        self._max_parents = self._vim.call('deoplete#custom#_get_option',
                                           'num_processes')

        if self._max_parents != 1 and not hasattr(self._vim, 'loop'):
            msg = ('pynvim 0.3.0+ is required for %d parents. '
                   'Using single process.' % self._max_parents)
            error(self._vim, msg)
            self._max_parents = 1

        # Enable logging for more information, and e.g.
        # deoplete-jedi picks up the log filename from deoplete's handler in
        # its on_init.
        if self._vim.vars['deoplete#_logging']:
            self.enable_logging()

        if hasattr(self._vim, 'channel_id'):
            self._vim.vars['deoplete#_channel_id'] = self._vim.channel_id
        self._vim.vars['deoplete#_initialized'] = True

    def enable_logging(self) -> None:
        logging = self._vim.vars['deoplete#_logging']
        logger.setup(self._vim, logging['level'], logging['logfile'])
        self.is_debug_enabled = True

    def init_context(self) -> None:
        self._context = Context(self._vim)

        # Initialization
        context = self._context.get('Init')
        context['rpc'] = 'deoplete_on_event'
        self.on_event(context)

    def completion_begin(self, user_context: UserContext) -> None:
        if not self._context:
            self.init_context()

        context = self._context.get(user_context['event'])  # type: ignore
        context.update(user_context)

        self.debug('completion_begin (%s): %r',  # type: ignore
                   context['event'], context['input'])

        if self._vim.call('deoplete#handler#_check_omnifunc', context):
            return

        self._check_recache(context)

        try:
            (is_async, needs_poll,
             position, candidates) = self._merge_results(context)
        except Exception:
            error_tb(self._vim, 'Error while gathering completions')

            is_async = False
            needs_poll = False
            position = -1
            candidates = []

        if needs_poll:
            self._vim.call('deoplete#handler#_async_timer_start')

        if not candidates:
            self._vim.call('deoplete#mapping#_restore_completeopt')

        # Async update is skipped if same.
        prev_completion = self._vim.vars['deoplete#_prev_completion']
        prev_candidates = prev_completion['candidates']
        event = context['event']
        if (event == 'Async' or event == 'Update' and
                prev_candidates and candidates == prev_candidates):
            return

        # error(self._vim, candidates)
        self._vim.vars['deoplete#_context'] = {
            'complete_position': position,
            'candidates': candidates,
            'event': context['event'],
            'input': context['input'],
            'is_async': is_async,
        }

        if candidates or self._vim.call('deoplete#util#check_popup'):
            self.debug('do_complete (%s): '  # type: ignore
                       + '%d candidates, input=%s, complete_position=%d, '
                       + 'is_async=%d',
                       context['event'],
                       len(candidates), context['input'], position,
                       is_async)
            self._vim.call('deoplete#handler#_do_complete')

    def on_event(self, user_context: UserContext) -> None:
        self._vim.call('deoplete#custom#_update_cache')

        if not self._context:
            self.init_context()
        else:
            self._context._init_cached()

        context = self._context.get(user_context['event'])  # type: ignore
        context.update(user_context)

        self.debug('initialized context: %s', context)  # type: ignore

        self.debug('on_event: %s', context['event'])  # type: ignore

        self._check_recache(context)

        for parent in self._parents:
            parent.on_event(context)

    def _get_results(self, context: UserContext) -> typing.List[typing.Any]:
        is_async = False
        needs_poll = False
        results: typing.List[Candidates] = []
        for cnt, parent in enumerate(self._parents):
            if cnt in self._prev_results:
                # Use previous result
                results += copy.deepcopy(
                    self._prev_results[cnt])  # type: ignore
            else:
                result = parent.merge_results(context)
                is_async = is_async or result[0]
                needs_poll = needs_poll or result[1]
                if not result[0]:
                    self._prev_results[cnt] = result[2]
                results += result[2]
        return [is_async, needs_poll, results]

    def _merge_results(self, context: UserContext) -> typing.Tuple[
            bool, bool, int, typing.List[typing.Any]]:
        use_prev = (context['input'] == self._prev_input
                    and context['next_input'] == self._prev_next_input
                    and context['event'] != 'Manual')
        if not use_prev:
            self._prev_results = {}

        self._prev_input = context['input']
        self._prev_next_input = context['next_input']

        [is_async, needs_poll, results] = self._get_results(context)

        if not results:
            return (is_async, needs_poll, -1, [])

        complete_position = min(x['complete_position'] for x in results)

        all_candidates: typing.List[Candidates] = []
        for result in sorted(results, key=lambda x: x['rank'], reverse=True):
            candidates = result['candidates']
            prefix = context['input'][
                complete_position:result['complete_position']]

            if prefix != '':
                for candidate in candidates:
                    # Add prefix
                    candidate['word'] = prefix + candidate['word']

            all_candidates += candidates

        # self.debug(candidates)
        max_list = self._vim.call(
            'deoplete#custom#_get_option', 'max_list')
        if max_list > 0:
            all_candidates = all_candidates[: max_list]

        candidate_marks = self._vim.call(
            'deoplete#custom#_get_option', 'candidate_marks')
        if candidate_marks:
            all_candidates = copy.deepcopy(all_candidates)
            for i, candidate in enumerate(all_candidates):
                mark = (candidate_marks[i] if i < len(candidate_marks) and
                        candidate_marks[i] else ' ')
                candidate['menu'] = mark + ' ' + candidate.get('menu', '')

        return (is_async, needs_poll, complete_position, all_candidates)

    def _add_parent(self, parent_cls: typing.Callable[
            [Nvim], Parent]) -> None:
        parent = parent_cls(self._vim)
        if self._vim.vars['deoplete#_logging']:
            parent.enable_logging()
        self._parents.append(parent)

    def _find_rplugins(self,
                       source: str) -> typing.Generator[str, None, None]:
        """Search for base.py or *.py

        Searches $VIMRUNTIME/*/rplugin/python3/deoplete/$source[s]/
        """
        if not self._runtimepath_list:
            return

        sources = (
            os.path.join('rplugin', 'python3', 'deoplete',
                         source, '*.py'),
            os.path.join('rplugin', 'python3', 'deoplete',
                         source + 's', '*.py'),
            os.path.join('rplugin', 'python3', 'deoplete',
                         source, '*', '*.py'),
        )

        for src in sources:
            for path in self._runtimepath_list:
                yield from glob.iglob(os.path.join(path, src))

    def _load_sources(self, context: UserContext) -> None:
        if not self._parents and self._max_parents == 1:
            self._add_parent(deoplete.parent.SyncParent)

        for path in self._find_rplugins('source'):
            if (path in self._loaded_paths
                    or os.path.basename(path) == 'base.py'):
                continue
            self._loaded_paths.add(path)

            if len(self._parents) <= self._parent_count:
                # Add parent automatically
                self._add_parent(deoplete.parent.AsyncParent)

            self._parents[self._parent_count].add_source(path)
            self.debug(  # type: ignore
                f'Process {self._parent_count}: {path}')

            self._parent_count += 1
            if self._max_parents > 0:
                self._parent_count %= self._max_parents

        self._set_source_attributes(context)

    def _load_filters(self, context: UserContext) -> None:
        for path in self._find_rplugins('filter'):
            for parent in self._parents:
                parent.add_filter(path)

    def _set_source_attributes(self, context: UserContext) -> None:
        for parent in self._parents:
            parent.set_source_attributes(context)

    def _check_recache(self, context: UserContext) -> None:
        runtimepath = self._vim.options['runtimepath']
        if runtimepath != self._runtimepath:
            self._runtimepath = runtimepath
            self._runtimepath_list = runtimepath.split(',')
            self._load_sources(context)
            self._load_filters(context)

            if context['rpc'] != 'deoplete_on_event':
                self.on_event(context)
        elif context['custom'] != self._custom:
            self._set_source_attributes(context)
            self._custom = context['custom']
