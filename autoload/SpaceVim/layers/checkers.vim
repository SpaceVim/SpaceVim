""
" @section checkers, layer-checkers
" @parentsection layers
" SpaceVim uses neomake as default syntax checker.

function! SpaceVim#layers#checkers#plugins() abort
    let plugins = []

    if g:spacevim_enable_neomake
        call add(plugins, ['neomake/neomake', {'merged' : 0, 'loadconf' : 1 , 'loadconf_before' : 1}])
    else
        call add(plugins, ['wsdjeg/syntastic', {'on_event': 'WinEnter', 'loadconf' : 1, 'merged' : 0}])
    endif

    return plugins
endfunction
