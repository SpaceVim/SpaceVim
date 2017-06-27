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
"   normal      <leader>gd  rust-doc
" <

function! SpaceVim#layers#lang#rust#plugins() abort
    let plugins = []
    call add(plugins, ['racer-rust/vim-racer', {'on_ft' : 'rust'}])
    call add(plugins, ['rust-lang/rust.vim', {'on_ft' : 'rust', 'merged' : 1}])
    return plugins
endfunction

function! SpaceVim#layers#lang#rust#config() abort
    let g:racer_experimental_completer = 1
    let g:racer_cmd = $HOME.'/.cargo/bin/racer'
    augroup spacevim_layer_lang_rust
        au FileType rust nmap <buffer><silent> gd <Plug>(rust-def)
        au FileType rust nmap <buffer><silent> gs <Plug>(rust-def-split)
        au FileType rust nmap <buffer><silent> gx <Plug>(rust-def-vertical)
        au FileType rust nmap <buffer><silent> <leader>gd <Plug>(rust-doc)
    augroup END
endfunction
