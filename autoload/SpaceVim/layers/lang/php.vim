"=============================================================================
" php.vim --- lang#php layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


""
" @section lang#php, layers-lang-php
" @parentsection layers
" This layer is for php development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#php'
" <
"
" @subsection layer options
"
" 1. `php_interpreter`: Set the PHP interpreter, by default, it is `php`
" >
"   [[layers]]
"     name = 'lang#php'
"     php_interpreter = 'path/to/php'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for php, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

if exists('s:php_interpreter')
  finish
endif

let s:php_interpreter = 'php'



function! SpaceVim#layers#lang#php#plugins() abort
  let plugins = []
  call add(plugins, ['StanAngeloff/php.vim', { 'on_ft' : 'php'}])
  call add(plugins, ['2072/PHP-Indenting-for-VIm', { 'on_ft' : 'php'}])
  if SpaceVim#layers#lsp#check_filetype('php')
        \ || SpaceVim#layers#lsp#check_server('phpactor')
    call add(plugins, ['phpactor/phpactor', {'on_ft' : 'php', 'build' : 'composer install --no-dev -o'}])
  else
    if exists('*popup_create')
      call add(plugins, [g:_spacevim_root_dir . 'bundle/phpcomplete.vim', {'merged' : 0}])
    else
      call add(plugins, [g:_spacevim_root_dir . 'bundle/phpcomplete.vim-vim7', {'merged' : 0}])
    endif
  endif
  return plugins
endfunction

let s:auto_fix = 0

function! SpaceVim#layers#lang#php#set_variable(var) abort
  let s:auto_fix = get(a:var, 'auto_fix', 0)
  let s:php_interpreter = get(a:var, 'php_interpreter', s:php_interpreter)
endfunction

function! SpaceVim#layers#lang#php#config() abort
  call SpaceVim#plugins#runner#reg_runner('php', s:php_interpreter . ' %s')
  call SpaceVim#plugins#repl#reg('php', [s:php_interpreter, '-a'])
  call SpaceVim#mapping#space#regesit_lang_mappings('php',
        \ function('s:on_ft'))
  if SpaceVim#layers#lsp#check_filetype('php')
        \ || SpaceVim#layers#lsp#check_server('phpactor')
        \ || SpaceVim#layers#lsp#check_server('intelephense')
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

  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("php")',
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

function! SpaceVim#layers#lang#php#health() abort
  call SpaceVim#layers#lang#php#plugins()
  call SpaceVim#layers#lang#php#config()
  return 1
endfunction
