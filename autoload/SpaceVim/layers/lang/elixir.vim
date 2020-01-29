"=============================================================================
" elixir.vim --- SpaceVim lang#elixir layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#elixir, layer-lang-elixir
" @parentsection layers
" This layer is for elixir development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#elixir'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
"   normal          g d             jump to definition
" <
"
" This layer also provides REPL support for d, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

function! SpaceVim#layers#lang#elixir#plugins() abort
  let plugins = []
  call add(plugins, ['elixir-editors/vim-elixir', {'on_ft' : ['elixir', 'eelixir']}])
  if !SpaceVim#layers#lsp#check_filetype('elixir')
    call add(plugins, ['slashmili/alchemist.vim', {'on_ft' : 'elixir'}])
  endif
  return plugins
endfunction


function! SpaceVim#layers#lang#elixir#config() abort
  call SpaceVim#plugins#runner#reg_runner('elixir', 'elixir %s')
  call SpaceVim#plugins#repl#reg('elixir', 'iex')
  call SpaceVim#mapping#space#regesit_lang_mappings('elixir', function('s:language_specified_mappings'))
  call SpaceVim#mapping#gd#add('elixir', function('s:go_to_def'))
  let g:alchemist_mappings_disable = 1
  let g:alchemist_tag_disable = 1
endfunction
function! s:language_specified_mappings() abort
  if SpaceVim#layers#lsp#check_filetype('elixir')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show_document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
  else
    nnoremap <silent><buffer> K :call alchemist#exdoc()<CR>
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call alchemist#exdoc()', 'show_document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 't'],
          \ 'call alchemist#jump_tag_stack()', 'jump to tag stack', 1)
  endif
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("elixir")',
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

function! s:go_to_def() abort
  if SpaceVim#layers#lsp#check_filetype('elixir')
    call SpaceVim#lsp#go_to_def()
  else
    ExDef
  endif
endfunction


" vim:set et sw=2 cc=80:
