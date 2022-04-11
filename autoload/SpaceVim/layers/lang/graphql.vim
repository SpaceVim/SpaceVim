"=============================================================================
" graphql.vim --- graphql layer for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#graphql, layers-lang-graphql
" @parentsection layers
" @subsection Intro
"
" The lang#graphql layer provides syntax highlighting indent for graphql. To
" enable this layer:
" >
"   [layers]
"     name = "lang#graphql"
" <
"
" This filetype is automatically selected for filenames ending in .graphql,
" .graphqls, and .gql. If you would like to enable automatic syntax support
" for more file extensions (e.g., *.prisma), add following into bootstrap
" function.
" >
"     augroup mybootstrap
"       au!
"       au BufNewFile,BufRead *.prisma setfiletype graphql
"     augroup END
" <

function! SpaceVim#layers#lang#graphql#plugins() abort
  let plugins = []
  call add(plugins, ['jparise/vim-graphql', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#graphql#health() abort
  call SpaceVim#layers#lang#graphql#plugins()
  return 1
endfunction
