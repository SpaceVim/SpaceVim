function! SpaceVim#layers#tools#screensaver#plugins() abort
    let plugins = []
    call add(plugins, ['SpaceVim/screensaver.vim', {'merged' : 0}])
    call add(plugins, ['t9md/vim-choosewin', {'merged' : 0}])
    return plugins
endfunction
