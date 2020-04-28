"=============================================================================
" crystal.vim --- SpaceVim lang#crystal layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#crystal, layer-lang-crystal
" @parentsection layers
" @subsection Intro
"
" The lang#crystal layer provides crystal filetype detection and syntax highlight,
" crystal tool and crystal spec integration. To enable this layer:
" >
"   [layers]
"     name = "lang#crystal"
" <
"
" @subsection mapping
" >
"   Key binding       description
"   SPC l r           run current code
"
" This layer also provides REPL support for crystal, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

function! SpaceVim#layers#lang#crystal#plugins() abort
  return [
      \ ['rhysd/vim-crystal', { 'on_ft' : 'crystal' }]
      \ ]
endfunction

function! SpaceVim#layers#lang#crystal#config() abort
  call SpaceVim#plugins#repl#reg('crystal', 'icr')
  call SpaceVim#plugins#runner#reg_runner('crystal', 'crystal run --no-color %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('crystal', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("crystal")',
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

  if SpaceVim#layers#lsp#check_filetype('crystal')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show_document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
  endif
endfunction

