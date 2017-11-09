"=============================================================================
" server.vim --- server manager for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================




function! SpaceVim#server#connect()
  if empty($SPACEVIM_SERVER_ADDRESS)
    let $SPACEVIM_SERVER_ADDRESS = fnamemodify('/tmp/' . (has('nvim') ? 'spacevim_nvim_' : 'spacevim_vim_') . 'server', ':p')
  endif
  if has('nvim')
    try
      call serverstart($SPACEVIM_SERVER_ADDRESS)
      call SpaceVim#logger#info('SpaceVim server startup at:' . $SPACEVIM_SERVER_ADDRESS)
    catch /Failed to start server: address already in use/
    endtry
  elseif has('clientserver') && exists('*remote_startserver')
    if index(split(serverlist(), "\n"), $SPACEVIM_SERVER_ADDRESS) == -1
      call remote_startserver($SPACEVIM_SERVER_ADDRESS)
      call SpaceVim#logger#info('SpaceVim server startup at:' . $SPACEVIM_SERVER_ADDRESS)
    endif
  endif
endfunction


function! SpaceVim#server#export_server()

  call system('export $TEST_SPACEVIM="test"') 

endfunction

function! SpaceVim#server#terminate()

endfunction

function! SpaceVim#server#list()
  if has('nvim')
    return join(serverlist(), "\n")
  else
  endif
endfunction



