"=============================================================================
" fortran.vim --- fortran language support for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#fortran, layers-lang-fortran
" @parentsection layers
" This layer is for fortran development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#fortran'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for fortran, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

function! SpaceVim#layers#lang#fortran#plugins() abort
  let plugins = []
  call add(plugins,[g:_spacevim_root_dir . 'bundle/fortran.vim',        { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#fortran#config() abort
  call SpaceVim#plugins#runner#reg_runner('fortran', ['gfortran %s -o #TEMP#', '#TEMP#'])
  call SpaceVim#plugins#repl#reg('fortran', 'frepl')
  call SpaceVim#mapping#space#regesit_lang_mappings('fortran', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("fortran")',
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


" ref:
"
" fortran wiki org
"
" http://fortranwiki.org/fortran/show/Source+code+editors


function! SpaceVim#layers#lang#fortran#health() abort
  call SpaceVim#layers#lang#fortran#plugins()
  call SpaceVim#layers#lang#fortran#config()
  return 1
endfunction
