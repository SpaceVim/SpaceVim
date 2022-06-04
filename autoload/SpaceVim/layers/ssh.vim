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

let s:JOB = SpaceVim#api#import('job')
let s:NOT = SpaceVim#api#import('notify')

let s:ssh = 'ssh'
let s:user = 'root'
let s:ip = '127.0.0.1'
let s:port = '20'
let s:pass = ''

function! SpaceVim#layers#ssh#config() abort
  let g:_spacevim_mappings_space.S = {'name' : '+SSH'}
  call SpaceVim#mapping#space#langSPC('nmap', ['S','o'],
        \ 'call SpaceVim#layers#ssh#connect()',
        \ 'connect-to-ssh-server', 1)
  command! -nargs=* SSHCommand call s:run(<q-args>)
endfunction

function! SpaceVim#layers#ssh#set_variable(opt) abort
  let s:ssh = get(a:opt, 'ssh_command', s:ssh)
  let s:user = get(a:opt, 'ssh_user', s:user)
  let s:ip = get(a:opt, 'ssh_address', s:ip)
  let s:port = get(a:opt, 'ssh_port', s:port)
  let s:pass = get(a:opt, 'ssh_password', s:pass)
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

  return ['ssh_port', 'ssh_user', 'ssh_address', 'ssh_command', 'ssh_password']

endfunction

function! SpaceVim#layers#ssh#health() abort
  call SpaceVim#layers#ssh#config()
  return 1
endfunction

function! s:run(cmd) abort
  let s:NOT.notify_max_width = &columns * 0.70
  let s:NOT.timeout = 5000
  call s:JOB.start(['plink', s:user . '@' . s:ip, '-P', s:port, '-pw', s:pass, a:cmd . ' 2>&1'], 
        \ {
          \ 'on_stdout' : function('s:on_stdout'),
          \ 'on_stderr' : function('s:on_stderr')
          \ })
endfunction


function! s:on_stdout(id, data, event) abort
  for line in a:data
    call s:NOT.notify(line)
  endfor
endfunction

function! s:on_stderr(id, data, event) abort
  for line in a:data
    call s:NOT.notify(line, 'WarningMsg')
  endfor
endfunction
