"=============================================================================
" pony.vim --- SpaceVim lang#pony layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#pony, layer-lang-pony
" @parentsection layers
" This layer includes utilities and language-specific mappings for pony development.
" >
"   [[layers]]
"     name = 'lang#pony'
" <
"

function! SpaceVim#layers#lang#pony#plugins() abort
    let plugins = []
    " .pony file type
    call add(plugins, ['wsdjeg/vim-pony', { 'on_ft' : 'pony'}])
    return plugins
endfunction

function! SpaceVim#layers#lang#pony#config() abort
  " @todo pony neomake support
  " in github, there is a plugin https://github.com/killerswan/pony-currycomb.vim which provides syntastic suppotr
  " checker layer configuration
  if SpaceVim#layers#isLoaded('checkers') && g:spacevim_enable_neomake
    let g:neomake_pony_enabled_makers = ['ponyc']
    let g:neomake_pony_ponyc_maker =  {
          \ 'args': ['--pass=expr', '.'],
          \ 'errorformat': '%f:%l:%c: %m',
          \ 'cwd': '%:p:h',
          \ }
    let g:neomake_livescript_lsc_remove_invalid_entries = 1
  endif
endfunction
