function! SpaceVim#layers#operator#plugins() abort
    let plugins = []
    call add(plugins, ['kana/vim-operator-user', { 'merged' : 0 }])
    call add(plugins, ['haya14busa/vim-operator-flashy', { 'merged' : 0 }])
    return plugins
endfunction
