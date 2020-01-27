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
" This layer is for elm development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#elm'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for elm, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"


function! SpaceVim#layers#lang#elm#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-elm', {'on_ft' : 'elm'}])
  return plugins
endfunction


function! SpaceVim#layers#lang#elm#config() abort
  call SpaceVim#plugins#repl#reg('elm', 'elm repl')
  call SpaceVim#plugins#runner#reg_runner('elm', 'elm %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('elm', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
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
