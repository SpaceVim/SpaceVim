"=============================================================================
" test.vim --- SpaceVim test layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section test, layers-test
" @parentsection layers
" This layer allows to run tests on SpaceVim
"
" @subsection layer options
"
" - `use_ultest`: enable/disable vim-ultest plugin, this is disabled by
"   default.
"
" @subsection Mappings
" >
"   Mode      Key         Function
"   -------------------------------------------------------------
"   normal    SPC k n     run nearest test
"   normal    SPC k f     run test file
"   normal    SPC k s     run test suite
"   normal    SPC k l     run the latest test
"   normal    SPC k v     visits the last run test file
" <

let s:use_ultest = 0

function! SpaceVim#layers#test#plugins() abort
  let l:plugins = [
        \ ['janko/vim-test'],
        \ ]

  if s:use_ultest
    let l:plugins += [['rcarriga/vim-ultest']]
  endif

  return l:plugins
endfunction

function! SpaceVim#layers#test#config() abort
  let g:_spacevim_mappings_space.k = get(g:_spacevim_mappings_space, 'k',  {'name' : '+Test'})

  if s:use_ultest
    let g:ultest_use_pty = 1

    call SpaceVim#mapping#space#def('nnoremap', ['k', 'n'], 'UltestNearest', 'nearest', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['k', 'f'], 'Ultest', 'file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['k', 'l'], 'UltestLast', 'last', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['k', 'u'], 'UltestSummary!', 'jump-to-summary', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['k', 'U'], 'UltestSummary', 'open-summary', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['k', 'k'], 'UltestStopNearest', 'stop-nearest', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['k', 'K'], 'UltestStop', 'stop', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['k', 'a'], 'UltestAttach', 'attach', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['k', 'c'], 'UltestClear', 'clear', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['k', 'd'], 'UltestDebugNearest', 'debug-nearest', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['k', 'D'], 'UltestDebug', 'debug', 1)
    call SpaceVim#mapping#space#def('nmap', ['k', 'j'], '<Plug>(ultest-next-fail)', 'jump-to-next-failed', 0)
    call SpaceVim#mapping#space#def('nmap', ['k', 'k'], '<Plug>(ultest-prev-fail)', 'jump-to-prev-failed', 0)
    call SpaceVim#mapping#space#def('nmap', ['k', 'o'], '<Plug>(ultest-output-show)', 'show-output', 0)
    call SpaceVim#mapping#space#def('nmap', ['k', 'O'], '<Plug>(ultest-output-jump)', 'jump-to-output', 0)
  else
    call SpaceVim#mapping#space#def('nnoremap', ['k', 'n'], 'TestNearest', 'nearest', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['k', 'f'], 'TestFile', 'file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['k', 'l'], 'TestLast', 'last', 1)
  endif

  call SpaceVim#mapping#space#def('nnoremap', ['k', 's'], 'TestSuite', 'suite', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['k', 'v'], 'TestVisit', 'visit', 1)
  let g:test#custom_strategies = {'spacevim': function('SpaceVim#plugins#runner#open')}
  let g:test#strategy = 'spacevim'
endfunction

function! SpaceVim#layers#test#set_variable(var) abort
  let l:override = get(a:var, 'override_config', {})
  if !empty(l:override)
    for l:option in keys(l:override)
      let l:varname = 'test#'.substitute(l:option, '_', '#', 'g')
      execute 'let g:'.l:varname.' = '."'".l:override[l:option]."'"
    endfor
  endif

  let s:use_ultest = get(a:var, 'use_ultest', s:use_ultest)
endfunction

function! SpaceVim#layers#test#health() abort
  call SpaceVim#layers#test#plugins()
  call SpaceVim#layers#test#config()
  return 1
endfunction
