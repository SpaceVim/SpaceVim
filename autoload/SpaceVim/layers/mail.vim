"=============================================================================
" mail.vim --- SpaceVim mail layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section mail, layers-mail
" @parentsection layers
" The `mail` layer provides basic function to connected to mail server.
" NOTE: this layer is still wip now.
" @subsection layer options
"
" 1. `imap_host`: set the imap server host
" 2. `imap_port`: set the imap server port
" 3. `imap_login`: set the login of imap server
" 4. `imap_password`: set the password of imap server
"
" @subsection key bindings
" >
"   Key Bingding    Description
"   SPC a m         open mail client
" <

if exists('s:imap_host')
  finish
endif

let s:imap_host = 'imap.163.com'
let s:imap_port = 143
let s:imap_login = ''
let s:imap_password = ''

function! SpaceVim#layers#mail#plugins() abort
    return [
          \ [g:_spacevim_root_dir . 'bundle/vim-mail', {'merged' : 0, 'loadconf' : 1}],
            \ ]
endfunction

function! SpaceVim#layers#mail#set_variable(opt) abort
  let s:imap_host = get(a:opt, 'imap_host', s:imap_host)
  let s:imap_port = get(a:opt, 'imap_port', s:imap_port)
  let s:imap_login = get(a:opt, 'imap_login', s:imap_login)
  let s:imap_password = get(a:opt, 'imap_password', s:imap_password)
endfunction

function! SpaceVim#layers#mail#config() abort
    call SpaceVim#mapping#space#def('nnoremap', ['a', 'm'], 'call mail#client#open()', 'Start mail client', 1)
    let g:mail_imap_host = s:imap_host
    let g:mail_imap_port = s:imap_port
    let g:mail_imap_login = s:imap_login
    let g:mail_imap_password = s:imap_password
endfunction

function! SpaceVim#layers#mail#health() abort
  call SpaceVim#layers#mail#plugins()
  call SpaceVim#layers#mail#config()
  return 1
endfunction
