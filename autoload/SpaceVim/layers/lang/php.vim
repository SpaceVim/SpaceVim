"=============================================================================
" php.vim --- lang#php layer
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


""
" @section lang#php, layer-lang-php
" @parentsection layers
" This layer is for PHP development. It proides code completion, syntax
" checking, and jump to definition.
"      
" Requirements:
" >
"   PHP 5.3+
"   PCNTL Extension
"   Msgpack 0.5.7+(for NeoVim)Extension: https://github.com/msgpack/msgpack-php
"   JSON(for Vim 7.4+)Extension
"   Composer Project
" <



function! SpaceVim#layers#lang#php#plugins() abort
  let plugins = []
  call add(plugins, ['StanAngeloff/php.vim', { 'on_ft' : 'php'}])
  call add(plugins, ['2072/PHP-Indenting-for-VIm', { 'on_ft' : 'php'}])
  call add(plugins, ['rafi/vim-phpspec', { 'on_ft' : 'php'}])
  if SpaceVim#layers#lsp#check_filetype('php')
    call add(plugins, ['felixfbecker/php-language-server', {'on_ft' : 'php', 'build' : 'composer install && composer run-script parse-stubs'}])
  else
    call add(plugins, ['php-vim/phpcd.vim', { 'on_ft' : 'php', 'build' : ['composer', 'install']}])
  endif
  call add(plugins, ['lvht/phpfold.vim', { 'on_ft' : 'php', 'build' : ['composer', 'install']}])
  return plugins
endfunction

let s:auto_fix = 0

function! SpaceVim#layers#lang#php#set_variable(var) abort
  let s:auto_fix = get(a:var, 'auto_fix', 0)
endfunction

function! SpaceVim#layers#lang#php#config() abort
  call SpaceVim#plugins#runner#reg_runner('php', 'php %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('php',
        \ function('s:on_ft'))
  if SpaceVim#layers#lsp#check_filetype('php')
    call SpaceVim#mapping#gd#add('php',
          \ function('SpaceVim#lsp#go_to_def'))
  endif

  if s:auto_fix
    augroup SpaceVim_lang_php
      autocmd!
      autocmd User NeomakeJobInit call <SID>phpBeautify()
      autocmd FocusGained * checktime
      autocmd Filetype php call <SID>preferLocalPHPMD()
    augroup END
  else 
    augroup SpaceVim_lang_php
      autocmd!
      autocmd Filetype php call <SID>preferLocalPHPMD()
    augroup END
  endif

endfunction

function! s:on_ft() abort
  if SpaceVim#layers#lsp#check_filetype('php')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show_document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
  endif
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()',
        \ 'execute current file', 1)
endfunction

function! s:phpBeautify() abort
  if (&filetype ==# 'php')
    let l:args = []
    if exists('g:neomake_php_phpcs_args_standard')
      call add(l:args, '--standard=' . expand(g:neomake_php_phpcs_args_standard))
    endif
    let l:lhs = expand('%')
    let l:command = printf(
          \ 'phpcbf %s %s',
          \ join(l:args, ' '),
          \ shellescape(fnameescape(l:lhs))
          \ )
    try 
      call system(l:command)
      checktime
    endtry
  endif
endfunction

function! s:preferLocalPHPMD() abort 
  let l:dir = expand('%:p:h')
  while findfile('phpmd.xml', dir) ==# ''
    let l:next_dir = fnamemodify(dir, ':h')
    if l:dir == l:next_dir
      break
    endif
    let l:dir = l:next_dir
  endwhile
  let l:phpmd_path = dir. '/phpmd.xml'
  if filereadable(l:phpmd_path) && !exists('b:neomake_php_phpmd_args')
    let b:neomake_php_phpmd_args = ['%:p', 'text', l:phpmd_path]
  endif
endfunction
