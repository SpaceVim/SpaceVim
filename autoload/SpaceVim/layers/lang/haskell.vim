"=============================================================================
" haskell.vim --- SpaceVim lang#haskell layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#haskell#plugins() abort
  let plugins = [
        \ ['neovimhaskell/haskell-vim', { 'on_ft': 'haskell' }],
        \ ['pbrisbin/vim-syntax-shakespeare', { 'on_ft': 'haskell' }],
        \ ]

  if SpaceVim#layers#lsp#check_filetype('haskell')
    call add(plugins, ['eagletmt/neco-ghc', { 'on_ft': 'haskell' }])
  endif

  return plugins
endfunction

function! SpaceVim#layers#lang#haskell#config() abort
  let g:haskellmode_completion_ghc = 0

  call SpaceVim#plugins#runner#reg_runner('haskell', [
        \ 'ghc -v0 --make %s -o #TEMP#',
        \ '#TEMP#'])
  call SpaceVim#mapping#space#regesit_lang_mappings('haskell',
        \ function('s:on_ft'))

  if SpaceVim#layers#lsp#check_filetype('haskell')
    call SpaceVim#mapping#gd#add('haskell',
          \ function('SpaceVim#lsp#go_to_def'))
  endif

  augroup SpaceVim_lang_haskell
    autocmd!

  if SpaceVim#layers#lsp#check_filetype('haskell')
      autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
    endif
  augroup END
endfunction

function! s:on_ft() abort
  if SpaceVim#layers#lsp#check_filetype('haskell')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show_document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
  endif

  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'r'],
        \ 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
endfunction
