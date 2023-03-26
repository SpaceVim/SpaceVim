"=============================================================================
" version.vim --- Version checking API
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:self = {}
let s:self.__cmp = SpaceVim#api#import('vim#compatible')

function! s:self.is_release_version() abort
  let nvim_version = split(self.__cmp.execute('version'), '\n')[0]
  return nvim_version =~# 'NVIM v\d\.\d\.\d$'
endfunction


function! SpaceVim#api#neovim#version#get() abort

  return deepcopy(s:self)

endfunction
