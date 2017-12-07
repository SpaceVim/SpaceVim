""
" @section lang#rust, layer-lang-rust
" @parentsection layers
" SpaceVim does not load this layer by default. If you are a rust developer,
" you should add `call SpaceVim#layers#load('lang#rust')` to your
" @section(config)
"
" Requirements:
"   
"   1. Racer needs a copy of the rust source. The easiest way to do this is
"       with rustup. Once rustup is installed, download the source with:
" >
"       rustup component add rust-src 
" <
"   2. Install racer:
" >
"       cargo install racer
" <
"   3. Set the RUST_SRC_PATH variable in your .bashrc:
" >
"       RUST_SRC_PATH=~/.multirust/toolchains/<change>/lib/rustlib/src/rust/src
"       export RUST_SRC_PATH
" <
"   4. Add racer to your path, or set the path with:
" >
"       let g:racer_cmd = "/path/to/racer/bin"
" <
"
" @subsection Mappings
" >
"   Mode        Key         Function
"   -----------------------------------------------
"   normal      gd          rust-definition
"   normal      gs          rust-definition-split
"   normal      gx          rust-definition-vertical
"   normal      SPC l d     rust-doc
"   normal      SPC l r     execute current file
" <

function! SpaceVim#layers#lang#rust#plugins() abort
  let plugins = [
        \ ['racer-rust/vim-racer', { 'on_ft' : 'rust' }],
        \ ['rust-lang/rust.vim',   { 'on_ft' : 'rust', 'merged' : 1 }],
        \ ]
  return plugins
endfunction

function! SpaceVim#layers#lang#rust#config() abort
  let g:racer_experimental_completer = 1
  let g:racer_cmd = $HOME . '/.cargo/bin/racer'

  call SpaceVim#mapping#gd#add('rust', function('s:gotodef'))
  call SpaceVim#plugins#runner#reg_runner('rust', ['rustc %s -o #TEMP#', '#TEMP#'])
  call SpaceVim#mapping#space#regesit_lang_mappings('rust', funcref('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  nmap <buffer> gs <Plug>(rust-def-split)
  nmap <buffer> gx <Plug>(rust-def-vertical)

  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'd'], '<Plug>(rust-doc)', 'show documentation', 0)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
endfunction

function! s:gotodef() abort
  if exists('*racer#GoToDefinition')
    call racer#GoToDefinition()
  endif
endfunction
