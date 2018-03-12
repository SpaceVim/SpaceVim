"=============================================================================
" leaderf.vim --- leaderf layer for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#leaderf#plugins() abort
  let plugins = []
  call add(plugins, 
        \ ['Yggdroot/LeaderF',                { 'on_cmd' : 'LeaderfFile',
        \ 'loadconf' : 1,
        \ 'merged' : 0}])
  return plugins
endfunction

