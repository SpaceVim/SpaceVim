let s:gd = {}
function! SpaceVim#mapping#gd#add(ft, func) abort
    call extend(s:gd,{a:ft : a:func})
endfunction

function! SpaceVim#mapping#gd#get() abort
    return get(s:gd, &filetype, '')
endfunction
