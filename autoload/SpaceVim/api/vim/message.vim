" ============================================================================
" File:        message.vim
" Description: vim#message api of SpaceVim
" Author:      L-stt
" Website:     https://spacevim.org
" License:     MIT
" ============================================================================

""
" @section vim#message, api-vim-message
" @parentsection api

function! SpaceVim#api#vim#compatible#get() abort
  return map({
        \ 'echo' : '',
        \ 'echomsg': '',
        \ 'error': '',
        \ 'warn': '',
        \ },
        \ "function('s:' . v:key)"
        \ )
endfunction

function! s:echo(hl, msg) abort
  execute 'echohl' a:hl
  try
    echo a:msg
  finally
    echohl None
  endtry
endfunction

function! s:echomsg(hl, msg) abort
  execute 'echohl' a:hl
  try
    for m in split(a:msg, "\n")
      echomsg m
    endfor
  finally
    echohl None
  endtry
endfunction

function! s:error(msg) abort
  call s:echomsg('ErrorMsg', a:msg)
endfunction

function! s:warn(msg) abort
  call s:echomsg('WarningMsg', a:msg)
endfunction
