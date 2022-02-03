"=============================================================================
" sml.vim --- SpaceVim lang#sml layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Tommy Tam < thawk009 # gmail.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8
""
" @section lang#sml, layers-lang-sml
" @parentsection layers
" This layer is for Standard ML development.
" This layer provides basic syntax highlighting and code completion , and it
" is disabled by default, to enable this
" layer, add following snippet to your @section(options) file.
" >
"   [[layers]]
"     name = 'lang#sml'
" <
"
" You can run `:SMLCheckHealth` to check whether the environment if OK.
"
" @subsection Layer options
"
" `smlnj_path`: Set the path to the smlnj executable, by default, it is
" `sml`.
"
" `mlton_path`: Set the path to the mlton executable, by default, it is
" `mlton`.
"
" `repl_options`: Options used for REPL, by default, it is ''.
"
" `auto_create_def_use`: Whether to build def-use files on save automatically.
" By default, it is `mlb`. Valid values is:
" >
"    'mlb': Auto build def-use if there's a *.mlb file
"    'always': Always build def-use file
"    'never': Never build def-use file
" <
"
" `enable_conceal`: `0`/`1`. Whether to enable concealing for SML files. `0` by defaults.
"    `'a` becomes `α` (or `'α`).
"    `fn` becomes `λ.`
"
" `enable_conceal_show_tick`: `0`/`1`. When conceal is enabled, show `'α` for `'a` instead of `α`.
"    Helps for alignment. `0` by default.
"
" `sml_file_head`: Template for new sml file.
"
" Here is an example how to use above options:
" >
"   [[layers]]
"     name = "lang#sml"
"     smlnj_path = "/usr/local/smlnj/bin/sml"
"     mlton_path = "/usr/local/bin/mlton"
"     repl_options = ''
"     enable_conceal = 1
"     enable_conceal_show_tick = 1
"     auto_create_def_use = 'always'
" <

if exists('s:sml_file_head')
  finish
else
  let g:sml_auto_create_def_use = 'mlb'
  let g:sml_greek_tyvar_show_tick = '0'
  let g:sml_mlton_executable = 'mlton'
  let g:sml_repl_options = []
  let g:sml_smlnj_executable = 'sml'
  let s:sml_enable_conceal = 0
  let s:sml_file_head = ['']
  let s:sml_repl_options = ''
endif




function! SpaceVim#layers#lang#sml#plugins() abort
  let l:plugins = []
  call add(l:plugins, ['jez/vim-better-sml', { 'on_ft' : 'sml', 'build' : 'make' }])
  return l:plugins
endfunction

function! SpaceVim#layers#lang#sml#config() abort
  call SpaceVim#layers#edit#add_ft_head_tamplate('sml', s:sml_file_head)
  augroup spacevim_layer_lang_sml
    autocmd!
    " autocmd FileType sml setlocal omnifunc=SpaceVim#plugins#bashcomplete#omnicomplete
    if s:sml_enable_conceal
        autocmd FileType sml setlocal conceallevel=2
    endif
  augroup END
  call SpaceVim#mapping#gd#add('sml', function('bettersml#jumptodef#JumpToDef'))
  call SpaceVim#mapping#space#regesit_lang_mappings('sml', function('s:language_specified_mappings'))

  let l:runner = {
        \ 'exe' : g:sml_smlnj_executable,
        \ 'opt' : [],
        \ 'usestdin' : 1,
        \ }
  call SpaceVim#plugins#runner#reg_runner('sml', l:runner)
  call SpaceVim#plugins#repl#reg('sml', g:sml_smlnj_executable . s:sml_repl_options)
endfunction

function! s:language_specified_mappings() abort
  nnoremap <silent><buffer> K :call bettersml#typequery#TypeQuery()<CR>

  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()',
        \ 'execute current file', 1)

  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ "call SpaceVim#plugins#repl#start('sml')",
        \ 'start REPL process', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'l'],
        \ "call SpaceVim#plugins#repl#send('raw', getline('.') . ';')",
        \ 'send line and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'b'],
        \ 'call SpaceVim#plugins#repl#send("raw", join(getline(1, "$"), "\n") . ";")',
        \ 'send buffer and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 's'],
        \ 'call SpaceVim#plugins#repl#send("raw", join(getline("''<", "''>"), "\n") . ";")',
        \ 'send selection and keep code buffer focused', 1)
endfunction

function! SpaceVim#layers#lang#sml#set_variable(var) abort
  let g:sml_smlnj_executable = get(a:var, 'smlnj_path', 'sml')
  let g:sml_mlton_executable = get(a:var, 'mlton_path', 'mlton')
  let g:sml_auto_create_def_use = get(a:var, 'auto_create_def_use', 'mlb')
  let g:sml_greek_tyvar_show_tick = get(a:var, 'enable_conceal_show_tick', '0')
  let s:sml_repl_options = get(a:var, 'repl_options', s:sml_repl_options)
  let g:sml_repl_options = s:sml_repl_options
  let s:sml_enable_conceal = get(a:var, 'enable_conceal', s:sml_enable_conceal)
  let s:sml_file_head = get(a:var, 'sml_file_head', s:sml_file_head)
endfunction

function! SpaceVim#layers#lang#sml#health() abort
  call SpaceVim#layers#lang#sml#plugins()
  call SpaceVim#layers#lang#sml#config()
  return 1
endfunction
