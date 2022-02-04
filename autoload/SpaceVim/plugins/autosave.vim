"=============================================================================
" autosave.vim --- autosave plugin for spacevim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" this plugin is inspired from:
" https://github.com/907th/vim-auto-save
" https://github.com/Pocco81/AutoSave.nvim
" These plugins are simply run `:w` or `:wa` based on save_all_buffers option
" 
"
" https://github.com/chrisbra/vim-autosave
" This plugin uses timers to automatically save your work as temporary files.


let s:default_opt = {
      \ 'timeoutlen' : 60*5*1000,
      \ 'backupdir' : '~/.cache/SpaceVim/backup/',
      \ 'event' : ['InsertLeave', 'TextChanged']
      \ }

let s:LOGGER =SpaceVim#logger#derive('autosave')



function! SpaceVim#plugins#autosave#config(opt) abort
  for option in keys(s:default_opt)
    if has_key(a:opt, option)
      call s:LOGGER.debug('set option `' . option . '` to : ' . string(get(a:opt, option, s:default_opt[option])))
      let s:default_opt[option] = get(a:opt, option, s:default_opt[option])
    endif
  endfor
endfunction

function! s:save_buffer(bufnr) abort
  if !bufexists(a:bufnr)
    return
  endif
  if !getbufvar(a:bufnr, '&modified') ||
        \  !empty(getbufvar(a:bufnr, '&buftype')) ||
        \  getbufvar(a:bufnr, 'autosave_disabled', 0)
    return
  endif
endfunction

function! s:auto_dosave(timer) abort
  for nr in range(1, bufnr('$'))
    call s:save_buffer(nr)
  endfor
endfunction

function! s:setup_timer(timeoutlen) abort
  
endfunction

call s:setup_timer(s:default_opt.timeoutlen)
