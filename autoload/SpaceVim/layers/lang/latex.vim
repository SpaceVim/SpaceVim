"=============================================================================
" agda.vim --- lang#latex layer for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#latex#plugins() abort
  let plugins = []
  call add(plugins, ['lervag/vimtex', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#latex#config() abort
  augroup spacevim_layer_lang_latex
    autocmd!
    au BufNewFile,BufRead *.tex setlocal filetype=latex
  augroup END
  call SpaceVim#mapping#space#regesit_lang_mappings('latex', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','i'],
        \ '<plug>(vimtex-info)',
        \ 'vimtex-info', 0)
endfunction
