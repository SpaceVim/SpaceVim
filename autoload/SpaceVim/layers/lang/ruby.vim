"=============================================================================
" ruby.vim --- lang#ruby layer for SpaceVim
" Copyright (c) 2016-2019 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#ruby, layer-lang-ruby
" @parentsection layers
" This layer is for ruby development, disabled by default, to enable this
" layer, add following snippet to your @section(options) file.
" >
"   [[layers]]
"     name = 'lang#ruby'
" <
"
" @subsection Options
"
" 1. ruby_file_head: the default file head for ruby source code.
" >
"   [layers]
"     name = "lang#ruby"
"     ruby_file_head = [      
"       '#!/usr/bin/ruby -w',
"       '# -*- coding : utf-8 -*-'
"       ''
"     ]
" <
" @subsection Key bindings
"
" >
"   Key             Function
"   --------------------------------
"   SPC l r         run current file
" <
"
" This layer also provides REPL support for ruby, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

function! SpaceVim#layers#lang#ruby#plugins() abort
  return [
        \ ['vim-ruby/vim-ruby', { 'on_ft' : 'ruby' }]
        \ ]
endfunction

let s:ruby_repl_command = ''

function! SpaceVim#layers#lang#ruby#config() abort
  call SpaceVim#plugins#runner#reg_runner('ruby', {
        \ 'exe' : 'ruby',
        \ 'opt' : ['-'],
        \ 'usestdin' : 1,
        \ })
  call SpaceVim#mapping#gd#add('ruby', function('s:go_to_def'))
  call SpaceVim#mapping#space#regesit_lang_mappings('ruby', function('s:language_specified_mappings'))
  if !empty(s:ruby_repl_command)
    call SpaceVim#plugins#repl#reg('ruby',s:ruby_repl_command)
  else
    call SpaceVim#plugins#repl#reg('ruby', 'irb')
  endif
endfunction

let s:ruby_file_head = [
      \ '#!/usr/bin/ruby -w',
      \ '# -*- coding : utf-8 -*-',
      \ ''
      \ ]

function! SpaceVim#layers#lang#ruby#set_variable(var) abort
  let s:ruby_repl_command = get(a:var, 'repl_command', '') 
  let s:ruby_file_head = get(a:var, 'ruby-file-head', s:ruby_file_head)
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  if SpaceVim#layers#lsp#check_filetype('ruby')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show_document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
  endif
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("ruby")',
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
  let g:_spacevim_mappings_space.l.c = {'name' : '+RuboCop'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','c', 'f'],
        \ 'Neoformat rubocop',
        \ 'Runs RuboCop on the currently visited file', 1)
  let g:neomake_ruby_rubylint_remove_invalid_entries = 1
endfunction

function! s:go_to_def() abort
  if !SpaceVim#layers#lsp#check_filetype('ruby')
    normal! gd
  else
    call SpaceVim#lsp#go_to_def()
  endif
endfunction

function! SpaceVim#layers#lang#ruby#get_options() abort
  return [
        \ 'repl_command',
        \ 'ruby-file-head'
        \ ]
endfunction
