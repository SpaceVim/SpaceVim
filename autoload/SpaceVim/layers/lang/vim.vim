"=============================================================================
" vim.vim --- SpaceVim vim layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#vim#plugins() abort
  let plugins = [
        \ ['syngan/vim-vimlint',                     { 'on_ft' : 'vim'}],
        \ ['ynkdir/vim-vimlparser',                  { 'on_ft' : 'vim'}],
        \ ['todesking/vint-syntastic',               { 'on_ft' : 'vim'}],
        \ ]
  call add(plugins,['tweekmonster/exception.vim', {'merged' : 0}])
  call add(plugins,['mhinz/vim-lookup', {'merged' : 0}])
  call add(plugins,['Shougo/neco-vim',              { 'on_event' : 'InsertEnter', 'loadconf_before' : 1}])
  if g:spacevim_autocomplete_method == 'asyncomplete'
    call add(plugins, ['prabirshrestha/asyncomplete-necovim.vim', {
          \ 'loadconf' : 1,
          \ 'merged' : 0,
          \ }])
  endif
  call add(plugins,['tweekmonster/helpful.vim',      {'on_cmd': 'HelpfulVersion'}])
  return plugins
endfunction

function! SpaceVim#layers#lang#vim#config() abort
  call SpaceVim#mapping#gd#add('vim','lookup#lookup')
  call SpaceVim#mapping#space#regesit_lang_mappings('vim', function('s:language_specified_mappings'))
  call SpaceVim#plugins#highlight#reg_expr('vim', '^\s*\(func\|fu\|function\)!\?\s\+', '^\s*\(endfunc\|endf\|endfunction\)')
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','e'],  'call call('
        \ . string(function('s:eval_cursor')) . ', [])',
        \ 'echo eval under cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','v'],  'call call('
        \ . string(function('s:helpversion_cursor')) . ', [])',
        \ 'echo helpversion under cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','f'], 'call exception#trace()', 'tracing exceptions', 1)
endfunction

function! s:eval_cursor() abort
  let is_keyword = &iskeyword
  set iskeyword+=:
  echo expand('<cword>') 'is' eval(expand('<cword>'))
  let &iskeyword = is_keyword
endfunction

function! s:helpversion_cursor() abort
  exe 'HelpfulVersion' expand('<cword>')
endfunction
