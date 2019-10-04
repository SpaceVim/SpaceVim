"=============================================================================
" server.vim --- server manager for SpaceVim
" Copyright (c) 2016-2019 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


let s:SYS = SpaceVim#api#import('system')

" This function should not be called twice!

let s:flag = 0
function! SpaceVim#server#connect() abort
  if s:flag == 0
    if empty($SPACEVIM_SERVER_ADDRESS)
      " in windows pipe server is used.
      " call serverstart('\\.\pipe\nvim-pipe-1234')
      if s:SYS.isWindows
        let $SPACEVIM_SERVER_ADDRESS = fnamemodify('\\.\pipe\' . (has('nvim') ? 'spacevim-nvim-' : 'spacevim-vim-') . 'server', ':p')
      else
        let $SPACEVIM_SERVER_ADDRESS = fnamemodify('/tmp/' . (has('nvim') ? 'spacevim_nvim_' : 'spacevim_vim_') . 'server', ':p')
      endif
    endif
    if has('nvim')
      try
        call serverstart($SPACEVIM_SERVER_ADDRESS)
        call SpaceVim#logger#info('SpaceVim server startup at:' . $SPACEVIM_SERVER_ADDRESS)
      catch
      endtry
    elseif has('clientserver') && exists('*remote_startserver')
      if index(split(serverlist(), "\n"), $SPACEVIM_SERVER_ADDRESS) == -1
        try
          call remote_startserver($SPACEVIM_SERVER_ADDRESS)
          call SpaceVim#logger#info('SpaceVim server startup at:' . $SPACEVIM_SERVER_ADDRESS)
        catch
        endtry
      endif
    endif
    let s:flag = 1
  endif
endfunction


function! SpaceVim#server#export_server() abort
  if executable('export')
    call system('export $TEST_SPACEVIM="test"') 
  endif
endfunction

function! SpaceVim#server#terminate() abort

endfunction

function! SpaceVim#server#list() abort
  if has('nvim')
    return join(serverlist(), "\n")
  else
  endif
endfunction



