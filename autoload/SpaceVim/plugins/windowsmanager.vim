"=============================================================================
" windowsmanager.vim --- windows manager for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:TAB = SpaceVim#api#import('vim#tab')

let s:restore_windows_stack = []

let s:redo_stack = []

let s:unmarked = 0


function! s:get_window_restore_data() abort
  let win_data = {
        \ 'bufname':  fnamemodify(bufname('%'), ':p'),
        \ 'tabpagenr': tabpagenr(),
        \ 'view':      winsaveview(),
        \ 'newtab':0,
        \ 'oldwinid' : -1,
        \ 'same_w' : 0,
        \ }
  return win_data
endfunction

function! SpaceVim#plugins#windowsmanager#UpdateRestoreWinInfo() abort
  if !&buflisted
    if &buftype ==# 'terminal'
      noautocmd q
    endif
    return
  endif
  let s:unmarked = 1
  let win_data = s:get_window_restore_data()
  if len(tabpagebuflist()) == 1
    let win_data.newtab = 1
    let win_data.open_command     = (tabpagenr() - 1).'tabnew'
  else
    if winwidth(winnr()) == &columns
      let win_data.same_w = 1
    endif
    let win_data.oldwinid = winnr()
  endif
  call add(s:restore_windows_stack, win_data)
  let s:redo_stack = []
endfunction

function! SpaceVim#plugins#windowsmanager#UndoQuitWin() abort
  if empty(s:restore_windows_stack)
    return
  endif
  let win_data = remove(s:restore_windows_stack, -1)
  if win_data.newtab
    exe win_data.open_command . ' ' . win_data.bufname
  else
    exe win_data.open_command
  endif
  call add(s:redo_stack, [tabpagenr(), winnr()])
endfunction

function! SpaceVim#plugins#windowsmanager#RedoQuitWin() abort
  if !empty(s:redo_stack)
    let [tabpage, winnr] = remove(s:redo_stack, -1)
    exe 'tabnext' . tabpage
    exe winnr .  'wincmd w'
    quit
  endif
endfunction

function! SpaceVim#plugins#windowsmanager#MarkBaseWin() abort
  if s:unmarked
    let win_data = s:restore_windows_stack[-1]
    if win_data.same_w
      " split
      if win_data.oldwinid == winnr()
        let win_data.open_command = 'topleft split ' . win_data.bufname
      else
        let win_data.open_command = 'rightbelow split ' . win_data.bufname
      endif
    else
      " vsplit
      if win_data.oldwinid == winnr()
        let win_data.open_command = 'topleft vsplit ' . win_data.bufname
      else
        let win_data.open_command = 'rightbelow vsplit ' . win_data.bufname
      endif
    endif
    let s:unmarked = 0
  endif
endfunction
