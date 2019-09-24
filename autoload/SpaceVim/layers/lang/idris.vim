"=============================================================================
" idris.vim --- idris language support
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#idris#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-idris', { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#idris#config() abort
  call SpaceVim#plugins#repl#reg('idris', 'idris --nobanner')
  call SpaceVim#plugins#runner#reg_runner('idris', ['idris %s -o #TEMP#', '#TEMP#'])
  call SpaceVim#mapping#space#regesit_lang_mappings('idris', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("idris")',
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
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','w'], 'call idris#makeWith()', 'add-with-clause', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','t'], 'call idris#showType()', 'show-type', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','p'], 'call idris#proofSearch(1)', 'proof-search', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','o'], 'call idris#proofSearch(1)', 'obvious-proof-search', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','a'], 'call idris#reload(0)', 'reload-file', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c'], 'call idris#caseSplit()', 'case-split', 1)
  let g:_spacevim_mappings_space.l.d = {'name' : '+Add clause'}
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','d', 'f'], 'call idris#addClause(0)', 'case-split', 1)

  " nnoremap <buffer> <silent> <LocalLeader>d 0:call search(":")<ENTER>b:call IdrisAddClause(0)<ENTER>w
  " nnoremap <buffer> <silent> <LocalLeader>b 0:call IdrisAddClause(0)<ENTER>
  " nnoremap <buffer> <silent> <LocalLeader>m :call IdrisAddMissing()<ENTER>
  " nnoremap <buffer> <silent> <LocalLeader>md 0:call search(":")<ENTER>b:call IdrisAddClause(1)<ENTER>w
  " nnoremap <buffer> <silent> <LocalLeader>f :call IdrisRefine()<ENTER>
  " nnoremap <buffer> <silent> <LocalLeader>o :call IdrisProofSearch(0)<ENTER>
  " nnoremap <buffer> <silent> <LocalLeader>p :call IdrisProofSearch(1)<ENTER>
  " nnoremap <buffer> <silent> <LocalLeader>l :call IdrisMakeLemma()<ENTER>
  " nnoremap <buffer> <silent> <LocalLeader>e :call IdrisEval()<ENTER>
  " nnoremap <buffer> <silent> <LocalLeader>w 0:call IdrisMakeWith()<ENTER>
  " nnoremap <buffer> <silent> <LocalLeader>mc :call IdrisMakeCase()<ENTER>
  " nnoremap <buffer> <silent> <LocalLeader>i 0:call IdrisResponseWin()<ENTER>
  " nnoremap <buffer> <silent> <LocalLeader>h :call IdrisShowDoc()<ENTER>
endfunction
