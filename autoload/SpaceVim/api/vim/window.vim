"=============================================================================
" window.vim --- window api for vim and neovim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:self = {}

if exists('*nvim_win_get_cursor')
  function! s:self.get_cursor(winid) abort
    return nvim_win_get_cursor(a:winid)
  endfunction
elseif has('lua')
  function! s:self.get_cursor(winid) abort
        lua local winindex = vim.eval("win_id2win(a:winid) - 1")
        lua local w = vim.window(winindex)
        return [float2nr(luaeval('w.line')), float2nr(luaeval('w.col'))]
  endfunction
else
  function! s:self.get_cursor(winid) abort

  endfunction
endif


function! SpaceVim#api#vim#window#get() abort
  return deepcopy(s:self)
endfunction
