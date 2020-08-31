"=============================================================================
" moonscript.vim --- moonscript support for SpaceVim
" Copyright (c) 2016-2020 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#moonscript, layer-lang-moonscript
" @parentsection layers
" This layer is for moonscript development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#moonscript'
" <
"
" @subsection Key bindings
" >
"   Key             Function
"   -----------------------------
"   SPC l r         Run current moonscript
" <
"
" This layer also provides REPL support for moonscript, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"


function! SpaceVim#layers#lang#moonscript#plugins() abort
  let plugins = []
  call add(plugins, ['leafo/moonscript-vim', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#moonscript#config() abort
  call SpaceVim#plugins#repl#reg('moon', 'mooni')
  call SpaceVim#plugins#runner#reg_runner('moon', 'moon %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('moon', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("moonscript")',
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
