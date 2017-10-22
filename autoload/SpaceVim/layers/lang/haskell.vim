function! SpaceVim#layers#lang#haskell#plugins() abort
    let plugins = []
    call add(plugins,['neovimhaskell/haskell-vim', { 'on_ft' : 'haskell'}])
    call add(plugins,['pbrisbin/vim-syntax-shakespeare', { 'on_ft' : 'haskell'}])
    call add(plugins,['eagletmt/neco-ghc', { 'on_ft' : 'haskell'}])
    return plugins
endfunction

function! SpaceVim#layers#lang#haskell#config() abort
  let g:haskellmode_completion_ghc = 0

  augroup SpaceVim_lang_haskell
    autocmd!
    autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc 
  augroup END
endfunction
