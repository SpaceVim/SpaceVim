function! SpaceVim#layers#format#plugins() abort
    return [
                \ ['sbdchd/neoformat', {'merged' : 0, 'loadconf' : 1 , 'loadconf_before' : 1}],
                \ ]
endfunction
