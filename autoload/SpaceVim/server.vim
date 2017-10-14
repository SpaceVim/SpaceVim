"=============================================================================
" server.vim --- server manager for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================




function! SpaceVim#server#connect()
    if empty($SPACEVIM_SERVER_ADDRESS)
        let $SPACEVIM_SERVER_ADDRESS = serverlist()[0]
        return 0
    else
        call sockconnect('pipe',  $SPACEVIM_SERVER_ADDRESS, {'rpc' : 1})
        return 1
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



