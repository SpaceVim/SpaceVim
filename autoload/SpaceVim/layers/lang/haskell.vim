function! SpaceVim#layers#lang#haskell#plugins() abort
    let plugins = []
    call add(plugins,['neovimhaskell/haskell-vim', { 'on_ft' : 'haskell'}])
    call add(plugins,['pbrisbin/vim-syntax-shakespeare', { 'on_ft' : 'haskell'}])
    call add(plugins,['eagletmt/neco-ghc', { 'on_ft' : 'haskell'}])
    return plugins
endfunction

function! SpaceVim#layers#lang#haskell#config() abort
  let g:haskellmode_completion_ghc = 0

  call SpaceVim#plugins#runner#reg_runner('haskell', ['ghc -v0 --make %s -o #TEMP#', '#TEMP#'])
  call SpaceVim#mapping#space#regesit_lang_mappings('haskell', funcref('s:language_specified_mappings'))

  augroup SpaceVim_lang_haskell
    autocmd!
    autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc 
  augroup END
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
endfunction
