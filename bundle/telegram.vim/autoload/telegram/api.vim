"=============================================================================
" api.vim --- the list of telegram apis
" Copyright (c) 2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://github.com/wsdjeg/telegram.vim
" License: GPLv3
"=============================================================================



function! telegram#api#getMe(token, callback) abort

endfunction


function! telegram#api#getUpdates(token, callback) abort

  call s:request('/getUpdates', a:callback, {'chat_id' : a:chat_id})

endfunction

" the callback will receive two argv:
" callback(chat_id, result)
function! telegram#api#getChatMemberCount(token, chat_id, callback) abort

  call s:request('/getChatMemberCount', a:callback, {'chat_id' : a:chat_id})

endfunction


function! telegram#api#getChat(token, chat_id, callback) abort

  call s:request('/getChat', a:callback, {'chat_id' : a:chat_id})

endfunction


let s:JOB = SpaceVim#api#import('job')

function! s:request_stdout(id, data, event) abort
  call call(s:request_ids[a:id].callback, [s:request_ids[a:id].request_data, a:data])
endfunction

function! s:request_stderr(id, data, event) abort
  
endfunction

function! s:request_exit(id, data, event) abort
  
endfunction


" 每一次请求，都会有一个请求 ID，callback 函数针对这个请求ID进行回调。
let s:request_ids = {}
function! s:request(uri, callback, ...) abort
  let json = get(a:000, 0, {})
  let cmd = ['curl','-s', '-X', 'POST', 'https://api.telegram.org/bot' . g:telegram_bot_token . a:uri,
        \ '-H', 'Content-Type: application/json',
        \ '-d', json_encode(json)
        \ ]
  call extend(s:request_ids, { s:JOB.start(cmd, {
        \ 'on_stdout' : function('s:request_stdout'),
        \ 'on_stderr' : function('s:request_stderr'),
        \ 'on_exit' : function('s:request_exit'),
        \ 'env' : {
          \ 'http_proxy' : g:telegram_http_proxy,
          \ 'https_proxy' : g:telegram_http_proxy,
          \ }
          \ }) : {'callback' : a:callback, 'request_data' : json } } )
endfunction
