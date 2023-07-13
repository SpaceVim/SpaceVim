"=============================================================================
" window.vim --- window api for vim and neovim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section vim#window, api-vim-window
" @parentsection api
" @subsection Intro
"
" `vim#window` API provides some basic functions for setting and getting config
" of vim window.
"
" @subsection Functions
"
" get_cursor({winid})
" 
"   Gets the cursor position in the window {winid}, to get the ID of a window,
" checkout |window-ID|.
"
" set_cursor({winid}, {pos})
" 
"   Sets the cursor position to {pos} in the window {winid}.
"
" is_float({winid})
"
"   Check if the window is a floating windows, return `v:true` if the window
"   is a floating window.
"
" winexists({winid})
"
"   Check if the window with {winid} exists in current tabpage.

let s:self = {}

if exists('*nvim_win_get_cursor')
  function! s:self.get_cursor(winid) abort
    return nvim_win_get_cursor(a:winid)
  endfunction
elseif get(g:, '_spacevim_if_lua', 0)
  function! s:self.get_cursor(winid) abort
    lua require("spacevim.api.vim.window").get_cursor(vim.eval("a:winid"))
  endfunction
else
  function! s:self.get_cursor(winid) abort

  endfunction
endif

if exists('*nvim_win_set_cursor')
  function! s:self.set_cursor(winid, pos) abort
    return nvim_win_set_cursor(a:winid, a:pos)
  endfunction
elseif exists('*win_execute')
  function! s:self.set_cursor(win, pos) abort
    " @fixme use g` to move to cursor line
    " this seem to be a bug of vim
    " https://github.com/vim/vim/issues/5022
    call win_execute(a:win, ':call cursor(' . a:pos[0] . ', ' . a:pos[1] . ')')
    " call win_execute(a:win, ':' . a:pos[0])
    call win_execute(a:win, ':normal! g"')
  endfunction
elseif get(g:, '_spacevim_if_lua', 0)
  function! s:self.set_cursor(winid, pos) abort
    lua require("spacevim.api.vim.window").set_cursor(vim.eval("a:winid"), vim.eval("a:pos"))
  endfunction
else
  function! s:self.set_cursor(winid, pos) abort
  endfunction
endif

if has('nvim')
  function! s:self.is_float(winid) abort
    if a:winid > 0 && exists('*nvim_win_get_config')
      try
        return has_key(nvim_win_get_config(a:winid), 'col')
      catch
        return 0
      endtry
    else
      return 0
    endif
  endfunction
else
  function! s:self.is_float(winid) abort
    if a:winid > 0 && exists('*popup_getoptions')
      try
        return has_key(popup_getoptions(a:winid), 'col')
      catch /^Vim\%((\a\+)\)\=:E993/
        return 0
      endtry
    else
      return 0
    endif
  endfunction
endif

function! s:self.win_count() abort
  if has('nvim') && exists('*nvim_win_get_config')
    return len(filter(range(1, winnr('$')), '!has_key(nvim_win_get_config(win_getid(v:val)), "col")'))
  else
    return winnr('$')
  endif
endfunction

function! s:self.winexists(winid) abort
  if !exists('win_id2tabwin')
    return 0
  endif
  return win_id2tabwin(a:winid)[0] == tabpagenr()
endfunction

function! SpaceVim#api#vim#window#get() abort
  return deepcopy(s:self)
endfunction
