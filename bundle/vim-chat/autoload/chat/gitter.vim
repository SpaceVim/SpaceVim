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

let s:room = ''
let s:jobid = -1

let g:chat_gitter_token = get(g:, 'chat_gitter_token', '')

function! chat#gitter#start() abort
  if s:jobid <= 0
    let s:room = 'SpaceVim'
    call s:fetch()
    let s:jobid = s:JOB.start(g:gitter_char_command, {
          \ 'on_stdout' : function('s:gitter_stdout'),
          \ 'on_stderr' : function('s:gitter_stderr'),
          \ 'on_exit' : function('s:gitter_exit'),
          \ })
  endif
endfunction


function! s:fetch() abort
  let s:fetch_response = []
  call s:JOB.start(g:gitter_fetch_command, {
        \ 'on_stdout' : function('s:gitter_fetch_stdout'),
        \ 'on_stderr' : function('s:gitter_fetch_stderr'),
        \ 'on_exit' : function('s:gitter_fetch_exit'),
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
  if chat#windows#is_opened()
    call chat#windows#push({
          \ 'user' : msg.fromUser.displayName,
          \ 'room' : s:room,
          \ 'msg' : msg.text,
          \ 'time': s:format_time(msg.sent),
          \ })
  else
    call chat#notify#noti(msg.fromUser.displayName . ': ' . msg.text)
  endif
endfunction

function! s:format_time(t) abort
  return matchstr(a:t, '\d\d\d\d-\d\d-\d\d') . ' ' . matchstr(a:t, '\d\d:\d\d')
endfunction

function! s:gitter_stderr(id, data, event) abort
  for line in a:data
    call s:LOG.debug(line)
  endfor

endfunction

function! s:gitter_exit(id, data, event) abort
  call s:LOG.debug(a:data)
endfunction

function! s:gitter_fetch_stdout(id, data, event) abort
  for line in a:data
    call s:LOG.debug(line)
  endfor
  let s:fetch_response = s:fetch_response + a:data
endfunction

function! s:gitter_fetch_stderr(id, data, event) abort
  for line in a:data
    call s:LOG.debug(line)
  endfor

endfunction

function! s:gitter_fetch_exit(id, data, event) abort
  call s:LOG.debug(a:data)
  let messages = s:JSON.json_decode(join(s:fetch_response, ''))
  for msg in messages
    call chat#windows#push({
          \ 'user' : msg.fromUser.displayName,
          \ 'room' : s:room,
          \ 'msg' : msg.text,
          \ 'time': s:format_time(msg.sent),
          \ })
  endfor
endfunction

let s:channels = []
function! chat#gitter#get_channels() abort
  if empty(s:channels)
    call s:get_all_channels()
    return []
  else
    let rooms = filter(deepcopy(s:channels), 'has_key(v:val, "uri")')
    return map(rooms, 'v:val.uri')
  endif
endfunction


let s:list_all_channels_jobid = -1
let s:list_all_channels_result = []
function! s:get_all_channels() abort
  if s:list_all_channels_jobid <= 0
    let cmd = printf('curl -s -H "Accept: application/json" -H "Authorization: Bearer %s" "https://api.gitter.im/v1/rooms"', g:chat_gitter_token)
    let s:list_all_channels_jobid =  s:JOB.start(cmd, {
          \ 'on_stdout' : function('s:get_all_channels_stdout'),
          \ 'on_stderr' : function('s:get_all_channels_stderr'),
          \ 'on_exit' : function('s:get_all_channels_exit'),
          \ })
  endif
endfunction

function! s:get_all_channels_stdout(id, data, event) abort
  let s:list_all_channels_result = s:list_all_channels_result + a:data
endfunction
function! s:get_all_channels_stderr(id, data, event) abort

endfunction
function! s:get_all_channels_exit(id, data, event) abort
  let s:channels = s:JSON.json_decode(join(s:list_all_channels_result, ''))
endfunction

function! chat#gitter#send(msg) abort
  call s:JOB.start(printf(g:gitter_send_command, substitute(a:msg, '"', '\\\"', 'g')))
endfunction
