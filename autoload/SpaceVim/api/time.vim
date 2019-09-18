"=============================================================================
" time.vim --- SpaceVim time API
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
let s:self = {}

" see: man 3 strftime
function! s:self.current_time() abort
  return strftime('%I:%M %p')   
endfunction

function! s:self.current_date() abort
  return strftime('%a %b %d')
endfunction


function! SpaceVim#api#time#get() abort
    return deepcopy(s:self)
endfunction
