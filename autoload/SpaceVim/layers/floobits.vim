"=============================================================================
" floobits.vim --- SpaceVim floobits layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#floobits#plugins() abort
  let plugins = [
        \ ['floobits/floobits-neovim',      { 'on_cmd' : ['FlooJoinWorkspace','FlooShareDirPublic','FlooShareDirPrivate']}],
        \ ]
  return plugins
endfunction 


function! SpaceVim#layers#floobits#config() abort
  
endfunction
