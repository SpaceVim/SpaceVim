"=============================================================================
" pmd.vim --- Integrates PMD using Vim quickfix mode
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================


let s:options = {
      \ '-f' : {
      \ 'description' : '',
      \ 'values' : ['text'],
      \ },
      \ '-d' : {
      \ 'description' : 'Root directory for sources',
      \ 'values' : [],
      \ },
      \ }


function! SpaceVim#plugins#pmd#run(...)

  

endfunction


function! SpaceVim#plugins#pmd#complete(...)

return '-f'
endfunction
