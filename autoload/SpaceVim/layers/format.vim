"=============================================================================
" format.vim --- format Layer file for SpaceVim
" Copyright (c) 2012-2016 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================

""
" @section format, format
" @parentsection layers
" SpaceVim uses neoformat as the default code format tools. Neoformat uses a
" variety of formatters for many filetypes. for more info see |neoformat|

function! SpaceVim#layers#format#plugins() abort
    return [
                \ ['sbdchd/neoformat', {'merged' : 0, 'loadconf' : 1 , 'loadconf_before' : 1}],
                \ ]
endfunction

function! SpaceVim#layers#format#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'f'], 'Neoformat', 'format-codo', 1)
endfunction
