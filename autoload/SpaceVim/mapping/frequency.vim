"=============================================================================
" frequency.vim --- key frequency plugin
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:data = {}

function! SpaceVim#mapping#frequency#update(key, rhs) abort
    if has_key(s:data, a:key)
        let s:data[a:key] += 1
    else
        let s:data[a:key] = 1
    endif
    return a:rhs
endfunction

function! SpaceVim#mapping#frequency#view(keys) abort
    if type(a:keys) == 1
        echo 'The frequency of ' . a:keys . ' is ' . s:get(a:keys)
    elseif type(a:keys) == 3
        for key in a:keys
            call SpaceVim#mapping#frequency#view(key)
        endfor
    endif
endfunction
function! SpaceVim#mapping#frequency#viewall() abort
    echo string(s:data)
endfunction

function! s:get(key) abort
    if has_key(s:data, a:key)
        return s:data[a:key]
    else
        return 0
    endif
endfunction
