function! SpaceVim#options#list() abort
    let list = []
    if has('patch-7.4.2010')
        for var in getcompletion('g:spacevim_','var')
            call add(list, var . ' = ' . string(get(g:, var[2:] , '')))
        endfor
    else
        call add(list, 'your vim is too old, getcompletion() need patch7-4-2010')
    endif
    return list
endfunction
