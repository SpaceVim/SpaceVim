"=============================================================================
" notify.vim --- notification for chatting
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:NOTI = SpaceVim#api#import('notify')
let s:NOTI.notify_max_width = &columns * 0.50
let s:NOTI.timeout = 5000


function! chat#notify#noti(msg) abort

  call s:NOTI.notify(a:msg)

endfunction
