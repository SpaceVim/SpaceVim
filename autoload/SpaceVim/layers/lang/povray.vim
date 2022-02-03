"=============================================================================
" povray.vim --- POV-Ray language support
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if exists('s:povray_command')
  finish
else
  let s:povray_command = 'povray'
endif

function! SpaceVim#layers#lang#povray#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-povray', { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#povray#config() abort
  let g:povray_command = s:povray_command
  call SpaceVim#mapping#space#regesit_lang_mappings('povray', function('s:language_specified_mappings'))
endfunction

function! SpaceVim#layers#lang#povray#set_variable(opt) abort
  let s:povray_command = get(a:opt, 'povray_command', s:povray_command) 
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','v'],
        \ 'call povray#view()',
        \ 'view-image', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','c'],
        \ 'call povray#cleanPreviousImage()',
        \ 'clean-previous-image', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','b'],
        \ 'call povray#CompileSilent()',
        \ 'build-silent', 1)
endfunction

function! SpaceVim#layers#lang#povray#health() abort
  call SpaceVim#layers#lang#povray#plugins()
  call SpaceVim#layers#lang#povray#config()
  return 1
endfunction
