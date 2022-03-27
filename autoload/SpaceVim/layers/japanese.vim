"=============================================================================
" japanese.vim --- SpaceVim japanese layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#japanese#plugins() abort
    return [
          \ ['vim-jp/vimdoc-ja', {'merged' : 0}],
          \ ]
endfunction

function! SpaceVim#layers#japanese#config() abort
endfunction

function! SpaceVim#layers#japanese#health() abort
  call SpaceVim#layers#japanese#plugins()
  call SpaceVim#layers#japanese#config()
  return 1
endfunction
