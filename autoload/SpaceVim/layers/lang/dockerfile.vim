"=============================================================================
" dockerfile.vim --- layer for editing Dockerfile
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#dockerfile, layer-lang-dockerfile
" @parentsection layers
" @subsection Intro
"
" The lang#dockerfile layer provides syntax highlighting for dockerfile.

function! SpaceVim#layers#lang#dockerfile#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-dockerfile', {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#dockerfile#config() abort

  call SpaceVim#mapping#space#regesit_lang_mappings('dockerfile', function('s:language_specified_mappings'))

endfunction

function! s:language_specified_mappings() abort
  if SpaceVim#layers#lsp#check_filetype('dockerfile')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show_document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
  endif
endfunction
