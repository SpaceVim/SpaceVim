"=============================================================================
" ssh.vim --- ssh layer for spacevim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


""
" @section ssh, layers-ssh
" @parentsection layers
" The `ssh` layer provides basic function to connected to ssh server.
"
" @subsection layer options
"
" 1. `ssh_port`: set the port of ssh server
" 2. `ssh_address`: set the ip of ssh server
" 3. `ssh_user`: set the user name of ssh server
"
" @subsection key bindings
" >
"   Key Bingding    Description
"   SPC S o         connect to ssh server
" <

if exists('s:ssh')
  finish
endif

let s:ssh = 'ssh'
let s:user = 'root'
let s:ip = '127.0.0.1'
let s:port = '20'

function! SpaceVim#layers#ssh#config() abort
  let g:_spacevim_mappings_space.S = {'name' : '+SSH'}
  call SpaceVim#mapping#space#langSPC('nmap', ['S','o'],
        \ 'call SpaceVim#layers#ssh#connect()',
        \ 'connect-to-ssh-server', 1)
endfunction

function! SpaceVim#layers#ssh#set_variable(opt) abort
  let s:ssh = get(a:opt, 'ssh_command', s:ssh)
  let s:user = get(a:opt, 'ssh_user', s:user)
  let s:ip = get(a:opt, 'ssh_address', s:ip)
  let s:port = get(a:opt, 'ssh_port', s:port)
endfunction

function! SpaceVim#layers#ssh#connect() abort
  " the ssh client should be opened on new tab
  tabnew
  " set the tab name to SSH(user@ip:port)
  let t:_spacevim_tab_name = 'SSH(' . s:user . '@' . s:ip . ':' . s:port . ')'
  if has('nvim')
    call termopen([s:ssh, '-p', s:port, s:user . '@' . s:ip])
  else
    call term_start([s:ssh, '-p', s:port, s:user . '@' . s:ip], {'curwin' : 1, 'term_finish' : 'close'})
  endif
endfunction

function! SpaceVim#layers#ssh#get_options() abort

  return ['ssh_port', 'ssh_user', 'ssh_address', 'ssh_command']

endfunction

function! SpaceVim#layers#ssh#health() abort
  call SpaceVim#layers#ssh#config()
  return 1
endfunction
