"=============================================================================
" rust.vim --- SpaceVim lang#rust layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


""
" @section lang#rust, layer-lang-rust
" @parentsection layers
" This layer is for Rust development. 
"
" Requirements:
"   
"   1. Racer needs a copy of the rust source. The easiest way to do this is
"       with rustup. Once rustup is installed, download the source with:
" >
"       rustup component add rust-src 
" <
"   2. Install Rust nightly build
"       
" >
"       rustup install nightly
" <
"   3. Install racer:
" >
"       cargo +nightly install racer
" <
"   4. Set the RUST_SRC_PATH variable in your .bashrc:
" >
"       RUST_SRC_PATH=~/.multirust/toolchains/<change>/lib/rustlib/src/rust/src
"       export RUST_SRC_PATH
" <
"   5. Add racer to your path, or set the path with:
" >
"       let g:racer_cmd = "/path/to/racer/bin"
" <
"
" @subsection Mappings
" >
"   Mode        Key         Function
"   -----------------------------------------------
"   normal      gd          rust-definition
"   normal      SPC l d     rust-doc
"   normal      SPC l r     execute current file
"   normal      SPC l s     rust-def-split
"   normal      SPC l x     rust-def-vertical
" <

function! SpaceVim#layers#lang#rust#plugins() abort
  let plugins = [
        \ ['racer-rust/vim-racer', { 'on_ft' : 'rust' }],
        \ ['rust-lang/rust.vim',   { 'on_ft' : 'rust', 'merged' : 1 }],
        \ ]
  return plugins
endfunction

let s:recommended_style = 0

function! SpaceVim#layers#lang#rust#config() abort
  let g:racer_experimental_completer = 1
  let g:racer_cmd = get(g:, 'racer_cmd', $HOME . '/.cargo/bin/racer')
  let g:rust_recommended_style = s:recommended_style
  if SpaceVim#layers#lsp#check_filetype('rust')
    call SpaceVim#mapping#gd#add('rust',
          \ function('SpaceVim#lsp#go_to_def'))
  else
    call SpaceVim#mapping#gd#add('rust', function('s:gotodef'))
  endif

  let runner = {
        \ 'exe' : 'rustc',
        \ 'targetopt' : '-o',
        \ 'opt' : ['-'],
        \ 'usestdin' : 1,
        \ }
  call SpaceVim#plugins#runner#reg_runner('rust', [runner, '#TEMP#'])
  call SpaceVim#mapping#space#regesit_lang_mappings('rust',
        \ function('s:language_specified_mappings'))
endfunction

function! SpaceVim#layers#lang#rust#set_variable(var) abort

  let s:recommended_style = get(a:var,
        \ 'recommended-style',
        \ s:recommended_style)

endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 's'],
        \ '<Plug>(rust-def-split)', 'rust-def-split', 0)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'x'],
        \ '<Plug>(rust-def-vertical)', 'rust-def-vertical', 0)

  if SpaceVim#layers#lsp#check_filetype('rust')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show documentation', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'c'],
          \ 'call SpaceVim#lsp#references()', 'show references', 1)
  else
    nmap <silent><buffer> K <Plug>(rust-doc)
    call SpaceVim#mapping#space#langSPC('nmap', ['l', 'd'],
          \ '<Plug>(rust-doc)', 'show documentation', 1)
  endif

  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'r'],
        \ 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
endfunction

function! s:gotodef() abort
  if exists('*racer#GoToDefinition')
    call racer#GoToDefinition()
  endif
endfunction
