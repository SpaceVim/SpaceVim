"=============================================================================
" window.vim --- window api for vim and neovim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section vim#buffer, api-vim-window
" @parentsection api
" @subsection Intro
"
" vim#window API provides some basic functions for setting and getting config
" of vim window.
"
" @subsection Functions
"
" get_cursor({winid})
" 
" Gets the cursor position in the window {winid}, to get the ID of a window,
" checkout |window-ID|.

let s:self = {}

if exists('*nvim_win_get_cursor')
  function! s:self.get_cursor(winid) abort
    return nvim_win_get_cursor(a:winid)
  endfunction
elseif g:_spacevim_if_lua
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
elseif g:_spacevim_if_lua
  function! s:self.set_cursor(winid, pos) abort
        lua require("spacevim.api.vim.window").set_cursor(vim.eval("a:winid"), vim.eval("a:pos"))
  endfunction
else
endif


function! SpaceVim#api#vim#window#get() abort
  return deepcopy(s:self)
endfunction
