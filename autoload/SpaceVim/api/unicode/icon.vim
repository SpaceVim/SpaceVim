"=============================================================================
" icon.vim --- SpaceVim icon API
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8
let s:self = {}

function! s:self.battery_status(v) abort
  if a:v >= 90
    return ''
  elseif a:v >= 75
    return ''
  elseif a:v >= 50
    return ''
  elseif a:v >= 25
    return ''
  else
    return ''
  endif
endfunction

function! SpaceVim#api#unicode#icon#get() abort

  return deepcopy(s:self)

endfunction
