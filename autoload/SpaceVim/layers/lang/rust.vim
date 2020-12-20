"=============================================================================
" rust.vim --- SpaceVim lang#rust layer
" Copyright (c) 2016-2020 Wang Shidong & Contributors
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
"   rustup component add rust-src 
" <
"   2. Install Rust nightly build
" >
"   rustup install nightly
" <
"   3. Install racer:
" >
"   cargo +nightly install racer
" <
"   4. Set the RUST_SRC_PATH variable in your .bashrc:
" >
"   RUST_SRC_PATH=~/.multirust/toolchains/<change>/lib/rustlib/src/rust/src
"   export RUST_SRC_PATH
" <
"   5. Add racer to your path, or set the path with:
" >
"   [[layers]]
"     name = 'lang#rust'
"     racer_cmd = "/path/to/racer/bin"
" <
"
" @subsection Mappings
" >
"   Key         Function
"   -----------------------------------------------
"   g d         rust-definition
"   SPC l d     rust-doc
"   SPC l r     run current file
"   SPC l e     rls-rename-symbol
"   SPC l u     rls-show-references
"   SPC l c b   cargo-build
"   SPC l c c   cargo-clean
"   SPC l c f   cargo-fmt
"   SPC l c t   cargo-test
"   SPC l c u   cargo-update
"   SPC l c B   cargo-bench
"   SPC l c D   cargo-docs
"   SPC l c r   cargo-run
" <
"
" This layer also provides REPL support for rust, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

if exists('s:racer_cmd')
  finish
else
  let s:recommended_style = 0
  let s:format_on_save = 0
  let s:racer_cmd = 'racer'
  let s:rustfmt_cmd = 'rustfmt'
endif

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

  let g:racer_cmd = s:racer_cmd
  let g:rustfmt_cmd = s:rustfmt_cmd
  let g:rust_recommended_style = s:recommended_style
  " Disable racer format, use Neoformat instead!
  let g:rustfmt_autosave = 0
  if s:format_on_save
    call SpaceVim#layers#format#add_filetype({
          \ 'filetype' : 'rust',
          \ 'enable' : 1,
          \ })
  endif


  call SpaceVim#mapping#space#regesit_lang_mappings('rust', function('s:language_specified_mappings'))
  call add(g:spacevim_project_rooter_patterns, 'Cargo.toml')

  if SpaceVim#layers#lsp#check_filetype('rust')
    call SpaceVim#mapping#gd#add('rust', function('SpaceVim#lsp#go_to_def'))
  else
    call SpaceVim#mapping#gd#add('rust', function('s:gotodef'))
  endif
endfunction

function! SpaceVim#layers#lang#rust#set_variable(var) abort
  " support old option recommended-style and recommended_style
  let s:recommended_style = get(a:var, 'recommended_style',
        \ get(a:var, 'recommended-style',
        \ s:recommended_style))
  " support old option format-autosave and format_on_save
  let s:format_on_save = get(a:var, 'format_on_save', 
        \ get(a:var, 'format-autosave', s:format_on_save))
  " support old option racer-cmd and racer_cmd
  let s:racer_cmd = get(a:var, 'racer_cmd', 
        \ get(a:var, 'racer-cmd', s:racer_cmd))
  " support old option rustfmt-cmd and rustfmt_cmd
  let s:rustfmt_cmd = get(a:var, 'rustfmt_cmd',
        \ get(a:var, 'rustfmt-cmd', s:rustfmt_cmd))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
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
    " change it to SPC l g and SPC l v, just same as s g and s v
    call SpaceVim#mapping#space#langSPC('nmap', ['l', 'g'],
          \ '<Plug>(rust-def-split)', 'rust-def-split', 0)
    call SpaceVim#mapping#space#langSPC('nmap', ['l', 'v'],
          \ '<Plug>(rust-def-vertical)', 'rust-def-vertical', 0)

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
" toolchain
"
" set RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
"
"  rustup
"
" set RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
"
" vim:set et sw=2 cc=80
