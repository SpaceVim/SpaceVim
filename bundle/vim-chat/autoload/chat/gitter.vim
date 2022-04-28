"=============================================================================
" gitter.vim --- a gitter client
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:JOB = SpaceVim#api#import('job')
let s:JSON = SpaceVim#api#import('data#json')
let s:LOG = SpaceVim#logger#derive('gitter')

function! chat#gitter#start() abort
  call s:JOB.start(g:gitter_char_command, {
        \ 'on_stdout' : function('s:gitter_stdout'),
        \ 'on_stderr' : function('s:gitter_stderr'),
        \ 'on_exit' : function('s:gitter_exit'),
        \ })
endfunction


" {
"   "id": "626ab3bd9db19366b2035690",
"   "text": "we are going to add a gitter client for spacevim.",
"   "html": "we are going to add a gitter client for spacevim.",
"   "sent": "2022-04-28T15:33:17.0 09Z",
"   "readBy": 0,
"   "urls": [],
"   "mentions": [],
"   "issues": [],
"   "meta": [],
"   "v": 1,
"   "fromUser": {
"     "id": "55f95b9b0fc9f982beb0dbb5",
"     "username": "wsdjeg",
"     "displayName": "Wang Shidong",
"     "url": "/wsdjeg",
"     "av atarUrl": "https://avatars-05.gitter.im/gh/uv/4/wsdjeg",
"     "avatarUrlSmall": "https://avatars2.githubusercontent.com/u/13142418?v=4&s=60",
"     "avatarUrlMedium": "https://avatars2.githubuserc ontent.com/u/13142418?v=4&s=128",
"     "v": 338,
"     "gv": "4"
"   }
" }
function! s:gitter_stdout(id, data, event) abort
  for line in a:data
    call s:LOG.debug(line)
  endfor
  let message = join(a:data, '') 
  let msg = s:JSON.json_decode(message)
  call chat#notify#noti(msg.fromUser.displayName . ': ' . msg.text)
endfunction

function! s:gitter_stderr(id, data, event) abort
  for line in a:data
    call s:LOG.debug(line)
  endfor

endfunction

function! s:gitter_exit(id, data, event) abort
  call s:LOG.debug(a:data)

endfunction
