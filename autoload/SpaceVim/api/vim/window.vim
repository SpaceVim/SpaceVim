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
        return [float2nr(luaeval('require("spacevim.api.vim.window").get_cursor(vim.eval("a:winid"))[1]')),
                    \ float2nr(luaeval('require("spacevim.api.vim.window").get_cursor(vim.eval("a:winid"))[2]'))]
  endfunction
else
  function! s:self.get_cursor(winid) abort

  endfunction
endif


function! SpaceVim#api#vim#window#get() abort
  return deepcopy(s:self)
endfunction
