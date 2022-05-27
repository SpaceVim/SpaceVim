"=============================================================================
" ctags.vim --- ctags generator
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8

if exists('g:loaded_ctags')
  finish
endif


let s:LOGGER =SpaceVim#logger#derive('ctags')

if !exists('g:gtags_ctags_bin')
    let g:gtags_ctags_bin = 'ctags'
endif

if !executable(g:gtags_ctags_bin)
  call s:LOGGER.warn(g:gtags_ctags_bin . ' is not executable, you need to install ctags')
  finish
endif

let s:JOB = SpaceVim#api#import('job')
let s:FILE = SpaceVim#api#import('file')

let g:loaded_ctags = 1

let s:is_u_ctags = 0
let s:version_checked = 0
function! s:version_std_out(id, data, event) abort
  for line in a:data
    if line =~# 'Universal Ctags'
      let s:is_u_ctags = 1
      break
    endif
  endfor
endfunction

function! s:version_exit(id, data, event) abort
  if a:data ==# 0
    let s:version_checked = 1
    call ctags#update()
  endif
endfunction


function! ctags#update(...) abort
  if !s:version_checked
    call s:JOB.start([g:gtags_ctags_bin, '--version'], {
          \ 'on_stdout': funcref('s:version_std_out'),
          \ 'on_exit': funcref('s:version_exit'),
          \ })
    return
  endif
  let project_root = getcwd()
  call s:LOGGER.info('update ctags database for ' . project_root)
  let dir = s:FILE.unify_path(g:tags_cache_dir) 
        \ . s:FILE.path_to_fname(project_root)
  let cmd = [g:gtags_ctags_bin]
  if s:is_u_ctags
    let cmd += ['-G']
  endif
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
