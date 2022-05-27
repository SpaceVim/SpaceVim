"=============================================================================
" FILE: neoyank.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

if exists('g:loaded_neoyank')
  finish
endif

augroup neoyank
  autocmd!
augroup END

if exists('##TextYankPost')
  autocmd neoyank FocusGained,FocusLost *
        \ silent call neoyank#_append()
  autocmd neoyank TextYankPost *
        \ silent call neoyank#_yankpost()
else
  autocmd neoyank CursorMoved,FocusGained,FocusLost,VimLeavePre *
        \ silent call neoyank#_append()
  if v:version > 703 || v:version == 703 && has('patch867')
    autocmd neoyank TextChanged *
          \ silent call neoyank#_append()
  endif
endif

let g:loaded_neoyank = 1
