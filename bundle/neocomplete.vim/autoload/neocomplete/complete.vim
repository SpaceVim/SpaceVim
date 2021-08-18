"=============================================================================
" FILE: complete.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! neocomplete#complete#_get_results(cur_text, ...) abort "{{{
  call neocomplete#print_debug('start get_complete_sources')

  let neocomplete = neocomplete#get_current_neocomplete()
  let neocomplete.start_time = reltime()

  " Comment check.
  let neocomplete.within_comment =
        \ neocomplete#helper#get_syn_name(1) ==# 'Comment'

  let complete_sources = call(
        \ 'neocomplete#complete#_set_results_pos', [a:cur_text] + a:000)
  if empty(complete_sources)
    call neocomplete#print_debug('Skipped.')
    return []
  endif

  if neocomplete#is_auto_complete()
    let complete_pos =
          \ neocomplete#complete#_get_complete_pos(complete_sources)
    call neocomplete#complete#_set_previous_position(a:cur_text, complete_pos)
  endif

  call neocomplete#complete#_set_results_words(complete_sources)

  return filter(copy(complete_sources),
        \ '!empty(v:val.neocomplete__context.candidates)')
endfunction"}}}

function! neocomplete#complete#_get_complete_pos(sources) abort "{{{
  if empty(a:sources)
    return -1
  endif

  return min([col('.')] + map(copy(a:sources),
        \ 'v:val.neocomplete__context.complete_pos'))
endfunction"}}}

function! neocomplete#complete#_get_words(sources, complete_pos, complete_str) abort "{{{
  let frequencies = neocomplete#variables#get_frequencies()
  if exists('*neocomplete#sources#buffer#get_frequencies')
    let frequencies = extend(copy(
          \ neocomplete#sources#buffer#get_frequencies()),
          \ frequencies)
  endif

  " Append prefix.
  let candidates = []
  let len_words = 0
  for source in sort(filter(deepcopy(a:sources),
        \ '!empty(v:val.neocomplete__context.candidates)'),
        \  's:compare_source_rank')
    let context = source.neocomplete__context
    let words = type(context.candidates[0]) == type('') ?
          \ map(copy(context.candidates), "{'word': v:val}") :
          \ deepcopy(context.candidates)
    let context.candidates = words

    call neocomplete#helper#call_hook(
          \ source, 'on_post_filter', {})

    if context.complete_pos > a:complete_pos
      let prefix = a:complete_str[: context.complete_pos
            \                            - a:complete_pos - 1]

      " Fix complete position.
      let context.complete_pos = a:complete_pos
      let context.complete_str = prefix

      for candidate in words
        let candidate.word = prefix . candidate.word
      endfor
    endif

    lua << EOF
    do
      local frequencies = vim.eval('frequencies')
      local candidates = vim.eval('words')
      for i = 0, #candidates-1 do
        if frequencies[candidates[i].word] ~= nil then
          candidates[i].rank = frequencies[candidates[i].word]
        end
      end
    end
EOF

    let words = neocomplete#helper#call_filters(
          \ source.neocomplete__sorters, source, {})
    if empty(words)
      continue
    endif

    let words = neocomplete#helper#call_filters(
          \ source.neocomplete__converters, source, {})

    if empty(words)
      continue
    endif

    if source.max_candidates > 0
      let words = words[: source.max_candidates -1]
    endif

    " Set default menu.
    if get(words[0], 'menu', '') !~ '^\[.*\]'
      call s:set_default_menu(words, source)
    endif

    let candidates += words
    let len_words += len(words)

    if g:neocomplete#max_list > 0
          \ && len_words > g:neocomplete#max_list
      break
    endif

    if neocomplete#complete_check()
      return []
    endif
  endfor

  call filter(candidates, 'v:val.word !=# a:complete_str')

  if g:neocomplete#max_list > 0
    let candidates = candidates[: g:neocomplete#max_list]
  endif

  " Check dup and set icase.
  let icase = g:neocomplete#enable_ignore_case &&
        \ !((g:neocomplete#enable_smart_case
        \    || g:neocomplete#enable_camel_case) && a:complete_str =~ '\u')
  if icase
    for candidate in candidates
      let candidate.icase = 1
    endfor
  endif

  if neocomplete#complete_check()
    return []
  endif

  return candidates
endfunction"}}}
function! neocomplete#complete#_set_results_pos(cur_text, ...) abort "{{{
  " Initialize sources.
  let neocomplete = neocomplete#get_current_neocomplete()

  let filetype = neocomplete#get_context_filetype()
  let sources = (a:0 > 0) ? a:1 :
        \ (filetype ==# neocomplete.sources_filetype) ?
        \ neocomplete.sources : neocomplete#helper#get_sources_list()

  let pos = winsaveview()

  " Try source completion. "{{{
  let complete_sources = []
  for source in filter(values(sources),
        \ 'neocomplete#helper#is_enabled_source(v:val, filetype)')
    if !source.loaded
      call neocomplete#helper#call_hook(source, 'on_init', {})
      let source.loaded = 1
    endif

    let context = source.neocomplete__context
    let context.input = a:cur_text
    let context.filetype = filetype
    let context.filetypes = neocomplete#context_filetype#filetypes()

    try
      let complete_pos = s:use_previous_result(source, context) ?
            \ context.prev_complete_pos :
            \ has_key(source, 'get_complete_position') ?
            \ source.get_complete_position(context) :
            \ neocomplete#helper#match_word(context.input,
            \    neocomplete#get_keyword_pattern_end(filetype, source.name))[0]
    catch
      call neocomplete#print_error(v:throwpoint)
      call neocomplete#print_error(v:exception)
      call neocomplete#print_error(
            \ 'Error occurred in source''s get_complete_position()!')
      call neocomplete#print_error(
            \ 'Source name is ' . source.name)
      return complete_sources
    finally
      if winsaveview() != pos
        call winrestview(pos)
      endif
    endtry

    if complete_pos < 0
      let context.complete_pos = -1
      let context.complete_str = ''
      continue
    endif

    let complete_str = context.input[complete_pos :]
    if neocomplete#is_auto_complete() &&
          \ (source.input_pattern == '' ||
          \  context.input !~# '\%(' . source.input_pattern.'\m\)$') &&
          \ len(complete_str) < source.min_pattern_length
      " Skip.
      let context.complete_pos = -1
      let context.complete_str = ''
      continue
    endif

    let context.complete_pos = complete_pos
    let context.complete_str = complete_str
    call add(complete_sources, source)
  endfor
  "}}}

  return complete_sources
endfunction"}}}
function! neocomplete#complete#_set_results_words(sources) abort "{{{
  " Try source completion.

  " Save options.
  let ignorecase_save = &ignorecase
  let pos = winsaveview()

  try
    for source in a:sources
      if neocomplete#complete_check()
        return
      endif

      let context = source.neocomplete__context

      let &ignorecase = (g:neocomplete#enable_smart_case
            \ || g:neocomplete#enable_camel_case) ?
            \   context.complete_str !~ '\u'
            \ : g:neocomplete#enable_ignore_case

      if s:use_previous_result(source, context)
        " Use previous candidates.
        let context.candidates = deepcopy(context.prev_candidates)
      else
        try
          let winwidth = winwidth(0)
          let type_string = type('')
          let context.candidates = filter(source.gather_candidates(context),
                \ 'len((type(v:val) == type_string) ?
                \      v:val : v:val.word) < winwidth')
        catch
          call neocomplete#print_error(v:throwpoint)
          call neocomplete#print_error(v:exception)
          call neocomplete#print_error(
                \ 'Source name is ' . source.name)
          call neocomplete#print_error(
                \ 'Error occurred in source''s gather_candidates()!')

          return
        finally
          if winsaveview() != pos
            call winrestview(pos)
          endif
        endtry

        let context.prev_line = context.input
        let context.prev_candidates = copy(context.candidates)
        let context.prev_complete_pos = context.complete_pos
      endif

      if !empty(context.candidates)
        let matchers = empty(source.neocomplete__matchers) ?
              \   neocomplete#get_current_neocomplete().default_matchers
              \ : source.neocomplete__matchers
        let context.candidates = neocomplete#helper#call_filters(
              \ matchers, source, {})
      endif

      call neocomplete#print_debug(source.name)
    endfor
  finally
    let &ignorecase = ignorecase_save
  endtry
endfunction"}}}

function! neocomplete#complete#_check_previous_position(cur_text, complete_pos) abort "{{{
  let neocomplete = neocomplete#get_current_neocomplete()
  return a:complete_pos == neocomplete.old_complete_pos
        \ && line('.') == neocomplete.old_linenr
        \ && a:cur_text ==# neocomplete.old_cur_text
endfunction"}}}
function! neocomplete#complete#_set_previous_position(cur_text, complete_pos) abort "{{{
  let neocomplete = neocomplete#get_current_neocomplete()
  let neocomplete.old_complete_pos = a:complete_pos
  let neocomplete.old_linenr = line('.')
  let neocomplete.old_cur_text = a:cur_text
endfunction"}}}

" Source rank order. "{{{
function! s:compare_source_rank(i1, i2) abort
  return a:i2.rank - a:i1.rank
endfunction"}}}

function! s:set_default_menu(words, source) abort "{{{
  lua << EOF
  do
    local candidates = vim.eval('a:words')
    local mark = vim.eval('a:source.mark') .. ' '
    for i = 0, #candidates-1 do
      candidates[i].menu = mark .. (candidates[i].menu ~= nil and
                           candidates[i].menu or '')
    end
  end
EOF
endfunction"}}}

function! s:use_previous_result(source, context) abort "{{{
  let neocomplete = neocomplete#get_current_neocomplete()
  return !a:source.is_volatile
        \ && substitute(a:context.input, '\k\+$', '', '')
        \    ==# substitute(a:context.prev_line, '\k\+$', '', '')
        \ && stridx(a:context.input, a:context.prev_line) == 0
        \ && !empty(a:context.prev_candidates)
        \ && line('.') == neocomplete.old_linenr
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
