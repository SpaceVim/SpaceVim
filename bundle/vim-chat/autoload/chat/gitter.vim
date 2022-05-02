"=============================================================================
" gitter.vim --- a gitter client
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if exists('s:room_jobs')
  finish
endif


let s:JOB = SpaceVim#api#import('job')
let s:JSON = SpaceVim#api#import('data#json')
let s:LOG = SpaceVim#logger#derive('gitter')

let g:chat_gitter_token = get(g:, 'chat_gitter_token', '')

let s:room_jobs = {}
function! chat#gitter#enter_room(room) abort
  if !has_key(s:room_jobs, a:room)
    let roomid = s:room_to_roomid(a:room)
    call s:fetch(roomid)
    let cmd = printf('curl -s -N -H "Accept: application/json" -H "Authorization: Bearer %s" "https://stream.gitter.im/v1/rooms/%s/chatMessages"',g:chat_gitter_token , roomid)
    let jobid = s:JOB.start(cmd, {
          \ 'on_stdout' : function('s:gitter_stdout'),
          \ 'on_stderr' : function('s:gitter_stderr'),
          \ 'on_exit' : function('s:gitter_exit'),
          \ })
    let s:room_jobs[a:room] = jobid
  endif
endfunction

function! s:room_to_roomid(room) abort
  let room = filter(deepcopy(s:channels), 'has_key(v:val, "uri") && v:val.uri ==# a:room')
  if !empty(room)
    return room[0].id
  else
    return ''
  endif
endfunction

function! s:roomid_to_room(roomid) abort
  let room = filter(deepcopy(s:channels), 'has_key(v:val, "id") && has_key(v:val, "uri")  && v:val.id ==# a:roomid')
  if !empty(room)
    return room[0].uri
  else
    return ''
  endif
endfunction


function! s:gitter_stdout(id, data, event) abort
  for line in a:data
    if line !~# '^\s*$'
      call s:LOG.debug(line)
    endif
  endfor
  for room in keys(s:room_jobs)
    if s:room_jobs[room] ==# a:id
      let message = join(a:data, '') 
      if message =~# '^\s*$'
        " skip empty string or space
        return
      endif
      let msg = s:JSON.json_decode(message)
      call chat#windows#push({
            \ 'user' : msg.fromUser.displayName,
            \ 'username' : msg.fromUser.username,
            \ 'room' : room,
            \ 'msg' : msg.text,
            \ 'time': s:format_time(msg.sent),
            \ })
      if !chat#windows#is_opened()
            \ && s:enable_notify(room)
        call chat#notify#noti(msg.fromUser.displayName . ': ' . msg.text)
      endif
      return
    endif
  endfor
endfunction

function! s:enable_notify(room) abort
  let room = filter(deepcopy(s:channels), 'has_key(v:val, "uri") && v:val.uri ==# a:room && has_key(v:val, "lurk")')
  if !empty(room)
    return room[0].lurk
  else
    return 0
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

let s:fetch_response = {}
function! s:fetch(roomid) abort
  let room = s:roomid_to_room(a:roomid)
  if !has_key(s:fetch_response, room)
    let cmd = printf( 'curl -s -H "Accept: application/json" -H "Authorization: Bearer %s" "https://api.gitter.im/v1/rooms/%s/chatMessages?limit=50"', g:chat_gitter_token, a:roomid)
    let jobid = s:JOB.start(cmd, {
          \ 'on_stdout' : function('s:gitter_fetch_stdout'),
          \ 'on_stderr' : function('s:gitter_fetch_stderr'),
          \ 'on_exit' : function('s:gitter_fetch_exit'),
          \ })
    let s:fetch_response[room] = {
          \ 'jobid' : jobid,
          \ 'response' : [],
          \ }
  endif
endfunction

function! s:gitter_fetch_stdout(id, data, event) abort
  for line in a:data
    call s:LOG.debug(line)
  endfor
  for room in keys(s:fetch_response)
    if s:fetch_response[room].jobid ==# a:id
      let s:fetch_response[room].response += a:data
      break
    endif
  endfor
endfunction

function! s:gitter_fetch_stderr(id, data, event) abort
  for line in a:data
    call s:LOG.debug(line)
  endfor

endfunction

function! s:gitter_fetch_exit(id, data, event) abort
  call s:LOG.debug(a:data)
  for room in keys(s:fetch_response)
    if s:fetch_response[room].jobid ==# a:id
      let messages = s:JSON.json_decode(join(s:fetch_response[room].response, ''))
      let msgs = []
      for msg in messages
        call add(msgs, {
              \ 'user' : msg.fromUser.displayName,
              \ 'username' : msg.fromUser.username,
              \ 'room' : room,
              \ 'msg' : msg.text,
              \ 'time': s:format_time(msg.sent),
              \ })
      endfor
      call chat#windows#push(msgs)
      break
    endif
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
  for line in a:data
    call s:LOG.debug(line)
  endfor
  let s:list_all_channels_result = s:list_all_channels_result + a:data
endfunction
function! s:get_all_channels_stderr(id, data, event) abort
  for line in a:data
    call s:LOG.debug(line)
  endfor

endfunction
function! s:get_all_channels_exit(id, data, event) abort
  call s:LOG.debug(a:data)
  if a:data ==# 0
    let s:channels = s:JSON.json_decode(join(s:list_all_channels_result, ''))
  endif
endfunction

function! Test(str) abort
  exe a:str
endfunction

function! chat#gitter#send(room, msg) abort
  let roomid = s:room_to_roomid(a:room)
  " the win 11 curl in system32/ directory do not support unicode, use
  " neovim's curl
  if has('nvim') && exists('v:progpath') && (has('win64') || has('win32'))
    let curl = fnamemodify(v:progpath, ':h') . '\curl.exe'
  else
    let curl = 'curl'
  endif
  let cmd = [curl, '-X', 'POST', '-H', 'Content-Type: application/json', '-H', 'Accept: application/json',
        \ '-H', 'Authorization: Bearer ' . g:chat_gitter_token,
        \ printf('https://api.gitter.im/v1/rooms/%s/chatMessages', roomid),
        \ '-d',
        \ s:JSON.json_encode({'text' : a:msg})
        \ ]
  call s:JOB.start(cmd)
endfunction

function! chat#gitter#get_user_count(room) abort
  let room = filter(deepcopy(s:channels), 'has_key(v:val, "uri") && v:val.uri ==# a:room')
  if !empty(room)
    return room[0].userCount . ' PEOPLE'
  else
    return ''
  endif

endfunction
