function! SpaceVim#options#list() abort
    let list = []
    if has('patch-7.4.2010') && 0
        for var in getcompletion('g:spacevim_','var')
            call add(list, var . ' = ' . string(get(g:, var[2:] , '')))
        endfor
    else
        for var in filter(map(split(execute('let g:'), "\n"), "matchstr(v:val, '\\S\\+')"), "v:val =~# '^spacevim_'")
            call add(list,'g:' . var . ' = ' . string(get(g:, var , '')))
        endfor
    endif
    return list
endfunction
