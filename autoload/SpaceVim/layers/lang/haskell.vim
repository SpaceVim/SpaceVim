function! SpaceVim#layers#lang#haskell#plugins() abort
    let plugins = []
    call add(plugins,['neovimhaskell/haskell-vim', { 'on_ft' : 'haskell'}])
    call add(plugins,['pbrisbin/vim-syntax-shakespeare', { 'on_ft' : 'haskell'}])
    call add(plugins,['eagletmt/neco-ghc', { 'on_ft' : 'haskell'}])
    return plugins
endfunction
