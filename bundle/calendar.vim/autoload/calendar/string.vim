" =============================================================================
" Filename: autoload/calendar/string.vim
" Author: itchyny
" License: MIT License
" Last Change: 2016/11/06 12:00:00.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" String manipulations.
" All the functions were imported from vital.vim.
" https://github.com/vim-jp/vital.vim (Public Domain)

let s:cache = calendar#countcache#new('string.vim')

function! calendar#string#truncate(str, width) abort
  let key = a:width . 'C' . a:str
  if s:cache.has_key(key) | return s:cache.get(key) | endif
  if a:str =~# '^[\x20-\x7e]*$'
    return len(a:str) < a:width
          \ ? printf('%-' . a:width . 's', a:str)
          \ : strpart(a:str, 0, a:width)
  endif
  let ret = a:str
  let width = strdisplaywidth(a:str)
  if width > a:width
    let ret = calendar#string#strwidthpart(ret, a:width)
    let width = strdisplaywidth(ret)
  endif
  if width < a:width
    let ret .= repeat(' ', a:width - width)
  endif
  return s:cache.save(key, ret)
endfunction

function! calendar#string#truncate_reverse(str, width) abort
  let key = a:width . 'U' . a:str
  if s:cache.has_key(key) | return s:cache.get(key) | endif
  if a:str =~# '^[\x20-\x7e]*$'
    return len(a:str) < a:width
          \ ? printf('%-' . a:width . 's', a:str)
          \ : strpart(a:str, len(a:str) - a:width)
  endif
  let ret = a:str
  let width = strdisplaywidth(a:str)
  if width > a:width
    let ret = calendar#string#strwidthpart_reverse(ret, a:width)
    let width = strdisplaywidth(ret)
  endif
  if width < a:width
    let ret = repeat(' ', a:width - width) . ret
  endif
  return s:cache.save(key, ret)
endfunction

function! calendar#string#strdisplaywidth(str) abort
  return strdisplaywidth(a:str)
endfunction

function! calendar#string#strwidthpart(str, width) abort
  let key = a:width . 'T' . a:str
  if s:cache.has_key(key) | return s:cache.get(key) | endif
  let str = tr(a:str, "\t", ' ')
  let vcol = a:width + 2
  let ret =  matchstr(str, '.*\%<' . (vcol < 0 ? 0 : vcol) . 'v')
  return s:cache.save(key, ret)
endfunction

function! calendar#string#strwidthpart_reverse(str, width) abort
  let key = a:width . 'R' . a:str
  if s:cache.has_key(key) | return s:cache.get(key) | endif
  let str = tr(a:str, "\t", ' ')
  let vcol = strdisplaywidth(str) - a:width
  let ret = matchstr(str, '\%>' . (vcol < 0 ? 0 : vcol) . 'v.*')
  return s:cache.save(key, ret)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
