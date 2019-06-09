"=============================================================================
" filetypeicon.vim --- filetypeicon support for vimfiler
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim
scriptencoding utf-8

let s:FILE = SpaceVim#api#import('file')

let s:fish = &shell =~# 'fish'

function! vimfiler#columns#filetypeicon#define() abort
  return s:column
endfunction"}}}

let s:column = {
      \ 'name' : 'filetypeicon',
      \ 'description' : 'plugin for vimfiler that provides filetype icon',
      \ 'syntax' : 'vimfilerColumn__FileType',
      \ }

" @vimlint(EVL103, 1, a:files)
" @vimlint(EVL103, 1, a:context)
function! s:column.length(files, context) abort
  return 3
endfunction
" @vimlint(EVL103, 0, a:files)
" @vimlint(EVL103, 0, a:context)

" @vimlint(EVL103, 1, a:context)
function! s:column.define_syntax(context) abort
endfunction
" @vimlint(EVL103, 0, a:context)

" @vimlint(EVL103, 1, a:context)
function! s:column.get(file, context) abort
  if a:file.vimfiler__is_directory
      return '   '
  else
    let icon = s:FILE.fticon(a:file.action__path)

    if !empty(icon)
      return '[' . icon . ']'
    else
      return '   '
    endif
  endif
endfunction
" @vimlint(EVL103, 0, a:context)

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et sw=2:
