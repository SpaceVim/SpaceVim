"=============================================================================
" r.vim --- lang#r layer for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#ring, layers-lang-r
" @parentsection layers
" This layer is for r development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#r'
" <
"
" @subsection Key bindings
"
" The command of code runner for R is `"R <%s"`
" `%s` will be replaced to the path of current R file.
" >
"   Key             Function
"   --------------------------------
"   SPC l r         run current file
" <
"
" This layer also provides REPL support for r, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

function! SpaceVim#layers#lang#r#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/Nvim-R', {'merged' : 0}])
  return plugins
endfunction

let s:r_repl_command = ''
function! SpaceVim#layers#lang#r#set_variable(var) abort
  let s:r_repl_command = get(a:var, 'repl_command', '') 
endfunction

function! SpaceVim#layers#lang#r#config() abort
  call add(g:spacevim_project_rooter_patterns, '.Rprofile')
  call SpaceVim#plugins#runner#reg_runner('r', 'R <%s')
  call SpaceVim#mapping#space#regesit_lang_mappings('r', function('s:language_specified_mappings'))
  if !empty(s:r_repl_command)
    call SpaceVim#plugins#repl#reg('r',s:r_repl_command)
  else
    call SpaceVim#plugins#repl#reg('r', 'r')
  endif

endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("r")',
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

function! SpaceVim#layers#lang#r#health() abort
  call SpaceVim#layers#lang#r#plugins()
  call SpaceVim#layers#lang#r#config()
  return 1
endfunction
