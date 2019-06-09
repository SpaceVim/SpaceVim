"=============================================================================
" purescript.vim --- lang#purescript layer for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


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
