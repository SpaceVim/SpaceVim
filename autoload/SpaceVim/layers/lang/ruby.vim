"=============================================================================
" ruby.vim --- lang#ruby layer for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================

function! SpaceVim#layers#lang#ruby#plugins() abort
  return [
      \ ['vim-ruby/vim-ruby', { 'on_ft' : 'ruby' }]
      \ ]
endfunction

function! SpaceVim#layers#lang#ruby#config() abort
  call SpaceVim#plugins#runner#reg_runner('ruby', 'ruby %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('ruby', funcref('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
endfunction
