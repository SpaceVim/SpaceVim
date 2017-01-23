function! SpaceVim#options#list() abort
    let list = []
    for var in getcompletion('g:spacevim_','var')
        call add(list, var . " = " . string(get(g:, var[2:] , '')))
    endfor
    return list
endfunction
