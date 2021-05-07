"=============================================================================
" e.vim --- E language layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#e, layer-lang-e
" @parentsection layers
" @subsection Intro
"
" This layer includes utilities and language-specific mappings for e development.
" By default it is disabled, to enable this layer:
" >
"   [layers]
"     name = "lang#e"
" <

if exists('s:e_interpreter')
  finish
endif

let s:e_interpreter = 'rune'
let s:e_jar_path = 'e.jar'

function! SpaceVim#layers#lang#e#plugins() abort
  let plugins = []
    call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-elang', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#e#config() abort
  call SpaceVim#plugins#repl#reg('e', shellescape(s:e_interpreter))
  call SpaceVim#plugins#runner#reg_runner('e', 'java -jar ' . shellescape(s:e_jar_path) .  ' --rune %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('e', function('s:language_specified_mappings'))
endfunction
function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("e")',
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

function! SpaceVim#layers#lang#e#set_variable(var) abort
  let s:e_interpreter = get(a:var, 'e_interpreter', s:e_interpreter)
  let s:e_jar_path = get(a:var, 'e_jar_path', s:e_jar_path)
endfunction

function! SpaceVim#layers#lang#e#get_options() abort

  return ['e_interpreter']

endfunction
