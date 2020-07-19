"=============================================================================
" dart.vim --- SpaceVim lang#dart layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#dart, layer-lang-dart
" @parentsection layers
" @subsection Intro
"
" The lang#dart layer provides code completion, documentation lookup, jump to
" definition, dart_repl integration for dart. It uses neomake as default
" syntax checker which is loaded in @section(layer-checkers). To enable this
" layer:
" >
"   [layers]
"     name = "lang#dart"
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for hack, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"
" This layer use deoplete-dart as default completion plugin for dart. If the
" @section(layer-lsp) is enabled for dart, This plugin will not be loaded.
"
"

function! SpaceVim#layers#lang#dart#plugins() abort
  let plugins = []
  call add(plugins, ['dart-lang/dart-vim-plugin', {'merged' : 0}])
  if !SpaceVim#layers#lsp#check_filetype('dart')
    call add(plugins, ['SpaceVim/deoplete-dart', {'merged' : 0}])
  endif
  return plugins
endfunction


function! SpaceVim#layers#lang#dart#config() abort
  call SpaceVim#plugins#runner#reg_runner('dart', 'dart %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('dart', function('s:language_specified_mappings'))
  call SpaceVim#plugins#repl#reg('dart', ['pub', 'global', 'run', 'dart_repl'])
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()',
        \ 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("dart")',
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
  if SpaceVim#layers#lsp#check_filetype('dart')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show_document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
  endif
endfunction
