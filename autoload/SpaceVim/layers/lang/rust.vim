""
" @section layer-lang-rust, layer-lang-rust
" requirement:
"   1. racer : cargo install racer
"   2. export RUST_SRC_PATH : 
"       you can download src by : rustup component add rust-src, and add below
"       into your bashrc.
"
" export RUST_SRC_PATH=~/.multirust/toolchains/[your-toolchain]/lib/rustlib/src/rust/src
"
" configuration:
"   1. add `let g:racer_cmd = "/path/to/racer/bin"` in to custom config, if
"   you has racer executable in you PATH. g:racer_cmd should be auto detect.
"
" mappings:
" >
"   mode        key         function
"   normal      gd          rust-definition
"   normal      gs          rust-definition-split
"   normal      gx          rust-definition-vertical
"   normal      <leader>gd  rust-doc
" <

function! SpaceVim#layers#lang#rust#plugins() abort
    let plugins = []
    call add(plugins, ['racer-rust/vim-racer',                   { 'on_ft' : 'rust'}])
    call add(plugins, ['rust-lang/rust.vim',            {'merged' : 1}])
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
