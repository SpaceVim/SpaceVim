"=============================================================================
" purescript.vim --- lang#purescript layer for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#purescript, layers-lang-purescript
" @parentsection layers
" This layer provides purescript language support for SpaceVim. Includding syntax
" highlighting, code formatting and code completion. This layer is not enabled
" by default, to enable this layer, add following snippet into SpaceVim
" configuration file:
" >
"   [[layers]]
"     name = 'lang#purescript'
" <
" @subsection Key bindings
"
" >
"   Key             Function
"   --------------------------------
"   SPC l L         list loaded modules
"   SPC l l         reset loaded modules and load externs
"   SPC l R         rebuild current buffer
"   SPC l f         generate function template
"   SPC l t         add type annotation
"   SPC l a         apply current line suggestion
"   SPC l A         apply all suggestions
"   SPC l C         add case expression
"   SPC l i         import module
"   SPC l p         search pursuit for cursor ident
"   SPC l T         find type of cursor ident
" <
"
" This layer also provides REPL support for purescript, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

function! SpaceVim#layers#lang#purescript#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/purescript-vim', {'on_ft' : 'purescript'}])
  call add(plugins, ['frigoeu/psc-ide-vim', {'on_ft' : 'purescript'}])
  return plugins
endfunction

function! SpaceVim#layers#lang#purescript#config() abort
  call SpaceVim#mapping#space#regesit_lang_mappings('purescript', function('s:language_specified_mappings'))
  call SpaceVim#mapping#gd#add('purescript', function('s:go_to_def'))
  call SpaceVim#plugins#repl#reg('purescript', ['pulp', 'repl'])
  call SpaceVim#plugins#runner#reg_runner('purescript', 'pulp run')
endfunction
function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','L'],
        \ 'Plist',
        \ 'list loaded modules', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','l'],
        \ 'Pload!',
        \ 'reset loaded modules and load externs', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()',
        \ 'run current project', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','R'],
        \ 'Prebuild!',
        \ 'rubuild current buffer', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','f'],
        \ 'PaddClause',
        \ 'generate function template', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','t'],
        \ 'PaddType',
        \ 'add type annotation', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','a'],
        \ 'Papply',
        \ 'apply current line suggestion', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','A'],
        \ 'Papply!',
        \ 'apply all suggestions', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','C'],
        \ 'Pcase!',
        \ 'add case expression', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','i'],
        \ 'Pimport',
        \ 'import module', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','p'],
        \ 'Pursuit',
        \ 'search pursuit for cursor ident', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','T'],
        \ 'Ptype',
        \ 'find type of cursor ident', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("purescript")',
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

function! s:go_to_def() abort
  if !SpaceVim#layers#lsp#check_filetype('purescript')
    Pgoto
  else
    call SpaceVim#lsp#go_to_def()
  endif
endfunction

function! SpaceVim#layers#lang#purescript#health() abort
  call SpaceVim#layers#lang#purescript#plugins()
  call SpaceVim#layers#lang#purescript#config()
  return 1
endfunction
