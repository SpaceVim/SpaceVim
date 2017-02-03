function! SpaceVim#layers#lang#elixir#plugins() abort
    let plugins = []
    call add(plugins, ['slashmili/alchemist.vim', {'on_ft' : 'elixir'}])
    return plugins
endfunction
