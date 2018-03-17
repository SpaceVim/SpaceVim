"=============================================================================
" fzf.vim --- fzf layer for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#fzf#plugins() abort
  let plugins = []
  call add(plugins, ['junegunn/fzf',                { 'on_cmd' : 'FZF'}])
  return plugins
endfunction


function! SpaceVim#layers#fzf#config() abort
  
endfunction
