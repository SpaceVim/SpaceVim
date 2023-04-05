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

  

endfunction


let s:JOB = SpaceVim#api#import('job')

function! s:request(uri, callback, ...) abort
  let cmd = ['curl', 'https://api.telegram.org/bot' . g:telegram_bot_token . a:uri]
  call s:JOB.start(cmd, {
        \ 'on_stdout' : a:callback,
        \ })
endfunction
