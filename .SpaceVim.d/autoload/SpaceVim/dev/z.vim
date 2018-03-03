"=============================================================================
" z.vim --- Script for generate doc of z key bindings
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
function! SpaceVim#dev#z#updatedoc() abort
 let keys = keys(g:_spacevim_mappings_z)
 let lines = []
 for key in keys
     if key ==# '`'
         let line = '`` z' . key . ' `` | ' . g:_spacevim_mappings_z[key][1]
     else
         let line = '`z' . key . '` | ' . g:_spacevim_mappings_z[key][1]
     endif
     call add(lines, line)
 endfor
 call append(line('.'), lines)
endfunction
