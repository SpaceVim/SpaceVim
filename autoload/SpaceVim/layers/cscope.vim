"=============================================================================
" cscope.vim --- SpaceVim cscope layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#cscope#plugins() abort
  let plugins = [
        \ ['SpaceVim/cscope.vim'],
        \ ]
  return plugins
endfunction


function! SpaceVim#layers#cscope#config() abort
    let g:_spacevim_mappings_space.m.c = {'name' : '+cscope'}
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'c', 'c'], 'Unite cscope/functions_called_by', 'find functions called by this function', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'c', 'C'], 'Unite cscope/functions_calling', 'find functions calling this function', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'c', 'd'], 'Unite cscope/global_definition', 'find global definition of a symbol', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'c', 'r'], 'Unite cscope/find_this_symbol', 'find references of a symbol', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'c', 'f'], 'Unite cscope/find_file', 'find files', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'c', 'F'], 'Unite cscope/including_this_file', 'find files including this file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'c', 'e'], 'Unite cscope/egrep_pattern', 'Find this egrep pattern', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'c', 't'], 'Unite cscope/text_string', 'find this text string', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'c', '='], 'Unite cscope/assignments_to_symbol', 'find assignments to this symbol', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'c', 'i'], 'call CscopeUpdateDB()', 'create cscope index', 1)
endfunction
