"=============================================================================
" ctags.vim --- ctags generator
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8

if exists('g:loaded_ctags')
  finish
endif
let g:loaded_ctags = 1
if has('nvim-0.7.0')
  function! ctags#update(...) abort
    lua require('ctags').update()
  endfunction
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
    call s:LOGGER.info('ctags version checking done:')
    call s:LOGGER.info('      ctags bin:' . g:gtags_ctags_bin)
    call ctags#update()
  endif
endfunction


function! ctags#update(...) abort
  let project_root = getcwd()
  if !s:version_checked
    call s:LOGGER.info('start to check ctags version')
    call s:JOB.start([g:gtags_ctags_bin, '--version'], {
          \ 'on_stdout': function('s:version_std_out'),
          \ 'on_exit': function('s:version_exit'),
          \ })
    return
  else
    call s:LOGGER.info('update ctags database for ' . project_root)
  endif
  let dir = s:FILE.unify_path(g:tags_cache_dir) 
        \ . s:FILE.path_to_fname(project_root)
  let cmd = [g:gtags_ctags_bin]
  if s:is_u_ctags
    let cmd += ['-G']
  endif
  if !isdirectory(dir)
    if !mkdir(dir, 'p')
      call s:LOGGER.warn('failed to create data databases dir:' . dir)
      " if failed to create databases, then do not run ctags command.
      return
    endif
  endif
  if isdirectory(dir)
    let cmd += ['-R', '--extra=+f', '-o', dir . '/tags', project_root]
    call s:LOGGER.debug('ctags command:' . string(cmd))
    let jobid = s:JOB.start(cmd, {
          \ 'on_stdout' : function('s:on_update_stdout'),
          \ 'on_stderr' : function('s:on_update_stderr'),
          \ 'on_exit' : function('s:on_update_exit')
          \ })
    if jobid <= 0
      call s:LOGGER.debug('failed to start ctags job, return jobid:' . jobid)
    endif
  endif
endfunction

function! s:on_update_stdout(id, data, event) abort
  for line in a:data
    call s:LOGGER.debug('stdout' . line)
  endfor
endfunction

function! s:on_update_stderr(id, data, event) abort
  for line in a:data
    call s:LOGGER.debug('stderr' . line)
  endfor
endfunction

function! s:on_update_exit(id, data, event) abort
  " @bug on exit function is not called when failed
  " C:\Users\wsdjeg\.SpaceVim>C:\Users\wsdjeg\.SpaceVim\bundle\phpcomplete.vim\bin\ctags.exe -R -o C:/Users/wsdjeg/.cache/SpaceVim/tags/C__Users_wsdjeg__SpaceVim_/tags C:\Users\wsdjeg\.SpaceVim
  "
  " C:\Users\wsdjeg\.SpaceVim>echo %ERRORLEVEL%
  " -1073741819
  " https://github.com/neovim/neovim/issues/20856
  if a:data != 0
    call s:LOGGER.warn('failed to update gtags, exit data: ' . a:data)
  else
    call s:LOGGER.info('ctags database updated successfully')
  endif
endfunction
