"=============================================================================
" mail.vim --- SpaceVim mail layer
" Copyright (c) 2016-2021 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section mail, layers-mail
" @parentsection layers
" The `mail` layer provides basic function to connected to mail server.
"
" @subsection layer options
"
" 1. `ssh_port`: set the port of mail server
"
" @subsection key bindings
" >
"   Key Bingding    Description
"   SPC a m         open mail client
" <

function! SpaceVim#layers#mail#plugins() abort
    return [
          \ [g:_spacevim_root_dir . 'bundle/vim-mail', {'merged' : 0, 'loadconf' : 1}],
            \ ]
endfunction


function! SpaceVim#layers#mail#config() abort
    call SpaceVim#mapping#space#def('nnoremap', ['a', 'm'], 'call mail#client#open()', 'Start mail client', 1)
endfunction

function! SpaceVim#layers#mail#health() abort
  call SpaceVim#layers#mail#plugins()
  call SpaceVim#layers#mail#config()
  return 1
endfunction
