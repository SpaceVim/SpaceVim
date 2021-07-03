"=============================================================================
" version.vim --- Version checking API
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:self = {}


function! SpaceVim#api#neovim#version#get() abort

  return deepcopy(s:self)

endfunction
