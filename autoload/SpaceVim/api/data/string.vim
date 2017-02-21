let s:file = {}

function! s:trim(str) abort
    let str = substitute(a:str, '\s*$', '', 'g')
    return substitute(str, '^\s*', '', 'g')
endfunction

let s:file['trim'] = function('s:trim')

function! s:trim_start(str) abort
    return substitute(a:str, '^\s*', '', 'g')
endfunction

let s:file['trim_start'] = function('s:trim_start')

function! s:trim_end(str) abort
    return substitute(a:str, '\s*$', '', 'g')
endfunction

let s:file['trim_end'] = function('s:trim_end')

function! SpaceVim#api#data#string#get() abort
    return deepcopy(s:file)
endfunction



