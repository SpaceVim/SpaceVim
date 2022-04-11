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
      \ 'event' : ['InsertLeave', 'TextChanged'],
      \ 'filetype' : [],
      \ 'filetypeExclude' : [],
      \ 'buftypeExclude' : [],
      \ 'bufNameExclude' : [],
      \ }

let s:LOGGER =SpaceVim#logger#derive('autosave')
let s:FILE = SpaceVim#api#import('file')

let s:autosave_timer  = -1



function! SpaceVim#plugins#autosave#config(opt) abort
  for option in keys(s:default_opt)
    if has_key(a:opt, option)
      call s:LOGGER.debug('set option `' . option . '` to : ' . string(get(a:opt, option, s:default_opt[option])))
      let s:default_opt[option] = get(a:opt, option, s:default_opt[option])
      if option ==# 'timeoutlen'
        call s:setup_timer(s:default_opt[option])
      elseif option ==# 'event'
        call s:setup_events()
      endif
    endif
  endfor
endfunction

function! s:location_path(bufname) abort
  if empty(s:default_opt.backupdir)
    return a:bufname
  else
    return s:default_opt.backupdir . '/'
          \ . s:FILE.path_to_fname(a:bufname, '+=')
          \ . '.backup'
  endif
endfunction


function! s:save_buffer(bufnr) abort
  if getbufvar(a:bufnr, '&modified') &&
        \ empty(getbufvar(a:bufnr, '&buftype')) &&
        \ filewritable(bufname(a:bufnr)) &&
        \ !empty(bufname(a:bufnr))
    let lines = getbufline(a:bufnr, 1, "$")
    call writefile(lines, s:location_path(bufname(a:bufnr)))
    if empty(s:default_opt.backupdir)
      call setbufvar(a:bufnr, "&modified", 0)
      exe 'silent checktime ' . a:bufnr
    endif
  endif
endfunction


function! s:auto_dosave(...) abort
  if s:default_opt.save_all_buffers
    for nr in range(1, bufnr('$'))
      call s:save_buffer(nr)
    endfor
  else
    call s:save_buffer(bufnr('%'))
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
      exe printf('autocmd %s * call s:auto_dosave()', event)
      call s:LOGGER.debug('setup new autosave autocmd, event:' . event)
    endfor
  augroup END
endfunction

call s:setup_timer(s:default_opt.timeoutlen)
call s:setup_events()
