"=============================================================================
" prolog.vim --- prolog support in SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#prolog, layer-lang-prolog
" @parentsection layers
" This layer is for prolog development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#prolog'
" <
"

function! SpaceVim#layers#lang#prolog#plugins() abort
  let plugins = []
  " @todo Use new prolog plugin
  " call add(plugins, ['wsdjeg/prolog-vim', { 'merged' : 0}])
  call add(plugins, ['wsdjeg/prolog.vim', { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#prolog#config() abort
  call SpaceVim#plugins#repl#reg('prolog', 'swipl -q')
  call SpaceVim#plugins#runner#reg_runner('prolog', 'swipl -q -f %s -t main')
  call SpaceVim#mapping#space#regesit_lang_mappings('prolog', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("prolog")',
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
