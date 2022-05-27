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

" the win 11 curl in system32/ directory do not support unicode, use
" neovim's curl
if has('nvim') && exists('v:progpath') && (has('win64') || has('win32'))
  let s:curl = fnamemodify(v:progpath, ':h') . '\curl.exe'
else
  let s:curl = 'curl'
endif

let g:chat_gitter_token = get(g:, 'chat_gitter_token', '')

let s:room_jobs = {}
function! chat#gitter#enter_room(room) abort
  let roomid = s:room_to_roomid(a:room)
  if empty(roomid)
    return 0
  endif
  if !has_key(s:fetch_response, a:room)
    call s:fetch(roomid)
  endif
  if !has_key(s:room_jobs, a:room)
    let cmd = [s:curl, '-s', '--show-error', '--fail', '-N',
          \ '-H', 'Accept: application/json',
          \ '-H', printf('Authorization: Bearer %s', g:chat_gitter_token),
          \ printf('https://stream.gitter.im/v1/rooms/%s/chatMessages', roomid)
          \ ]
    let s:room_jobs[a:room] = s:JOB.start(cmd, {
          \ 'on_stdout' : function('s:gitter_stream_stdout'),
          \ 'on_stderr' : function('s:gitter_stream_stderr'),
          \ 'on_exit' : function('s:gitter_stream_exit'),
          \ })
    call chat#windows#push({
          \ 'user' : '--->',
          \ 'username' : '--->',
          \ 'room' : a:room,
          \ 'msg' : 'connected to channel!',
          \ 'time': strftime("%Y-%m-%d %H:%M"),
          \ })
  endif
  return 1
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


function! s:gitter_stream_stdout(id, data, event) abort
  for line in a:data
    if line !~# '^\s*$'
      call s:LOG.debug('gitter_stream_stdout :' . line)
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

function! s:gitter_stream_stderr(id, data, event) abort
  for line in a:data
    call s:LOG.debug('gitter_stream_stderr :' . line)
  endfor

endfunction

function! s:gitter_stream_exit(id, data, event) abort
  call s:LOG.debug('gitter_stream_exit :' . a:data)
  for room in keys(s:room_jobs)
    if s:room_jobs[room] ==# a:id
      call chat#windows#push({
            \ 'user' : '--->',
            \ 'username' : '--->',
            \ 'room' : room,
            \ 'msg' : 'The channel is disconnected.',
            \ 'time': strftime("%Y-%m-%d %H:%M"),
            \ })
      if !chat#windows#is_opened()
            \ && s:enable_notify(room)
        call chat#notify#noti('The ' . room . ' channel is disconnected.')
      endif
      unlet s:room_jobs[room]
      return
    endif
  endfor
endfunction

let s:fetch_response = {}
function! s:fetch(roomid) abort
  let room = s:roomid_to_room(a:roomid)
  if !has_key(s:fetch_response, room)
    let cmd = [s:curl, '-s', '--show-error', '--fail',
          \ '-H', 'Accept: application/json',
          \ '-H', printf('Authorization: Bearer %s', g:chat_gitter_token),
          \ printf('https://api.gitter.im/v1/rooms/%s/chatMessages?limit=50', a:roomid)
          \ ]
    let s:fetch_response[room] = {
          \ 'stdout' : [],
          \ 'stderr' : [],
          \ 'jobid' : s:JOB.start(cmd,
          \ {
            \ 'on_stdout' : function('s:gitter_fetch_stdout'),
            \ 'on_stderr' : function('s:gitter_fetch_stderr'),
            \ 'on_exit' : function('s:gitter_fetch_exit'),
            \ })
            \ }
    call chat#windows#push({
          \ 'user' : '--->',
          \ 'username' : '--->',
          \ 'room' : room,
          \ 'msg' : 'fetching channel messages',
          \ 'time': strftime("%Y-%m-%d %H:%M"),
          \ })
  endif
endfunction

function! s:gitter_fetch_stdout(id, data, event) abort
  for line in a:data
    call s:LOG.debug('fetch_stdout :' . line)
  endfor
  call s:LOG.debug('s:fetch_response keys :' . string(keys(s:fetch_response)))
  for room in keys(s:fetch_response)
    if s:fetch_response[room].jobid ==# a:id
      let s:fetch_response[room].stdout += a:data
      break
    endif
  endfor
endfunction

function! s:gitter_fetch_stderr(id, data, event) abort
  for line in a:data
    call s:LOG.debug('fetch_stderr :' . line)
  endfor
  for room in keys(s:fetch_response)
    if s:fetch_response[room].jobid ==# a:id
      let s:fetch_response[room].stderr += a:data
      break
    endif
  endfor
endfunction

function! s:gitter_fetch_exit(id, data, event) abort
  call s:LOG.debug('fetch job exit code :' . a:data)
  for room in keys(s:fetch_response)
    if s:fetch_response[room].jobid ==# a:id
      if !empty(s:fetch_response[room].stdout)
        let messages = s:JSON.json_decode(join(s:fetch_response[room].stdout, ''))
        let msgs = []
        for msg in messages
          call add(msgs, {
                \ 'user' : msg.fromUser.displayName,
                \ 'username' : msg.fromUser.username,
                \ 'room' : room,
                \ 'msg' : msg.text,
                \ 'replyCounts' : get(msg, 'threadMessageCount', 0),
                \ 'time': s:format_time(msg.sent),
                \ })
        endfor
        call chat#windows#push(msgs)
        call chat#windows#push({
              \ 'user' : '--->',
              \ 'username' : '--->',
              \ 'room' : room,
              \ 'msg' : 'fetch channel message done!',
              \ 'time': strftime("%Y-%m-%d %H:%M"),
              \ })
        return
      else
        call chat#windows#push({
              \ 'user' : '--->',
              \ 'username' : '--->',
              \ 'room' : room,
              \ 'msg' : 'failed to fetch message.',
              \ 'time': strftime("%Y-%m-%d %H:%M"),
              \ })
        unlet s:fetch_response[room]
      endif
      return
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
let s:list_all_channels_stdout = []
let s:list_all_channels_stderr = []
function! s:get_all_channels() abort
  if s:list_all_channels_jobid <= 0
    call chat#windows#push({
          \ 'user' : '--->',
          \ 'username' : '--->',
          \ 'room' : '',
          \ 'protocol' : 'gitter',
          \ 'msg' : 'listing gitter channels',
          \ 'time': strftime("%Y-%m-%d %H:%M"),
          \ })
    let cmd = [s:curl, '-s', '--show-error', '--fail',
          \ '-H', 'Accept: application/json',
          \ '-H', printf('Authorization: Bearer %s', g:chat_gitter_token),
          \ 'https://api.gitter.im/v1/rooms',
          \ ]
    let s:list_all_channels_jobid =  s:JOB.start(cmd, {
          \ 'on_stdout' : function('s:get_all_channels_stdout'),
          \ 'on_stderr' : function('s:get_all_channels_stderr'),
          \ 'on_exit' : function('s:get_all_channels_exit'),
          \ })
  endif
endfunction

function! s:get_all_channels_stdout(id, data, event) abort
  for line in a:data
    call s:LOG.debug('get_all_channels_stdout: ' . line)
  endfor
  let s:list_all_channels_stdout = s:list_all_channels_stdout + a:data
endfunction
function! s:get_all_channels_stderr(id, data, event) abort
  for line in a:data
    call s:LOG.debug('get_all_channels_stderr: ' . line)
  endfor
  let s:list_all_channels_stderr = s:list_all_channels_stderr + a:data
endfunction
" I am not sure if this is a bug. sometimes the exit data is 0, but there no
" stdout, all responses are sent to stderr.
function! s:get_all_channels_exit(id, data, event) abort
  call s:LOG.debug('get_all_channels_exit code: ' . a:data)
  if a:data ==# 0 && !empty(s:list_all_channels_stdout)
    let s:channels = s:JSON.json_decode(join(s:list_all_channels_stdout, ''))
    call chat#windows#push({
          \ 'user' : '--->',
          \ 'username' : '--->',
          \ 'room' : '',
          \ 'protocol' : 'gitter',
          \ 'msg' : 'list channels done!',
          \ 'time': strftime("%Y-%m-%d %H:%M"),
          \ })
    if !chat#windows#is_opened()
      call chat#notify#noti('gitter protocol channels updated!')
    endif
  else
    call chat#windows#push({
          \ 'user' : '--->',
          \ 'username' : '--->',
          \ 'room' : '',
          \ 'protocol' : 'gitter',
          \ 'msg' : 'failed to list channels of gitter protocol!',
          \ 'time': strftime("%Y-%m-%d %H:%M"),
          \ })
    if !chat#windows#is_opened()
      call chat#notify#noti('failed to list channels of gitter protocol!')
    endif
    let s:list_all_channels_jobid = -1
  endif
endfunction

function! Test(str) abort
  exe a:str
endfunction

function! chat#gitter#send(room, msg) abort
  let roomid = s:room_to_roomid(a:room)
  let cmd = [s:curl, '-X', 'POST', '-H', 'Content-Type: application/json', '-H', 'Accept: application/json',
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
