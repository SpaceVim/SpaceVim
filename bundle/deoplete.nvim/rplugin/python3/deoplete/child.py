# ============================================================================
# FILE: child.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

import copy
import os.path
import re
import sys
import time
import msgpack
import typing

from collections import defaultdict

from deoplete import logger
from deoplete.exceptions import SourceInitError
from deoplete.util import (bytepos2charpos, charpos2bytepos, error, error_tb,
                           import_plugin, get_custom, get_syn_names,
                           convert2candidates, uniq_list_dict, Nvim)

UserContext = typing.Dict[str, typing.Any]
Candidates = typing.Dict[str, typing.Any]
Result = typing.Dict[str, typing.Any]


class Child(logger.LoggingMixin):

    def __init__(self, vim: Nvim) -> None:
        self.name = 'child'

        self._vim = vim
        self._filters: typing.Dict[str, typing.Any] = {}
        self._sources: typing.Dict[str, typing.Any] = {}
        self._profile_flag = None
        self._profile_start_time = 0
        self._loaded_sources: typing.Dict[str, typing.Any] = {}
        self._loaded_filters: typing.Dict[str, typing.Any] = {}
        self._source_errors: typing.Dict[str, int] = defaultdict(int)
        self._prev_results: typing.Dict[str, Result] = {}
        if msgpack.version < (1, 0, 0):
            self._packer = msgpack.Packer(
                encoding='utf-8',
                unicode_errors='surrogateescape')
            self._unpacker = msgpack.Unpacker(
                encoding='utf-8',
                unicode_errors='surrogateescape')
        else:
            self._unpacker = msgpack.Unpacker(
                unicode_errors='surrogateescape')
            self._packer = msgpack.Packer(
                unicode_errors='surrogateescape')
        self._ignore_sources: typing.List[typing.Any] = []

    def main_loop(self, stdout: typing.Any) -> None:
        while True:
            feed = sys.stdin.buffer.raw.read(102400)  # type: ignore
            if feed is None:
                continue
            if feed == b'':
                # EOF
                return

            self._unpacker.feed(feed)

            for child_in in self._unpacker:
                name = child_in['name']
                args = child_in['args']
                queue_id = child_in['queue_id']

                ret = self.main(name, args, queue_id)
                if ret:
                    self._write(stdout, ret)
                    self._vim.call('deoplete#auto_complete', 'Update')

    def main(self, name: str, args: typing.List[typing.Any],
             queue_id: typing.Optional[int]) -> typing.Optional[Candidates]:
        ret = None
        if name == 'enable_logging':
            self._enable_logging()
        elif name == 'add_source':
            self._add_source(args[0])
        elif name == 'add_filter':
            self._add_filter(args[0])
        elif name == 'set_source_attributes':
            self._set_source_attributes(args[0])
        elif name == 'on_event':
            self._on_event(args[0])
        elif name == 'merge_results':
            results = self._merge_results(args[0], queue_id)
            if results['is_async'] or results['merged_results']:
                ret = results
        return ret

    def _write(self, stdout: typing.Any, expr: typing.Any) -> None:
        stdout.buffer.write(self._packer.pack(expr))
        stdout.flush()

    def _enable_logging(self) -> None:
        logging = self._vim.vars['deoplete#_logging']
        logger.setup(self._vim, logging['level'], logging['logfile'])
        self.is_debug_enabled = True

    def _add_source(self, path: str) -> None:
        source = None
        try:
            Source = import_plugin(path, 'source', 'Source')
            if not Source:
                return

            source = Source(self._vim)
            name = os.path.splitext(os.path.basename(path))[0]
            source.name = getattr(source, 'name', name)
            source.path = path
            if source.name in self._loaded_sources:
                # Duplicated name
                error_tb(self._vim, 'Duplicated source: %s' % source.name)
                error_tb(self._vim, 'path: "%s" "%s"' %
                         (path, self._loaded_sources[source.name]))
                source = None
        except Exception:
            error_tb(self._vim, 'Could not load source: %s' % path)
        finally:
            if source:
                self._loaded_sources[source.name] = path
                self._sources[source.name] = source
                self.debug(  # type: ignore
                    f'Loaded Source: {source.name} ({path})')

    def _add_filter(self, path: str) -> None:
        f = None
        try:
            Filter = import_plugin(path, 'filter', 'Filter')
            if not Filter:
                return

            f = Filter(self._vim)
            name = os.path.splitext(os.path.basename(path))[0]
            f.name = getattr(f, 'name', name)
            f.path = path
            if f.name in self._loaded_filters:
                # Duplicated name
                error_tb(self._vim, 'Duplicated filter: %s' % f.name)
                error_tb(self._vim, 'path: "%s" "%s"' %
                         (path, self._loaded_filters[f.name]))
                f = None
        except Exception:
            # Exception occurred when loading a filter.  Log stack trace.
            error_tb(self._vim, 'Could not load filter: %s' % path)
        finally:
            if f:
                self._loaded_filters[f.name] = path
                self._filters[f.name] = f
                self.debug(  # type: ignore
                    f'Loaded Filter: {f.name} ({path})')

    def _merge_results(self, context: UserContext,
                       queue_id: typing.Optional[int]) -> typing.Dict[
                           str, typing.Any]:
        results = self._gather_results(context)

        merged_results = []
        for result in [x for x in results
                       if not self._is_skip(x['context'], x['source'])]:
            candidates = self._get_candidates(
                result, context['input'], context['next_input'])
            if candidates:
                rank = get_custom(context['custom'],
                                  result['source'].name, 'rank',
                                  result['source'].rank)
                merged_results.append({
                    'complete_position': result['complete_position'],
                    'candidates': candidates,
                    'rank': rank,
                })

        is_async = len([x for x in results if x['is_async']]) > 0

        return {
            'queue_id': queue_id,
            'is_async': is_async,
            'merged_results': merged_results,
        }

    def _gather_results(self, context: UserContext) -> typing.List[Result]:
        # Note: self._vim.current.buffer may not work when Vim quit
        if context['changedtick'] != self._vim.eval('b:changedtick'):
            return []
        results = []

        for source in [x[1] for x in self._itersource(context)]:
            try:
                result = self._get_result(context, source)
                if not result:
                    continue
                self._prev_results[source.name] = result
                results.append(result)
            except Exception as exc:
                self._handle_source_exception(source, exc)

        return results

    def _get_result(self, context: UserContext,
                    source: typing.Any) -> Result:
        if source.disabled_syntaxes and 'syntax_names' not in context:
            context['syntax_names'] = get_syn_names(self._vim)

        ctx = copy.deepcopy(context)

        charpos = source.get_complete_position(ctx)
        if charpos >= 0 and source.is_bytepos:
            charpos = bytepos2charpos(
                ctx['encoding'], ctx['input'], charpos)

        ctx['char_position'] = charpos
        ctx['complete_position'] = charpos2bytepos(
            ctx['encoding'], ctx['input'], charpos)
        ctx['complete_str'] = ctx['input'][ctx['char_position']:]

        if charpos < 0 or self._is_skip(ctx, source):
            if source.name in self._prev_results:
                self._prev_results.pop(source.name)
            # Skip
            return {}

        if (source.name in self._prev_results and
                self._use_previous_result(
                    context, self._prev_results[source.name],
                    source.is_volatile, source.is_async)):
            return self._prev_results[source.name]

        ctx['is_async'] = False
        ctx['is_refresh'] = True
        ctx['max_abbr_width'] = min(source.max_abbr_width,
                                    ctx['max_abbr_width'])
        ctx['max_kind_width'] = min(source.max_kind_width,
                                    ctx['max_kind_width'])
        ctx['max_info_width'] = source.max_info_width
        ctx['max_menu_width'] = min(source.max_menu_width,
                                    ctx['max_menu_width'])
        if ctx['max_abbr_width'] > 0:
            ctx['max_abbr_width'] = max(20, ctx['max_abbr_width'])
        if ctx['max_kind_width'] > 0:
            ctx['max_kind_width'] = max(10, ctx['max_kind_width'])
        if ctx['max_info_width'] > 0:
            ctx['max_info_width'] = max(10, ctx['max_info_width'])
        if ctx['max_menu_width'] > 0:
            ctx['max_menu_width'] = max(10, ctx['max_menu_width'])

        # Gathering
        self._profile_start(ctx, source.name)
        ctx['vars'] = self._vim.vars
        ctx['candidates'] = source.gather_candidates(ctx)
        if ctx['is_async']:
            source.is_async = True
        ctx['vars'] = None
        self._profile_end(source.name)

        if ctx['candidates'] is None:
            return {}

        ctx['candidates'] = convert2candidates(ctx['candidates'])

        return {
            'name': source.name,
            'source': source,
            'context': ctx,
            'is_async': ctx['is_async'],
            'prev_linenr': ctx['position'][1],
            'prev_input': ctx['input'],
            'input': ctx['input'],
            'complete_position': ctx['complete_position'],
            'candidates': ctx['candidates'],
        }

    def _gather_async_results(self, result: Result,
                              source: typing.Any) -> None:
        try:
            context = result['context']
            context['is_refresh'] = False
            context['vars'] = self._vim.vars
            async_candidates = source.gather_candidates(context)
            context['vars'] = None
            result['is_async'] = context['is_async']
            if async_candidates is None:
                return
            context['candidates'] += convert2candidates(async_candidates)
        except Exception as exc:
            self._handle_source_exception(source, exc)

    def _handle_source_exception(self,
                                 source: typing.Any, exc: Exception) -> None:
        if isinstance(exc, SourceInitError):
            error(self._vim,
                  f'Error when loading source {source.name}: {exc}. '
                  'Ignoring.')
            self._ignore_sources.append(source.name)
            return

        self._source_errors[source.name] += 1
        if source.is_silent:
            return
        if self._source_errors[source.name] > 2:
            error(self._vim,
                  f'Too many errors from "{source.name}". '
                  'This source is disabled until Neovim is restarted.')
            self._ignore_sources.append(source.name)
        else:
            error_tb(self._vim, f'Error from {source.name}: {exc}')

    def _process_filter(self, f: typing.Any,
                        context: UserContext, max_candidates: int) -> None:
        try:
            self._profile_start(context, f.name)
            if (isinstance(context['candidates'], dict) and
                    'sorted_candidates' in context['candidates']):
                filtered: typing.List[typing.Any] = []
                context['is_sorted'] = True
                for candidates in context['candidates']['sorted_candidates']:
                    context['candidates'] = candidates
                    filtered += f.filter(context)
            else:
                filtered = f.filter(context)
            if max_candidates > 0:
                filtered = filtered[: max_candidates]
            context['candidates'] = filtered
            self._profile_end(f.name)
        except Exception:
            error_tb(self._vim, 'Errors from: %s' % f)

    def _get_candidates(self, result: Result,
                        context_input: str, next_input: str
                        ) -> typing.Optional[Candidates]:
        source = result['source']

        # Gather async results
        if result['is_async']:
            self._gather_async_results(result, source)

        if not result['candidates']:
            return None

        # Source context
        ctx = copy.copy(result['context'])

        ctx['input'] = context_input
        ctx['next_input'] = next_input
        ctx['complete_str'] = context_input[ctx['char_position']:]
        ctx['is_sorted'] = False

        # Set ignorecase
        case = ctx['smartcase'] or ctx['camelcase']
        if case:
            if re.search(r'[A-Z]', ctx['complete_str']):
                ctx['ignorecase'] = False
            else:
                ctx['ignorecase'] = True
        ignorecase = ctx['ignorecase']

        # Match
        matchers = [self._filters[x] for x
                    in source.matchers if x in self._filters]
        if source.matcher_key != '':
            original_candidates = ctx['candidates']
            # Convert word key to matcher_key
            for candidate in original_candidates:
                candidate['__save_word'] = candidate['word']
                candidate['word'] = candidate[source.matcher_key]
        for f in matchers:
            self._process_filter(f, ctx, source.max_candidates)
        if source.matcher_key != '':
            # Restore word key
            for candidate in original_candidates:
                candidate['word'] = candidate['__save_word']
                del candidate['__save_word']

        # Sort
        sorters = [self._filters[x] for x
                   in source.sorters if x in self._filters]
        for f in sorters:
            self._process_filter(f, ctx, source.max_candidates)

        # Note: converter may break candidates
        ctx['candidates'] = copy.deepcopy(ctx['candidates'])

        # Convert
        converters = [self._filters[x] for x
                      in source.converters if x in self._filters]
        for f in converters:
            self._process_filter(f, ctx, source.max_candidates)

        if (isinstance(ctx['candidates'], dict) and
                'sorted_candidates' in ctx['candidates']):
            sorted_candidates = ctx['candidates']['sorted_candidates']
            ctx['candidates'] = []
            for candidates in sorted_candidates:
                ctx['candidates'] += candidates

        ctx['ignorecase'] = ignorecase

        # On post filter
        if hasattr(source, 'on_post_filter'):
            ctx['candidates'] = source.on_post_filter(ctx)

        mark = source.mark + ' '

        refresh = False
        refresh_always = self._vim.call(
            'deoplete#custom#_get_option', 'refresh_always')
        auto_complete = self._vim.call(
            'deoplete#custom#_get_option', 'auto_complete')
        eskk_check = self._vim.call(
            'deoplete#util#check_eskk_phase_henkan')
        if refresh_always and auto_complete and not eskk_check:
            refresh = True

        for candidate in ctx['candidates']:
            candidate['icase'] = 1
            candidate['equal'] = refresh

            # Set default menu
            if (mark != ' ' and
                    candidate.get('menu', '').find(mark) != 0):
                candidate['menu'] = mark + candidate.get('menu', '')

            if source.dup:
                candidate['dup'] = 1
        # Note: cannot use set() for dict
        if source.dup:
            # Remove duplicates
            ctx['candidates'] = uniq_list_dict(ctx['candidates'])

        return ctx['candidates']  # type: ignore

    def _itersource(self, context: UserContext
                    ) -> typing.Generator[typing.Any, None, None]:
        filetypes = context['filetypes']
        ignore_sources = set(self._ignore_sources)
        for ft in filetypes:
            ignore_sources.update(
                self._vim.call('deoplete#custom#_get_filetype_option',
                               'ignore_sources', ft, []))

        for source_name, source in self._get_sources().items():
            if source.filetypes is None or source_name in ignore_sources:
                continue
            if context['sources'] and source_name not in context['sources']:
                continue
            if source.filetypes and not any(x in filetypes
                                            for x in source.filetypes):
                continue
            if not source.is_initialized and hasattr(source, 'on_init'):
                self.debug('on_init Source: ' + source.name)  # type: ignore
                try:
                    context['vars'] = self._vim.vars
                    source.on_init(context)
                    context['vars'] = None
                except Exception as exc:
                    if isinstance(exc, SourceInitError):
                        error(self._vim, 'Error when loading source '
                              f'{source_name}: {exc}. Ignoring.')
                    else:
                        error_tb(self._vim, 'Error when loading source '
                                 f'{source_name}: {exc}. Ignoring.')
                    self._ignore_sources.append(source_name)
                    continue
                else:
                    source.is_initialized = True
            yield source_name, source

    def _profile_start(self, context: UserContext, name: str) -> None:
        if self._profile_flag == 0 or not self.is_debug_enabled:
            return

        if not self._profile_flag:
            self._profile_flag = self._vim.call(
                'deoplete#custom#_get_option', 'profile')
            if self._profile_flag:
                return self._profile_start(context, name)
        elif self._profile_flag:
            self.debug(f'Profile Start: {name}')
            self._profile_start_time = time.monotonic()

    def _profile_end(self, name: str) -> None:
        if not self._profile_start_time:
            return

        self.debug(  # type: ignore
            'Profile End  : {0:<25} time={1:2.10f}'.format(
                name, time.monotonic() - self._profile_start_time))

    def _use_previous_result(self, context: UserContext,
                             result: Result, is_volatile: bool,
                             is_async: bool) -> bool:
        if context['position'][1] != result['prev_linenr']:
            return False
        elif is_async:
            # Note: If it is async, the cache must be used to call
            # gather_async_results().
            return bool(context['input'] == result['prev_input'])
        elif is_volatile:
            # Note: If it is volatile, the cache must be disabled to refresh
            # candidates.
            return False
        else:
            return bool(re.sub(r'\w*$', '', context['input']) ==
                        re.sub(r'\w*$', '', result['prev_input']) and
                        context['input'].find(result['prev_input']) == 0)

    def _is_skip(self, context: UserContext, source: typing.Any) -> bool:
        if 'syntax_names' in context and source.disabled_syntaxes:
            p = re.compile('(' + '|'.join(source.disabled_syntaxes) + ')$')
            if next(filter(p.search, context['syntax_names']), None):
                return True

        iminsert = self._vim.call('getbufvar', '%', '&iminsert')
        if iminsert == 1 and source.is_skip_langmap:
            return True

        for ft in context['filetypes']:
            input_pattern = source.get_input_pattern(ft)
            if (input_pattern != '' and
                    re.search('(' + input_pattern + ')$', context['input'])):
                return False
        auto_complete_popup = self._vim.call(
            'deoplete#custom#_get_option', 'auto_complete_popup')
        if context['event'] == 'Manual' or auto_complete_popup == 'manual':
            return False
        return not (source.min_pattern_length <=
                    len(context['complete_str']) <= source.max_pattern_length)

    def _set_source_attributes(self, context: UserContext) -> None:
        """Set source attributes from the context.

        Each item in `attrs` is the attribute name.
        """
        attrs = (
            'converters',
            'disabled_syntaxes',
            'dup',
            'filetypes',
            'input_pattern',
            'is_debug_enabled',
            'is_silent',
            'is_volatile',
            'mark',
            'matchers',
            'max_abbr_width',
            'max_candidates',
            'max_info_width',
            'max_kind_width',
            'max_menu_width',
            'max_pattern_length',
            'min_pattern_length',
            'sorters',
        )

        for name, source in self._get_sources().items():
            self.debug('Set Source attributes: %s', name)  # type: ignore

            source.dup = bool(source.filetypes)

            for attr in attrs:
                source_attr = getattr(source, attr, None)
                custom = get_custom(context['custom'],
                                    name, attr, source_attr)
                if type(getattr(source, attr)) != type(custom):
                    # Type check
                    error(self._vim, f'source {source.name}: '
                          f'custom attr "{attr}" is wrong type.')
                elif custom and isinstance(source_attr, dict):
                    # Update values if it is dict
                    source_attr.update(custom)
                else:
                    setattr(source, attr, custom)

                self.debug('Attribute: %s (%s)',  # type: ignore
                           attr, getattr(source, attr))

            # Default min_pattern_length
            if source.min_pattern_length < 0:
                source.min_pattern_length = self._vim.call(
                    'deoplete#custom#_get_option', 'min_pattern_length')

    def _on_event(self, context: UserContext) -> None:
        event = context['event']
        context['vars'] = self._vim.vars
        for source_name, source in self._itersource(context):
            if not source.events or event in source.events:
                try:
                    source.on_event(context)
                except Exception as exc:
                    error_tb(self._vim,
                             f'Exception during {source.name}.on_event '
                             'for event {!r}: {}'.format(event, exc))

        for f in self._filters.values():
            f.on_event(context)
        context['vars'] = None

    def _get_sources(self) -> typing.Dict[str, typing.Any]:
        # Note: for the size change of "self._sources" error
        return copy.copy(self._sources)
