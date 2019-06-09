"=============================================================================
" elixir.vim --- SpaceVim lang#elm layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#elm, layer-lang-elm
" @parentsection layers
" @subsection Intro
" The lang#elm layer provides code completion, documentation lookup, jump to
" definition, mix integration, and iex integration for elm. SpaceVim
" uses neomake as default syntax checker which is loaded in
" @section(layer-checkers)

function! SpaceVim#layers#lang#elm#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-elm', {'on_ft' : 'elm'}])
  return plugins
endfunction


function! SpaceVim#layers#lang#elm#config() abort
  call SpaceVim#plugins#repl#reg('elm', 'elm repl')
  call SpaceVim#mapping#space#regesit_lang_mappings('elm', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("elm")',
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
  call SpaceVim#mapping#space#langSPC('nmap', ['l','m'],
        \ '<Plug>(elm-make)',
        \ 'Compile the current buffer', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','t'],
        \ '<Plug>(elm-test)',
        \ 'Runs the tests', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','e'],
        \ '<Plug>(elm-error-detail)',
        \ 'Show error detail', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','d'],
        \ '<Plug>(elm-show-docs)',
        \ 'Show symbol doc', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','w'],
        \ '<Plug>(elm-browse-docs)',
        \ 'Browse symbol doc', 0)
  nmap <buffer> K <Plug>(elm-show-docs)
  let g:elm_setup_keybindings = 0
endfunction
