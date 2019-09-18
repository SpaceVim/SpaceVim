"=============================================================================
" test.vim --- SpaceVim test layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section test, layer-test
" @parentsection layers
" This layer allows to run tests on SpaceVim
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

function! SpaceVim#layers#test#plugins() abort
  return [
        \ ['janko/vim-test'],
        \ ]
endfunction

function! SpaceVim#layers#test#config() abort
  let g:_spacevim_mappings_space.k = get(g:_spacevim_mappings_space, 'k',  {'name' : '+Test'})

  call SpaceVim#mapping#space#def('nnoremap', ['k', 'n'], 'TestNearest', 'nearest', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['k', 'f'], 'TestFile', 'file', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['k', 's'], 'TestSuite', 'suite', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['k', 'l'], 'TestLast', 'last', 1)
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
endfunction
