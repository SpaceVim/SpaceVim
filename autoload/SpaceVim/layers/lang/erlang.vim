"=============================================================================
" erlang.vim --- erlang support for SpaceVim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#erlang, layers-lang-erlang
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

let s:is_erlang = SpaceVim#layers#lsp#check_filetype('erlang')
      \ || SpaceVim#layers#lsp#check_server('erlang_ls')


function! SpaceVim#layers#lang#erlang#plugins() abort
  let plugins = []
  call add(plugins, ['vim-erlang/vim-erlang-compiler', {'on_ft' : 'erlang'}])
  call add(plugins, ['vim-erlang/vim-erlang-omnicomplete', {'on_ft' : 'erlang'}])
  call add(plugins, ['vim-erlang/vim-erlang-runtime', {'on_ft' : 'erlang'}])
  call add(plugins, ['vim-erlang/vim-erlang-tags', {'on_ft' : 'erlang'}])
  return plugins
endfunction


function! SpaceVim#layers#lang#erlang#config() abort
  call SpaceVim#plugins#repl#reg('erlang', 'erl')
  call SpaceVim#plugins#runner#reg_runner('erlang', ['erlc -o #TEMP# %s', 'erl -pa #TEMP#'])
  call SpaceVim#mapping#space#regesit_lang_mappings('erlang', function('s:language_specified_mappings'))
  call SpaceVim#mapping#gd#add('erlang', function('s:go_to_def'))

  if s:is_erlang
    call SpaceVim#mapping#gd#add('erlang', function('SpaceVim#lsp#go_to_def'))
  else
    call SpaceVim#mapping#gd#add('erlang', function('s:go_to_def'))
  endif
endfunction


function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()',
        \ 'execute current file', 1)

  if s:is_erlang
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>
    nnoremap <silent><buffer> gD :<C-u>call SpaceVim#lsp#go_to_typedef()<Cr>
  endif
"
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
        \ 'call SpaceVim#lsp#show_doc()', 'show-document', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'x'],
        \ 'call SpaceVim#lsp#references()', 'show-references', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
        \ 'call SpaceVim#lsp#rename()', 'rename-symbol', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 's'],
        \ 'call SpaceVim#lsp#show_line_diagnostics()', 'show-line-diagnostics', 1)

  let g:_spacevim_mappings_space.l.w = {'name' : '+Workspace'}
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'w', 'l'],
        \ 'call SpaceVim#lsp#list_workspace_folder()', 'list-workspace-folder', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'w', 'a'],
        \ 'call SpaceVim#lsp#add_workspace_folder()', 'add-workspace-folder', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'w', 'r'],
        \ 'call SpaceVim#lsp#remove_workspace_folder()', 'remove-workspace-folder', 1)

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
  if s:is_erlang
    call SpaceVim#lsp#go_to_def()
  else
    normal! gd
  endif
endfunction


function! SpaceVim#layers#lang#erlang#health() abort
  call SpaceVim#layers#lang#erlang#plugins()
  call SpaceVim#layers#lang#erlang#config()
  return 1
endfunction
