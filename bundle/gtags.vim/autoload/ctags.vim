"=============================================================================
" ctags.vim --- ctags generator
" Copyright (c) 2016-2021 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8

let s:LOGGER =SpaceVim#logger#derive('ctags')

if !executable('ctags')
  call s:LOGGER.warn('ctags is not executable, you need to install ctags')
  finish
endif

if exists('g:loaded_ctags')
  finish
endif

let s:JOB = SpaceVim#api#import('job')
let s:FILE = SpaceVim#api#import('file')

let g:loaded_ctags = 1

function! ctags#update() abort
  let project_root = getcwd()
  call s:LOGGER.info('update ctags database for ' . project_root)
  let dir = s:FILE.unify_path(g:tags_cache_dir) 
        \ . s:FILE.path_to_fname(project_root)
  let cmd = ['ctags']
  if !isdirectory(dir)
    call mkdir(dir, 'p')
  endif
  if isdirectory(dir)
    let cmd += ['-R', '-o', dir . '/tags', project_root]
    call s:JOB.start(cmd, {'on_exit' : funcref('s:on_update_exit')})
  endif
endfunction

function! s:on_update_exit(...) abort
  if str2nr(a:2) > 0
    call s:LOGGER.warn('failed to update gtags, exit data: ' . a:2)
  else
    call s:LOGGER.info('ctags database updated successfully')
  endif
endfunction
