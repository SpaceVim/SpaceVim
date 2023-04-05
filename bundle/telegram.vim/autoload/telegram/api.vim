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


let s:JOB = SpaceVim#api#import('job')

function! s:request(uri, callback, ...) abort
  let json = get(a:000, 0, {})
  let cmd = ['curl','-s', '-X', 'POST', 'https://api.telegram.org/bot' . g:telegram_bot_token . a:uri,
        \ '-H', 'Content-Type: application/json',
        \ '-d', json_encode(json)
        \ ]
  call s:JOB.start(cmd, {
        \ 'on_stdout' : a:callback,
        \ 'on_stderr' : a:callback,
        \ 'on_exit' : a:callback,
        \ 'env' : {
          \ 'http_proxy' : g:telegram_http_proxy,
          \ 'https_proxy' : g:telegram_http_proxy,
          \ }
        \ })
endfunction
