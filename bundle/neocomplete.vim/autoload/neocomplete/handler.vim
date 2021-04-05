"=============================================================================
" FILE: handler.vim
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

function! neocomplete#handler#_on_moved_i() abort "{{{
  let neocomplete = neocomplete#get_current_neocomplete()
  if neocomplete.linenr != line('.')
    call neocomplete#helper#clear_result()
  endif
  let neocomplete.linenr = line('.')

  call s:close_preview_window()
endfunction"}}}
function! neocomplete#handler#_on_insert_enter() abort "{{{
  if !neocomplete#is_enabled()
    return
  endif

  let neocomplete = neocomplete#get_current_neocomplete()
  if neocomplete.linenr != line('.')
    call neocomplete#helper#clear_result()
  endif
  let neocomplete.linenr = line('.')

  if &l:foldmethod ==# 'expr' && foldlevel('.') != 0
    foldopen
  endif
endfunction"}}}
function! neocomplete#handler#_on_insert_leave() abort "{{{
  call neocomplete#helper#clear_result()

  call s:close_preview_window()
  call s:make_cache_current_line()

  let neocomplete = neocomplete#get_current_neocomplete()
  let neocomplete.cur_text = ''
endfunction"}}}
function! neocomplete#handler#_on_complete_done() abort "{{{
  let neocomplete = neocomplete#get_current_neocomplete()

  if neocomplete.event !=# 'mapping'
        \ && !s:is_delimiter() && !get(neocomplete, 'refresh', 0)
    call neocomplete#mappings#close_popup()
  endif

  " Use v:completed_item feature.
  if !exists('v:completed_item') || empty(v:completed_item)
    return
  endif

  let complete_str = v:completed_item.word
  if complete_str == ''
    return
  endif

  let frequencies = neocomplete#variables#get_frequencies()
  if !has_key(frequencies, complete_str)
    let frequencies[complete_str] = 20
  else
    let frequencies[complete_str] += 20
  endif
endfunction"}}}
function! neocomplete#handler#_on_insert_char_pre() abort "{{{
  let neocomplete = neocomplete#get_current_neocomplete()
  let neocomplete.skip_next_complete = 0

  if pumvisible() && g:neocomplete#enable_refresh_always
    " Auto refresh
    call feedkeys("\<Plug>(neocomplete_auto_refresh)")
  endif

  if neocomplete#is_cache_disabled()
    return
  endif

  let neocomplete.old_char = v:char
endfunction"}}}
function! neocomplete#handler#_on_text_changed() abort "{{{
  if neocomplete#is_cache_disabled()
    return
  endif

  if getline('.') == ''
    call s:make_cache_current_line()
  endif

  if !neocomplete#util#is_text_changed()
    call s:indent_current_line()
  endif
endfunction"}}}

function! s:complete_delay(timer) abort "{{{
  let event = s:timer.event
  unlet! s:timer

  if mode() ==# 'i'
    call s:do_auto_complete(event)
  endif
endfunction"}}}

function! neocomplete#handler#_do_auto_complete(event) abort "{{{
  if s:check_in_do_auto_complete(a:event)
    return
  endif

  if g:neocomplete#auto_complete_delay > 0 && has('timers')
        \ && (!has('gui_macvim') || has('patch-8.0.95'))
    if exists('s:timer')
      call timer_stop(s:timer.id)
    endif
    if a:event !=# 'Manual'
      let s:timer = { 'event': a:event }
      let s:timer.id = timer_start(
            \ g:neocomplete#auto_complete_delay,
            \ function('s:complete_delay'))
      return
    endif
  endif

  return s:do_auto_complete(a:event)
endfunction"}}}

function! s:do_auto_complete(event) abort "{{{
  let neocomplete = neocomplete#get_current_neocomplete()

  if s:check_in_do_auto_complete(a:event)
    return
  endif

  let neocomplete.skipped = 0
  let neocomplete.event = a:event
  call neocomplete#helper#clear_result()

  " Set context filetype.
  call neocomplete#context_filetype#set()

  let cur_text = neocomplete#get_cur_text(1)
  let complete_pos = -1

  call neocomplete#print_debug('cur_text = ' . cur_text)

  try
    " Prevent infinity loop.
    if s:is_skip_auto_complete(cur_text)
      call neocomplete#print_debug('Skipped.')
      return
    endif

    let complete_pos = s:check_force_omni(cur_text)
    if complete_pos >= 0
      return
    endif

    " Check multibyte input or eskk or spaces.
    if cur_text =~ '^\s*$'
          \ || (!neocomplete#is_eskk_enabled()
          \     && neocomplete#is_multibyte_input(cur_text))
      call neocomplete#print_debug('Skipped.')
      return
    endif

    try
      let neocomplete.is_auto_complete = 1

      " Do prefetch.
      let neocomplete.complete_sources =
            \ neocomplete#complete#_get_results(cur_text)
    finally
      let neocomplete.is_auto_complete = 0
    endtry

    if empty(neocomplete.complete_sources)
      call s:check_fallback(cur_text)
      return
    endif

    " Start auto complete.
    call s:complete_key(
          \ "\<Plug>(neocomplete_start_auto_complete)")
  finally
    call neocomplete#complete#_set_previous_position(cur_text, complete_pos)
  endtry
endfunction"}}}

function! s:check_in_do_auto_complete(event) abort "{{{
  if neocomplete#is_locked()
        \ || (a:event !=# 'InsertEnter' && mode() !=# 'i')
    return 1
  endif

  " Detect completefunc.
  if &l:completefunc != '' && &l:buftype =~ 'nofile'
    return 1
  endif
endfunction"}}}
function! s:is_skip_auto_complete(cur_text) abort "{{{
  let neocomplete = neocomplete#get_current_neocomplete()

  if (g:neocomplete#lock_iminsert && &l:iminsert)
        \ || (&l:formatoptions =~# '[tca]' && &l:textwidth > 0
        \     && strdisplaywidth(a:cur_text) >= &l:textwidth)
    let neocomplete.skip_next_complete = 0
    return 1
  endif

  let skip = neocomplete.skip_next_complete

  if !skip || s:is_delimiter()
    return 0
  endif

  let neocomplete.skip_next_complete = 0
  return skip
endfunction"}}}
function! s:close_preview_window() abort "{{{
  if g:neocomplete#enable_auto_close_preview
        \ && bufname('%') !=# '[Command Line]'
        \ && winnr('$') != 1 && !&l:previewwindow
        \ && !neocomplete#is_cache_disabled()
    " Close preview window.
    pclose!
  endif
endfunction"}}}
function! s:make_cache_current_line() abort "{{{
  let neocomplete = neocomplete#get_current_neocomplete()
  if neocomplete#helper#is_enabled_source('buffer',
        \ neocomplete.context_filetype)
    " Caching current cache line.
    call neocomplete#sources#buffer#make_cache_current_line()
  endif
  if neocomplete#helper#is_enabled_source('member',
        \ neocomplete.context_filetype)
    " Caching current cache line.
    call neocomplete#sources#member#make_cache_current_line()
  endif
endfunction"}}}
function! s:check_force_omni(cur_text) abort "{{{
  let cur_text = a:cur_text
  let complete_pos = neocomplete#helper#get_force_omni_complete_pos(cur_text)

  if complete_pos >= 0
        \ && !neocomplete#complete#_check_previous_position(
        \       cur_text, complete_pos)
    call s:complete_key("\<Plug>(neocomplete_start_omni_complete)")
  endif

  return complete_pos
endfunction"}}}
function! s:check_fallback(cur_text) abort "{{{
  let cur_text = a:cur_text
  let complete_pos = match(cur_text, '\h\w*$')
  let neocomplete = neocomplete#get_current_neocomplete()
  if empty(g:neocomplete#fallback_mappings)
        \ || len(matchstr(cur_text, '\h\w*$'))
        \   < g:neocomplete#auto_completion_start_length
        \ || neocomplete.skip_next_complete
        \ || neocomplete#complete#_check_previous_position(
        \      cur_text, complete_pos)
    return
  endif

  let key = ''
  for i in range(0, len(g:neocomplete#fallback_mappings)-1)
    let key .= '<C-r>=neocomplete#mappings#fallback(' . i . ')<CR>'
  endfor
  execute 'inoremap <silent> <Plug>(neocomplete_fallback)' key

  " Fallback
  call s:complete_key("\<Plug>(neocomplete_fallback)")
endfunction"}}}

function! s:complete_key(key) abort "{{{
  call neocomplete#helper#complete_configure()

  if has('patch-7.4.601')
    call feedkeys(a:key, 'i')
  else
    call feedkeys(a:key)
  endif
endfunction"}}}

function! s:indent_current_line() abort "{{{
  " indent line matched by indentkeys
  let neocomplete = neocomplete#get_current_neocomplete()

  let cur_text = matchstr(getline('.'), '^.*\%'.col('.').'c')
  if neocomplete.indent_text == matchstr(getline('.'), '\S.*$')
    return
  endif

  for word in filter(map(split(&l:indentkeys, ','),
        \ "v:val =~ '^<.*>$' ? matchstr(v:val, '^<\\zs.*\\ze>$')
        \                  : matchstr(v:val, ':\\|e\\|=\\zs.*')"),
        \ "v:val != ''")

    if word ==# 'e'
      let word = 'else'
    endif

    let lastpos = len(cur_text)-len(word)
    if lastpos >= 0 && strridx(cur_text, word) == lastpos
      call neocomplete#helper#indent_current_line()
      let neocomplete.indent_text = matchstr(getline('.'), '\S.*$')
      break
    endif
  endfor
endfunction"}}}
function! s:is_delimiter() abort "{{{
  " Check delimiter pattern.
  let is_delimiter = 0
  let cur_text = neocomplete#get_cur_text(1)

  for delimiter in ['/']
    if stridx(cur_text, delimiter,
          \ len(cur_text) - len(delimiter)) >= 0
      let is_delimiter = 1
      break
    endif
  endfor

  return is_delimiter
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
