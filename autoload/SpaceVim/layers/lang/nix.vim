"=============================================================================
" nix.vim --- nix language support for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Ben Gamari <ben@smart-cactus.org>
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#nix, layers-lang-nix
" @parentsection layers
" @subsection Intro
" The lang#nix layer provides syntax highlighting and basic LSP support for
" the Nix expression language.

function! SpaceVim#layers#lang#nix#plugins() abort
  let plugins = []
  call add(plugins, ['LnL7/vim-nix', {'on_ft' : ['nix']}])
  return plugins
endfunction

function! SpaceVim#layers#lang#nix#config() abort
  call SpaceVim#mapping#space#regesit_lang_mappings('nix', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  if SpaceVim#layers#lsp#check_filetype('nix')
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'r'],
          \ 'call SpaceVim#lsp#rename()', 'rename', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 's'],
          \ 'call SpaceVim#lsp#show_line_diagnostics()', 'show-line-diagnostics', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#go_to_def()', 'go-to-definition', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'n'],
         \ 'call SpaceVim#lsp#diagnostic_goto_next()', 'next-diagnostic', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'p'],
         \ 'call SpaceVim#lsp#diagnostic_goto_prev()', 'previous-diagnostic', 1)
 endif
endfunction

function! SpaceVim#layers#lang#nix#health() abort
  call SpaceVim#layers#lang#nix#plugins()
  call SpaceVim#layers#lang#nix#config()
  return 1
endfunction

