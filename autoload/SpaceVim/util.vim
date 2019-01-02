"=============================================================================
" util.vim --- SpaceVim utils
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#util#globpath(path, expr) abort
  if has('patch-7.4.279')
    return globpath(a:path, a:expr, 1, 1)
  else
    return split(globpath(a:path, a:expr), '\n')
  endif
endfunction

function! SpaceVim#util#findFileInParent(what, where) abort
  let old_suffixesadd = &suffixesadd
  let &suffixesadd = ''
  let file = findfile(a:what, escape(a:where, ' ') . ';')
  let &suffixesadd = old_suffixesadd
  return file
endfunction

function! SpaceVim#util#findDirInParent(what, where) abort
  let old_suffixesadd = &suffixesadd
  let &suffixesadd = ''
  let dir = finddir(a:what, escape(a:where, ' ') . ';')
  let &suffixesadd = old_suffixesadd
  return dir
endfunction

function! SpaceVim#util#echoWarn(msg) abort
  echohl WarningMsg
  echo a:msg
  echohl None
endfunction

let s:cache_pyx_libs = {}
function! SpaceVim#util#haspyxlib(lib) abort
  if has_key(s:cache_pyx_libs, a:lib)
    return s:cache_pyx_libs[a:lib]
  endif
  try
    exe 'pyx import ' . a:lib
  catch
    let s:cache_pyx_libs[a:lib] = 0
    return 0
  endtry
  let s:cache_pyx_libs[a:lib] = 1
  return 1
endfunction

let s:cache_py_libs = {}
function! SpaceVim#util#haspylib(lib) abort
  if has_key(s:cache_py_libs, a:lib)
    return s:cache_py_libs[a:lib]
  endif
  try
    exe 'py import ' . a:lib
  catch
    let s:cache_py_libs[a:lib] = 0
    return 0
  endtry
  let s:cache_py_libs[a:lib] = 1
  return 1
endfunction


let s:cache_py3_libs = {}
function! SpaceVim#util#haspy3lib(lib) abort
  if has_key(s:cache_py3_libs, a:lib)
    return s:cache_py3_libs[a:lib]
  endif
  try
    exe 'py3 import ' . a:lib
  catch
    let s:cache_py3_libs[a:lib] = 0
    return 0
  endtry
  let s:cache_py3_libs[a:lib] = 1
  return 1
endfunction

" vim:set et sw=2 cc=80:
