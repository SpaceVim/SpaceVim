"=============================================================================
" racket.vim --- racket language support in spacevim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#racket#plugins() abort
  let plugins = []
  call add(plugins, ['wlangstroth/vim-racket', {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#racket#config() abort
  call SpaceVim#plugins#runner#reg_runner('racket', 
        \ {
        \ 'exe' : 'racket',
        \ 'opt' : ['-f'],
        \ 'usestdin' : 0,
        \ })
  call SpaceVim#mapping#gd#add('racket', function('s:go_to_def'))
  call SpaceVim#mapping#space#regesit_lang_mappings('racket', function('s:language_specified_mappings'))
endfunction

function! s:go_to_def() abort
  
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()',
        \ 'execute current file', 1)
    " nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>
endfunction
