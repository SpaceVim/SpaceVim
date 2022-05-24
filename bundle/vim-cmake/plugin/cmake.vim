"=============================================================================
" cmake.vim --- cmake plugin
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


command! -nargs=* Cmake call cmake#run(<q-args>)


function! cmake#run(str) abort
  call SpaceVim#plugins#runner#open('cmake ' . a:str)
endfunction
