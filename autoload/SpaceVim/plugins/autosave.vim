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
      \ 'save_all_buffers' : 0,
      \ 'event' : ['InsertLeave', 'TextChanged']
      \ }

let s:LOGGER =SpaceVim#logger#derive('autosave')

let s:autosave_timer  = -1



function! SpaceVim#plugins#autosave#config(opt) abort
  for option in keys(s:default_opt)
    if has_key(a:opt, option)
      call s:LOGGER.debug('set option `' . option . '` to : ' . string(get(a:opt, option, s:default_opt[option])))
      let s:default_opt[option] = get(a:opt, option, s:default_opt[option])
      if option ==# 'timeoutlen'
        call s:setup_timer(s:default_opt[option])
      endif
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

function! s:auto_dosave(...) abort
  " for nr in range(1, bufnr('$'))
    " call s:save_buffer(nr)
  " endfor
  if s:default_opt.save_all_buffers
    wa
  else
    w
  endif
endfunction

function! s:setup_timer(timeoutlen) abort
  if !has('timers')
    call s:LOGGER.warn('failed to setup timer, needs `+timers` feature!')
    return
  endif
  if a:timeoutlen ==# 0
    call timer_stop(s:autosave_timer)
    call s:LOGGER.debug('disabled autosave timer!')
    return
  endif
  if a:timeoutlen < 1000 || a:timeoutlen > 60 * 100 * 1000
    let msg = "timeoutlen must be given in millisecods and can't be > 100*60*1000 (100 minutes) or < 1000 (1 second)"
    call s:LOGGER.warn(msg)
    return
  endif
  call timer_stop(s:autosave_timer)
  let s:autosave_timer = timer_start(a:timeoutlen, function('s:auto_dosave'), {'repeat': -1})
  if !empty(s:autosave_timer)
    call s:LOGGER.debug('setup new autosave timer, timeoutlen:' . a:timeoutlen)
  endif
endfunction

function! s:setup_events() abort
  augroup spacevim_autosave
    autocmd!
    for event in s:default_opt.event
      exe printf('autocmd %s * call s:auto_dosave()')
    endfor
  augroup END
endfunction

call s:setup_timer(s:default_opt.timeoutlen)
