"=============================================================================
" latex.vim --- lang#latex layer for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
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
  let g:tex_flavor = 'latex'
  call SpaceVim#mapping#space#regesit_lang_mappings('tex', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','i'],
        \ '<plug>(vimtex-info)',
        \ 'vimtex-info', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','I'],
        \ '<plug>(vimtex-info-full)',
        \ 'vimtex-info-full', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','t'],
        \ '<plug>(vimtex-toc-open)',
        \ 'vimtex-toc-open', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','T'],
        \ '<plug>(vimtex-toc-toggle)',
        \ 'vimtex-toc-toggle', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','y'],
        \ '<plug>(vimtex-labels-open)',
        \ 'vimtex-labels-open', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','Y'],
        \ '<plug>(vimtex-labels-toggle)',
        \ 'vimtex-labels-toggle', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','v'],
        \ '<plug>(vimtex-view)',
        \ 'vimtex-view', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ '<plug>(vimtex-reverse-search)',
        \ 'vimtex-reverse-search', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','l'],
        \ '<plug>(vimtex-compile)',
        \ 'vimtex-compile', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','L'],
        \ '<plug>(vimtex-compile-selected)',
        \ 'vimtex-compile-selected', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','k'],
        \ '<plug>(vimtex-stop)',
        \ 'vimtex-stop', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','K'],
        \ '<plug>(vimtex-stop-all)',
        \ 'vimtex-stop-all', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','e'],
        \ '<plug>(vimtex-errors)',
        \ 'vimtex-errors', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','o'],
        \ '<plug>(vimtex-compile-output)',
        \ 'vimtex-compile-output', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','g'],
        \ '<plug>(vimtex-status)',
        \ 'vimtex-status', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','G'],
        \ '<plug>(vimtex-status-all)',
        \ 'vimtex-status-all', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','c'],
        \ '<plug>(vimtex-clean)',
        \ 'vimtex-clean', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','C'],
        \ '<plug>(vimtex-clean-full)',
        \ 'vimtex-clean-full', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','m'],
        \ '<plug>(vimtex-imaps-list)',
        \ 'vimtex-imaps-list', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','x'],
        \ '<plug>(vimtex-reload)',
        \ 'vimtex-reload', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','X'],
        \ '<plug>(vimtex-reload-state)',
        \ 'vimtex-reload-state', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s'],
        \ '<plug>(vimtex-toggle-main)',
        \ 'vimtex-toggle-main', 0)
endfunction
