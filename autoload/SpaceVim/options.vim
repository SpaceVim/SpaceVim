"=============================================================================
" options.vim --- options function in SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
let s:CPT = SpaceVim#api#import('vim#compatible')

function! SpaceVim#options#list() abort
  let list = []
  if has('patch-7.4.2010')
    for var in getcompletion('g:spacevim_','var')
      call add(list, '  ' . var[11:] . ' = ' . string(get(g:, var[2:] , '')))
    endfor
  else
    redraw
    for var in filter(map(split(s:CPT.execute('let g:'), "\n"), "matchstr(v:val, '\\S\\+')"), "v:val =~# '^spacevim_'")
      call add(list, '  ' . var[11:] . ' = ' . string(get(g:, var , '')))
    endfor
  endif
  return list
endfunction

function! SpaceVim#options#set(argv, ...) abort
  if a:0 > 0
    if exists('g:spacevim_' . a:argv)
      exe 'let g:spacevim_' . a:argv . '=' . a:1
    endif
  else
    if exists('g:spacevim_' . a:argv)
      exe 'echo string(g:spacevim_' . a:argv . ')'
    endif
  endif
endfunction

" vim:set et sw=2:
