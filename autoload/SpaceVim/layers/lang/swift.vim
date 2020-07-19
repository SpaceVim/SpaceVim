"=============================================================================
" swift.vim --- swift layer for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

func! SpaceVim#layers#lang#swift#plugins() abort
  let plugins = []
  call add(plugins, ['keith/swift.vim', {'merged' : 0}])
  call add(plugins, ['mitsuse/autocomplete-swift', {'merged' : 0}])
  return plugins
endf


function! SpaceVim#layers#lang#swift#config() abort
  call SpaceVim#mapping#space#regesit_lang_mappings('swift', function('s:language_specified_mappings'))
endfunction
function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','k'],
        \ '<Plug>(autocomplete_swift_jump_to_placeholder)',
        \ 'jumping to placeholders', 0)
endfunction
