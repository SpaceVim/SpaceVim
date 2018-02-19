"=============================================================================
" elixir.vim --- SpaceVim lang#elixir layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#elixir, layer-lang-elixir
" @parentsection layers
" @subsection Intro
" The lang#elixir layer provides code completion, documentation lookup, jump to
" definition, mix integration, and iex integration for Elixir. SpaceVim
" uses neomake as default syntax checker which is loaded in
" @section(layer-checkers)

function! SpaceVim#layers#lang#elixir#plugins() abort
  let plugins = []
  call add(plugins, ['elixir-editors/vim-elixir', {'on_ft' : ['elixir', 'eelixir']}])
  call add(plugins, ['slashmili/alchemist.vim', {'on_ft' : 'elixir'}])
  return plugins
endfunction


function! SpaceVim#layers#lang#elixir#config()
  call SpaceVim#plugins#repl#reg('elixir', 'iex')
  call SpaceVim#mapping#space#regesit_lang_mappings('elixir', function('s:language_specified_mappings'))
endfunction
function! s:language_specified_mappings() abort
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("elixir")',
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
