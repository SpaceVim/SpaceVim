"=============================================================================
" provider.vim --- override rtp
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! provider#Poll(argv, orig_name, log_env) abort
  let opt = {'rpc': v:true, 'stderr_buffered': v:true, 'on_stderr': funcref('s:OnError')}
  try
    let channel_id = jobstart(a:argv, opt)
    if channel_id > 0
      return channel_id
    endif
  catch
    echomsg v:throwpoint
    echomsg v:exception
    for row in get(opt, 'stderr', [])
      echomsg row
    endfor
  endtry
  throw remote#host#LoadErrorForHost(a:orig_name, a:log_env)
endfunction
function! s:OnError(id, data, event) abort
  if !empty(a:data)
    echohl Error
    for row in a:data
      echomsg row
    endfor
    echohl None
  endif
endfunction
