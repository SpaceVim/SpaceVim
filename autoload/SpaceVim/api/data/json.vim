let s:json = {}

function! s:json_encode(expr) abort
    " TODO
    " support old vim version
    return json_encode(a:expr)
endfunction

let s:json['json_encode'] = function('s:json_encode')

function! s:json_decode(json) abort
    " TODO
    " support old vim version
    return json_decode(a:json)
endfunction

let s:json['json_decode'] = function('s:json_decode')


function! SpaceVim#api#data#json#get() abort
    return deepcopy(s:json)
endfunction
