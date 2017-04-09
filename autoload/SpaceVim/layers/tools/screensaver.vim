function! SpaceVim#layers#tools#screensaver#plugins() abort
    let plugins = []
    call add(plugins, ['itchyny/screensaver.vim', {'merged' : 0}])
    return plugins
endfunction
