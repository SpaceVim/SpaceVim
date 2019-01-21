"=============================================================================
" ruby.vim --- lang#ruby layer for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#ruby#plugins() abort
  return [
        \ ['vim-ruby/vim-ruby', { 'on_ft' : 'ruby' }]
        \ ]
endfunction

let s:ruby_repl_command = ''

function! SpaceVim#layers#lang#ruby#config() abort
  call SpaceVim#plugins#runner#reg_runner('ruby', 'ruby %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('ruby', function('s:language_specified_mappings'))
  if !empty(s:ruby_repl_command)
      call SpaceVim#plugins#repl#reg('ruby',s:ruby_repl_command)
  else
      call SpaceVim#plugins#repl#reg('ruby', 'irb')
  endif
endfunction

function! SpaceVim#layers#lang#ruby#set_variable(var) abort
  let s:ruby_repl_command = get(a:var, 'repl_command', '') 
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
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
endfunction
