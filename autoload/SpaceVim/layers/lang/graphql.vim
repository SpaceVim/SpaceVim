"=============================================================================
" graphqlfile.vim --- layer for editing graphql files
" Copyright (c) 2018 Pieter Joost van de Sande & Contributors
" Author: Pieter Joost van de Sande < pj at born2code.net >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#graphql#plugins() abort
  let plugins = []
  call add(plugins, ['jparise/vim-graphql', {'merged' : 0}])
  return plugins
endfunction
