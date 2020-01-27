"=============================================================================
" erlang.vim --- erlang support for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#erlang, layer-lang-erlang
" @parentsection layers
" This layer is for erlang development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#erlang'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for erlang, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

function! SpaceVim#layers#lang#erlang#plugins() abort
  let plugins = []
  " call add(plugins, ['vim-erlang/vim-erlang-compiler', {'on_ft' : 'erlang'}])
  call add(plugins, ['vim-erlang/vim-erlang-omnicomplete', {'on_ft' : 'erlang'}])
  call add(plugins, ['vim-erlang/vim-erlang-runtime', {'on_ft' : 'erlang'}])
  " call add(plugins, ['vim-erlang/vim-erlang-tags', {'on_ft' : 'erlang'}])
  return plugins
endfunction


function! SpaceVim#layers#lang#erlang#config() abort
  call SpaceVim#plugins#repl#reg('erlang', 'erl')
  " call SpaceVim#plugins#runner#reg_runner('erlang', ['erlc -o #TEMP# %s', 'erl -pa #TEMP#'])
  call SpaceVim#mapping#space#regesit_lang_mappings('erlang', function('s:language_specified_mappings'))
  " call SpaceVim#mapping#gd#add('erlang', function('s:go_to_def'))
endfunction
function! s:language_specified_mappings() abort
  " call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        " \ 'call SpaceVim#plugins#runner#open()',
        " \ 'execute current file', 1)
  if SpaceVim#layers#lsp#check_filetype('erlang')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show_document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
  " else
    " nnoremap <silent><buffer> K :call alchemist#exdoc()<CR>
    " call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          " \ 'call alchemist#exdoc()', 'show_document', 1)
    " call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 't'],
          " \ 'call alchemist#jump_tag_stack()', 'jump to tag stack', 1)
  endif
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("erlang")',
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
  if SpaceVim#layers#lsp#check_filetype('erlang')
    call SpaceVim#lsp#go_to_def()
  else
    normal! gd
  endif
endfunction
