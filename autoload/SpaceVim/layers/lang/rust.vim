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
"   normal      SPC l s     rust-def-split
"   normal      SPC l x     rust-def-vertical
"   normal      SPC l f     rustfmt-format
"   normal      SPC l e     rls-rename-symbol
"   normal      SPC l u     rls-show-references
"   normal      SPC l c b   cargo-build
"   normal      SPC l c c   cargo-clean
"   normal      SPC l c f   cargo-fmt
"   normal      SPC l c t   cargo-test
"   normal      SPC l c u   cargo-update
"   normal      SPC l c B   cargo-bench
"   normal      SPC l c D   cargo-docs
"   normal      SPC l c r   cargo-run
" <

function! SpaceVim#layers#lang#rust#plugins() abort
  let plugins = [
        \ ['rust-lang/rust.vim',   { 'on_ft' : 'rust', 'merged' : 0 }],
        \ ]
  if !SpaceVim#layers#lsp#check_filetype('rust')
    call add(plugins, ['racer-rust/vim-racer', {'merged' : 0}])
  endif
  return plugins
endfunction

function! SpaceVim#layers#lang#rust#config() abort
  call SpaceVim#plugins#runner#reg_runner('rust', [
        \ 'rustc %s -o #TEMP#',
        \ '#TEMP#'])
  call SpaceVim#plugins#repl#reg('rust', 'evcxr')
  " let g:racer_experimental_completer = 1
  let g:racer_cmd = s:racer_cmd ==# ''
        \ ? get(g:, 'racer_cmd', $HOME . '/.cargo/bin/racer')
        \ : s:racer_cmd
  let g:rustfmt_cmd = s:rustfmt_cmd ==# ''
        \ ? get(g:, 'rustfmt_cmd', $HOME . '/.cargo/bin/rustfmt')
        \ : s:rustfmt_cmd
  let g:rust_recommended_style = s:recommended_style
  let g:rustfmt_autosave = s:format_autosave

  call SpaceVim#mapping#space#regesit_lang_mappings('rust', function('s:language_specified_mappings'))
  call add(g:spacevim_project_rooter_patterns, 'Cargo.toml')

  if SpaceVim#layers#lsp#check_filetype('rust')
    call SpaceVim#mapping#gd#add('rust', function('SpaceVim#lsp#go_to_def'))
  else
    call SpaceVim#mapping#gd#add('rust', function('s:gotodef'))
  endif
endfunction

let s:recommended_style = 0
let s:format_autosave = 0
let s:racer_cmd = ''
let s:rustfmt_cmd = ''
function! SpaceVim#layers#lang#rust#set_variable(var) abort
  let s:recommended_style = get(a:var, 'recommended-style', s:recommended_style)
  let s:format_autosave = get(a:var, 'format-autosave', s:format_autosave)
  let s:racer_cmd = get(a:var, 'racer-cmd', s:racer_cmd)
  let s:rustfmt_cmd = get(a:var, 'rustfmt-cmd', s:rustfmt_cmd)
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 's'],
        \ '<Plug>(rust-def-split)', 'rust-def-split', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'x'],
        \ '<Plug>(rust-def-vertical)', 'rust-def-vertical', 0)

  let g:_spacevim_mappings_space.l.c = {'name' : '+Cargo'}
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'r'], 'call call('
        \ . string(function('s:execCMD')) . ', ["cargo run"])',
        \ 'cargo-run', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'b'], 'call call('
        \ . string(function('s:execCMD')) . ', ["cargo build"])',
        \ 'cargo-build', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'c'], 'call call('
        \ . string(function('s:execCMD')) . ', ["cargo clean"])',
        \ 'cargo-clean', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 't'], 'call call('
        \ . string(function('s:execCMD')) . ', ["cargo test"])',
        \ 'cargo-test', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'u'], 'call call('
        \ . string(function('s:execCMD')) . ', ["cargo update"])',
        \ 'update-external-dependencies', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'B'], 'call call('
        \ . string(function('s:execCMD')) . ', ["cargo bench"])',
        \ 'run the benchmarks', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'D'], 'call call('
        \ . string(function('s:execCMD')) . ', ["cargo doc"])',
        \ 'build-docs', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c', 'f'], 'call call('
        \ . string(function('s:execCMD')) . ', ["cargo fmt"])',
        \ 'format project files', 1)

  if SpaceVim#layers#lsp#check_filetype('rust')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show documentation', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'u'],
          \ 'call SpaceVim#lsp#references()', 'show references', 1)
  else
    nmap <silent><buffer> K <Plug>(rust-doc)
    call SpaceVim#mapping#space#langSPC('nmap', ['l', 'd'],
          \ '<Plug>(rust-doc)', 'show documentation', 1)
  endif
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("rust")',
        \ 'start REPL process', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'l'],
        \ 'call SpaceVim#plugins#repl#send("line")',
        \ 'send line and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'b'],
        \ 'call SpaceVim#plugins#repl#send("buffer")',
        \ 'send buffer and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 's'],
        \ 'call SpaceVim#plugins#repl#send("selection")',
        \ 'send selection and keep code buffer focused', 1)
endfunction

function! s:gotodef() abort
  try
    call racer#GoToDefinition()
  catch
    exec 'normal! gd'
  endtry
endfunction

function! s:execCMD(cmd) abort
  call SpaceVim#plugins#runner#open(a:cmd)
endfunction

"
"#用于更新 toolchain
"
" set RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
"
" #用于更新 rustup
"
" set RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
"
" vim:set et sw=2 cc=80
