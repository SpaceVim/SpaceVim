"=============================================================================
" FILE: neocomplete.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
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

if !exists('g:loaded_neocomplete')
  runtime! plugin/neocomplete.vim
endif

let s:save_cpo = &cpo
set cpo&vim

" Global options definition. "{{{
let g:neocomplete#max_list =
      \ get(g:, 'neocomplete#max_list', 100)
let g:neocomplete#max_keyword_width =
      \ get(g:, 'neocomplete#max_keyword_width', 80)
let g:neocomplete#auto_completion_start_length =
      \ get(g:, 'neocomplete#auto_completion_start_length', 2)
let g:neocomplete#manual_completion_start_length =
      \ get(g:, 'neocomplete#manual_completion_start_length', 0)
let g:neocomplete#min_keyword_length =
      \ get(g:, 'neocomplete#min_keyword_length', 4)
let g:neocomplete#enable_ignore_case =
      \ get(g:, 'neocomplete#enable_ignore_case', &ignorecase)
let g:neocomplete#enable_smart_case =
      \ get(g:, 'neocomplete#enable_smart_case', &infercase)
let g:neocomplete#enable_camel_case =
      \ get(g:, 'neocomplete#enable_camel_case', 0)
let g:neocomplete#disable_auto_complete =
      \ get(g:, 'neocomplete#disable_auto_complete', 0)
let g:neocomplete#enable_fuzzy_completion =
      \ get(g:, 'neocomplete#enable_fuzzy_completion', 1)
let g:neocomplete#auto_complete_delay =
      \ get(g:, 'neocomplete#auto_complete_delay', 50)
let g:neocomplete#enable_auto_select =
      \ get(g:, 'neocomplete#enable_auto_select', 0)
let g:neocomplete#enable_auto_delimiter =
      \ get(g:, 'neocomplete#enable_auto_delimiter', 0)
let g:neocomplete#lock_buffer_name_pattern =
      \ get(g:, 'neocomplete#lock_buffer_name_pattern', '')
let g:neocomplete#lock_iminsert =
      \ get(g:, 'neocomplete#lock_iminsert', 0)
let g:neocomplete#enable_multibyte_completion =
      \ get(g:, 'neocomplete#enable_multibyte_completion', 0)
let g:neocomplete#release_cache_time =
      \ get(g:, 'neocomplete#release_cache_time', 900)
let g:neocomplete#skip_auto_completion_time =
      \ get(g:, 'neocomplete#skip_auto_completion_time', '0.3')
let g:neocomplete#enable_auto_close_preview =
      \ get(g:, 'neocomplete#enable_auto_close_preview', 0)
let g:neocomplete#enable_refresh_always =
      \ get(g:, 'neocomplete#enable_refresh_always', 0)
let g:neocomplete#fallback_mappings =
      \ get(g:, 'neocomplete#fallback_mappings', [])
let g:neocomplete#sources =
      \ get(g:, 'neocomplete#sources', {})
let g:neocomplete#keyword_patterns =
      \ get(g:, 'neocomplete#keyword_patterns', {})
let g:neocomplete#delimiter_patterns =
      \ get(g:, 'neocomplete#delimiter_patterns', {})
let g:neocomplete#text_mode_filetypes =
      \ get(g:, 'neocomplete#text_mode_filetypes', {})
let g:neocomplete#tags_filter_patterns =
      \ get(g:, 'neocomplete#tags_filter_patterns', {})
let g:neocomplete#force_omni_input_patterns =
      \ get(g:, 'neocomplete#force_omni_input_patterns', {})
let g:neocomplete#ignore_source_files =
      \ get(g:, 'neocomplete#ignore_source_files', [])
"}}}

function! neocomplete#initialize() abort "{{{
  return neocomplete#init#enable()
endfunction"}}}

function! neocomplete#get_current_neocomplete() abort "{{{
  if !exists('b:neocomplete')
    call neocomplete#init#_current_neocomplete()
  endif

  return b:neocomplete
endfunction"}}}
function! neocomplete#get_context() abort "{{{
  return neocomplete#get_current_neocomplete().context
endfunction"}}}

" Source helper. "{{{
function! neocomplete#define_source(source) abort "{{{
  let sources = neocomplete#variables#get_sources()
  for source in neocomplete#util#convert2list(a:source)
    let source = neocomplete#init#_source(source)
    if !source.disabled
      let sources[source.name] = source
    endif
  endfor
endfunction"}}}
function! neocomplete#define_filter(filter) abort "{{{
  let filters = neocomplete#variables#get_filters()
  for filter in neocomplete#util#convert2list(a:filter)
    let filters[filter.name] = neocomplete#init#_filter(filter)
  endfor
endfunction"}}}
function! neocomplete#available_sources() abort "{{{
  return copy(neocomplete#variables#get_sources())
endfunction"}}}
function! neocomplete#custom_source(source_name, option_name, value) abort "{{{
  return neocomplete#custom#source(a:source_name, a:option_name, a:value)
endfunction"}}}

function! neocomplete#dup_filter(list) abort "{{{
  return neocomplete#util#dup_filter(a:list)
endfunction"}}}

function! neocomplete#system(...) abort "{{{
  return call('neocomplete#util#system', a:000)
endfunction"}}}
function! neocomplete#has_vimproc() abort "{{{
  return neocomplete#util#has_vimproc()
endfunction"}}}

function! neocomplete#get_cur_text(...) abort "{{{
  " Return cached text.
  let neocomplete = neocomplete#get_current_neocomplete()
  return (a:0 == 0 && mode() ==# 'i' &&
        \  neocomplete.cur_text != '') ?
        \ neocomplete.cur_text : neocomplete#helper#get_cur_text()
endfunction"}}}
function! neocomplete#get_keyword_pattern(...) abort "{{{
  let filetype = a:0 != 0? a:1 : neocomplete#get_context_filetype()
  if a:0 < 2
    return neocomplete#helper#unite_patterns(
          \ g:neocomplete#keyword_patterns, filetype)
  endif

  let source = neocomplete#variables#get_source(a:2)
  if !has_key(source, 'neocomplete__keyword_patterns')
    let source.neocomplete__keyword_patterns = {}
  endif
  if !has_key(source.neocomplete__keyword_patterns, filetype)
    let source.neocomplete__keyword_patterns[filetype] =
          \ neocomplete#helper#unite_patterns(
          \         source.keyword_patterns, filetype)
  endif

  return source.neocomplete__keyword_patterns[filetype]
endfunction"}}}
function! neocomplete#get_keyword_pattern_end(...) abort "{{{
  return '\%('.call('neocomplete#get_keyword_pattern', a:000).'\m\)$'
endfunction"}}}
function! neocomplete#match_word(...) abort "{{{
  return call('neocomplete#helper#match_word', a:000)
endfunction"}}}
function! neocomplete#is_enabled() abort "{{{
  return neocomplete#init#is_enabled()
endfunction"}}}
function! neocomplete#is_locked(...) abort "{{{
  return neocomplete#is_cache_disabled() || &paste
        \ || (&t_Co != '' && &t_Co < 8)
        \ || g:neocomplete#disable_auto_complete
endfunction"}}}
function! neocomplete#is_cache_disabled() abort "{{{
  let ignore_filetypes = ['fuf', 'ku']
  let bufnr = a:0 > 0 ? a:1 : bufnr('%')
  return !neocomplete#is_enabled()
        \ || index(ignore_filetypes, &filetype) >= 0
        \ || neocomplete#get_current_neocomplete().lock
        \ || (g:neocomplete#lock_buffer_name_pattern != '' &&
        \   bufname(bufnr) =~ g:neocomplete#lock_buffer_name_pattern)
endfunction"}}}
function! neocomplete#is_auto_select() abort "{{{
  return g:neocomplete#enable_auto_select
endfunction"}}}
function! neocomplete#is_auto_complete() abort "{{{
  let neocomplete = neocomplete#get_current_neocomplete()
  return neocomplete.is_auto_complete
endfunction"}}}
function! neocomplete#is_eskk_enabled() abort "{{{
  return exists('*eskk#is_enabled') && eskk#is_enabled()
endfunction"}}}
function! neocomplete#is_multibyte_input(cur_text) abort "{{{
  return (exists('b:skk_on') && b:skk_on)
        \   || (!g:neocomplete#enable_multibyte_completion
        \         && char2nr(split(a:cur_text, '\zs')[-1]) > 0x80)
endfunction"}}}
function! neocomplete#is_text_mode() abort "{{{
  let neocomplete = neocomplete#get_current_neocomplete()
  let filetypes = g:neocomplete#text_mode_filetypes
  return get(filetypes, neocomplete.context_filetype, 0)
        \ || get(filetypes, '_', 0)
endfunction"}}}
function! neocomplete#is_windows() abort "{{{
  return neocomplete#util#is_windows()
endfunction"}}}
function! neocomplete#is_prefetch() abort "{{{
  return 1
endfunction"}}}
function! neocomplete#exists_echodoc() abort "{{{
  return exists('g:loaded_echodoc') && g:loaded_echodoc
endfunction"}}}
function! neocomplete#within_comment() abort "{{{
  return neocomplete#get_current_neocomplete().within_comment
endfunction"}}}
function! neocomplete#print_error(string) abort "{{{
  echohl Error | echomsg '[neocomplete] ' . a:string | echohl None
endfunction"}}}
function! neocomplete#print_warning(string) abort "{{{
  echohl WarningMsg | echomsg '[neocomplete] ' . a:string | echohl None
endfunction"}}}
function! neocomplete#head_match(checkstr, headstr) abort "{{{
  let checkstr = &ignorecase ?
        \ tolower(a:checkstr) : a:checkstr
  let headstr = &ignorecase ?
        \ tolower(a:headstr) : a:headstr
  return stridx(checkstr, headstr) == 0
endfunction"}}}
function! neocomplete#get_source_filetypes(filetype) abort "{{{
  return neocomplete#helper#get_source_filetypes(a:filetype)
endfunction"}}}
function! neocomplete#escape_match(str) abort "{{{
  return escape(a:str, '~"*\.^$[]')
endfunction"}}}
function! neocomplete#get_context_filetype(...) abort "{{{
  let neocomplete = exists('b:neocomplete') ?
        \ b:neocomplete : neocomplete#get_current_neocomplete()

  if a:0 != 0 || mode() !=# 'i' ||
        \ neocomplete.context_filetype == ''
    call neocomplete#context_filetype#set()
  endif

  return neocomplete.context_filetype
endfunction"}}}
function! neocomplete#print_debug(expr) abort "{{{
  if g:neocomplete#enable_debug
    echomsg string(a:expr)
  endif
endfunction"}}}
function! neocomplete#get_data_directory() abort "{{{
  let g:neocomplete#data_directory =
        \ get(g:, 'neocomplete#data_directory',
        \  ($XDG_CACHE_HOME != '' ?
        \   $XDG_CACHE_HOME . '/neocomplete' : '~/.cache/neocomplete'))
  let directory = neocomplete#util#substitute_path_separator(
        \ neocomplete#util#expand(g:neocomplete#data_directory))
  if !isdirectory(directory)
    if neocomplete#util#is_sudo()
      call neocomplete#print_error(printf(
            \ 'Cannot create Directory "%s" in sudo session.', directory))
    else
      call mkdir(directory, 'p')
    endif
  endif

  return directory
endfunction"}}}
function! neocomplete#complete_check() abort "{{{
  return neocomplete#helper#complete_check()
endfunction"}}}
function! neocomplete#skip_next_complete() abort "{{{
  let neocomplete = neocomplete#get_current_neocomplete()
  let neocomplete.skip_next_complete = 1
endfunction"}}}
function! neocomplete#get_default_matchers() abort "{{{
  return map(copy(neocomplete#get_current_neocomplete().default_matchers),
        \ 'v:val.name')
endfunction"}}}
function! neocomplete#set_default_matchers(matchers) abort "{{{
  let neocomplete = neocomplete#get_current_neocomplete()
  let neocomplete.default_matchers = neocomplete#init#_filters(
        \ neocomplete#util#convert2list(a:matchers))
endfunction"}}}

function! neocomplete#set_dictionary_helper(variable, keys, value) abort "{{{
  return neocomplete#util#set_dictionary_helper(
        \ a:variable, a:keys, a:value)
endfunction"}}}
function! neocomplete#disable_default_dictionary(variable) abort "{{{
  return neocomplete#util#disable_default_dictionary(a:variable)
endfunction"}}}
function! neocomplete#filetype_complete(arglead, cmdline, cursorpos) abort "{{{
  return neocomplete#helper#filetype_complete(a:arglead, a:cmdline, a:cursorpos)
endfunction"}}}
"}}}

" Key mapping functions. "{{{
function! neocomplete#smart_close_popup() abort
  return neocomplete#mappings#smart_close_popup()
endfunction
function! neocomplete#close_popup() abort
  return neocomplete#mappings#close_popup()
endfunction
function! neocomplete#cancel_popup() abort
  return neocomplete#mappings#cancel_popup()
endfunction
function! neocomplete#undo_completion() abort
  return neocomplete#mappings#undo_completion()
endfunction
function! neocomplete#complete_common_string() abort
  return neocomplete#mappings#complete_common_string()
endfunction
function! neocomplete#start_manual_complete(...) abort
  return call('neocomplete#mappings#start_manual_complete', a:000)
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
