function! SpaceVim#layers#games#plugins() abort
    let plugins = []
    call add(plugins, ['wsdjeg/2048.vim', {'merged' : 0}])
    return plugins
endfunction

function! SpaceVim#layers#games#config() abort
    let g:_spacevim_mappings_space.g = {'name' : '+Games'}
    call SpaceVim#mapping#space#def('nnoremap', ['g', '2'], 'call vim2048#start()', '2048-in-vim', 1)
endfunction
