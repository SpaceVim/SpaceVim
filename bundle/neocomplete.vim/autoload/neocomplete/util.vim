"=============================================================================
" FILE: util.vim
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


function! neocomplete#util#get_vital() abort "{{{
  if !exists('s:V')
    let s:V = vital#neocomplete#new()
  endif
  return s:V
endfunction"}}}
function! s:get_prelude() abort "{{{
  if !exists('s:Prelude')
    let s:Prelude = neocomplete#util#get_vital().import('Prelude')
  endif
  return s:Prelude
endfunction"}}}
function! s:get_list() abort "{{{
  if !exists('s:List')
    let s:List = neocomplete#util#get_vital().import('Data.List')
  endif
  return s:List
endfunction"}}}
function! s:get_string() abort "{{{
  if !exists('s:String')
    let s:String = neocomplete#util#get_vital().import('Data.String')
  endif
  return s:String
endfunction"}}}
function! s:get_process() abort "{{{
  if !exists('s:Process')
    let s:Process = neocomplete#util#get_vital().import('Process')
  endif
  return s:Process
endfunction"}}}

function! neocomplete#util#truncate_smart(...) abort "{{{
  return call(s:get_string().truncate_skipping, a:000)
endfunction"}}}
function! neocomplete#util#truncate(...) abort "{{{
  return call(s:get_string().truncate, a:000)
endfunction"}}}
function! neocomplete#util#strchars(...) abort "{{{
  return call(s:get_string().strchars, a:000)
endfunction"}}}
function! neocomplete#util#wcswidth(string) abort "{{{
  return strwidth(a:string)
endfunction"}}}
function! neocomplete#util#strwidthpart(...) abort "{{{
  return call(s:get_string().strwidthpart, a:000)
endfunction"}}}
function! neocomplete#util#strwidthpart_reverse(...) abort "{{{
  return call(s:get_string().strwidthpart_reverse, a:000)
endfunction"}}}

function! neocomplete#util#substitute_path_separator(...) abort "{{{
  return call(s:get_prelude().substitute_path_separator, a:000)
endfunction"}}}
function! neocomplete#util#mb_strlen(...) abort "{{{
  return call(s:get_string().strchars, a:000)
endfunction"}}}
function! neocomplete#util#uniq(list) abort "{{{
  let dict = {}
  for item in a:list
    if !has_key(dict, item)
      let dict[item] = item
    endif
  endfor

  return values(dict)
endfunction"}}}
function! neocomplete#util#system(...) abort "{{{
  return call(s:get_process().system, a:000)
endfunction"}}}
function! neocomplete#util#is_windows(...) abort "{{{
  return call(s:get_prelude().is_windows, a:000)
endfunction"}}}
function! neocomplete#util#is_mac(...) abort "{{{
  return call(s:get_prelude().is_mac, a:000)
endfunction"}}}
function! neocomplete#util#is_complete_select() abort "{{{
  return has('patch-7.4.775')
endfunction"}}}
function! neocomplete#util#get_last_status(...) abort "{{{
  return call(s:get_process().get_last_status, a:000)
endfunction"}}}
function! neocomplete#util#escape_pattern(...) abort "{{{
  return call(s:get_string().escape_pattern, a:000)
endfunction"}}}
function! neocomplete#util#iconv(...) abort "{{{
  return call(s:get_process().iconv, a:000)
endfunction"}}}
function! neocomplete#util#uniq(...) abort "{{{
  return call(s:get_list().uniq, a:000)
endfunction"}}}
function! neocomplete#util#sort_by(...) abort "{{{
  return call(s:get_list().sort_by, a:000)
endfunction"}}}

" Sudo check.
function! neocomplete#util#is_sudo() abort "{{{
  return $SUDO_USER != '' && $USER !=# $SUDO_USER
      \ && $HOME !=# expand('~'.$USER)
      \ && $HOME ==# expand('~'.$SUDO_USER)
endfunction"}}}

function! neocomplete#util#glob(pattern, ...) abort "{{{
  if a:pattern =~ "'"
    " Use glob('*').
    let cwd = getcwd()
    let base = neocomplete#util#substitute_path_separator(
          \ fnamemodify(a:pattern, ':h'))
    execute 'lcd' fnameescape(base)

    let files = map(split(neocomplete#util#substitute_path_separator(
          \ glob('*')), '\n'), "base . '/' . v:val")

    execute 'lcd' fnameescape(cwd)

    return files
  endif

  " let is_force_glob = get(a:000, 0, 0)
  let is_force_glob = get(a:000, 0, 1)

  if !is_force_glob && a:pattern =~ '^[^\\*]\+/\*'
        \ && neocomplete#util#has_vimproc() && exists('*vimproc#readdir')
    return filter(vimproc#readdir(a:pattern[: -2]), 'v:val !~ "/\\.\\.\\?$"')
  else
    " Escape [.
    if neocomplete#util#is_windows()
      let glob = substitute(a:pattern, '\[', '\\[[]', 'g')
    else
      let glob = escape(a:pattern, '[')
    endif

    return split(neocomplete#util#substitute_path_separator(glob(glob)), '\n')
  endif
endfunction"}}}
function! neocomplete#util#expand(path) abort "{{{
  return expand(escape(a:path, '*?[]"={}'), 1)
endfunction"}}}

function! neocomplete#util#set_default(var, val, ...) abort  "{{{
  if !exists(a:var) || type({a:var}) != type(a:val)
    let alternate_var = get(a:000, 0, '')

    let {a:var} = exists(alternate_var) ?
          \ {alternate_var} : a:val
  endif
endfunction"}}}
function! neocomplete#util#set_dictionary_helper(variable, keys, pattern) abort "{{{
  for key in split(a:keys, '\s*,\s*')
    if !has_key(a:variable, key)
      let a:variable[key] = a:pattern
    endif
  endfor
endfunction"}}}

function! neocomplete#util#set_default_dictionary(variable, keys, value) abort "{{{
  if !exists('s:disable_dictionaries')
    let s:disable_dictionaries = {}
  endif

  if has_key(s:disable_dictionaries, a:variable)
    return
  endif

  call neocomplete#util#set_dictionary_helper({a:variable}, a:keys, a:value)
endfunction"}}}
function! neocomplete#util#disable_default_dictionary(variable) abort "{{{
  if !exists('s:disable_dictionaries')
    let s:disable_dictionaries = {}
  endif

  let s:disable_dictionaries[a:variable] = 1
endfunction"}}}

function! neocomplete#util#split_rtp(...) abort "{{{
  let rtp = a:0 ? a:1 : &runtimepath
  if type(rtp) == type([])
    return rtp
  endif

  if rtp !~ '\\'
    return split(rtp, ',')
  endif

  let split = split(rtp, '\\\@<!\%(\\\\\)*\zs,')
  return map(split,'substitute(v:val, ''\\\([\\,]\)'', "\\1", "g")')
endfunction"}}}
function! neocomplete#util#join_rtp(list) abort "{{{
  return join(map(copy(a:list), 's:escape(v:val)'), ',')
endfunction"}}}
" Escape a path for runtimepath.
function! s:escape(path) abort"{{{
  return substitute(a:path, ',\|\\,\@=', '\\\0', 'g')
endfunction"}}}

function! neocomplete#util#has_vimproc() abort "{{{
  " Initialize.
  if !exists('g:neocomplete#use_vimproc')
    " Check vimproc.
    try
      call vimproc#version()
      let exists_vimproc = 1
    catch
      let exists_vimproc = 0
    endtry

    let g:neocomplete#use_vimproc = exists_vimproc
  endif

  return g:neocomplete#use_vimproc
endfunction"}}}

function! neocomplete#util#dup_filter(list) abort "{{{
  let dict = {}
  for keyword in a:list
    if !has_key(dict, keyword.word)
      let dict[keyword.word] = keyword
    endif
  endfor

  return values(dict)
endfunction"}}}

function! neocomplete#util#convert2list(expr) abort "{{{
  return type(a:expr) ==# type([]) ? a:expr : [a:expr]
endfunction"}}}

function! neocomplete#util#is_text_changed() abort "{{{
  " Note: Vim 7.4.143 fixed TextChangedI bug.
  return v:version > 704 || v:version == 704 && has('patch143')
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
