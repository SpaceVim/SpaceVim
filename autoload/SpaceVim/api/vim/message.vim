"=============================================================================
" message.vim --- SpaceVim message API
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section vim#message, api-vim-message
" @parentsection api
" `vim#message` API provide functions for generating colored message in vim's
" command line.
" >
"   let s:MSG = SpaceVim#api#import('vim#message')
"   call s:MSG.echo('WarningMsg', 'hello world!')
" <
" @subsection functions
"
" echo({hi}, {msg})
"
"   print message with {hi} highlight group. The {msg} starts on a new line.
"
" echon({hi}, {msg})
"
"   print message with {hi} highlight group. The {msg} will be displayed
"   without anything added.
"
" echomsg({hi}, {msg})
"
"   print message with {hi} highlight group. The {msg} starts on a new line.
"   The {msg} also will be added to `:messages` history.
"
" error({msg})
"
"   same as `echomsg('Error', {msg})`
"
" warn({msg})
"
"   same as `echomsg('WarningMsg', {msg})`
"
" confirm({msg})
"   
"   promote a confirm message, accept user input `y/n`.

let s:self = {}

function! s:self.echo(hl, msg) abort
  execute 'echohl' a:hl
  try
    echo a:msg
  finally
    echohl None
  endtry
endfunction

function! s:self.echon(hl, msg) abort
  execute 'echohl' a:hl
  try
    echon a:msg
  finally
    echohl None
  endtry
endfunction

function! s:self.echomsg(hl, msg) abort
  execute 'echohl' a:hl
  try
    for m in split(a:msg, "\n")
      echomsg m
    endfor
  finally
    echohl None
  endtry
endfunction

function! s:self.error(msg) abort
  call self.echomsg('ErrorMsg', a:msg)
endfunction

function! s:self.warn(msg) abort
  call self.echomsg('WarningMsg', a:msg)
endfunction

function! s:self.confirm(msg) abort
  echohl WarningMsg
  echon a:msg . '? (y or n) '
  echohl NONE
  let rst = nr2char(getchar())
  " clear the cmdline
  redraw!
  if rst =~? 'y' || rst == nr2char(13)
    return 1
  else
    return 0
  endif
endfunction


function! SpaceVim#api#vim#message#get() abort
  return deepcopy(s:self)
endfunction
