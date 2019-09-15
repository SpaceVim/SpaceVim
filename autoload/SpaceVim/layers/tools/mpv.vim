"=============================================================================
" mpv.vim --- mpv layer for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


let s:JOB = SpaceVim#api#import('job')


function! SpaceVim#layers#tools#mpv#config() abort

endfunction

function! SpaceVim#layers#tools#mpv#loadMusics() abort
  let musics = SpaceVim#util#globpath('~/Musics', '*.mp3')
  let g:unite_source_menu_menus.MpvPlayer.command_candidates = []
  for m in musics
    call add(g:unite_source_menu_menus.MpvPlayer.command_candidates,
          \ [fnamemodify(m, ':t'),
          \ "call SpaceVim#layers#tools#mpv#play('" . m . "')"])
  endfor
endfunction


let s:playId = 0
fu! s:handler(id, data, event) abort
  if a:event ==# 'exit'
    echom 'job ' . a:id . ' exit with code:' . string(a:data)
    let s:playId = 0
  endif
endf
function! s:stop() abort
  if s:playId != 0
    call jobstop(s:playId)
    let s:playId = 0
  endif
  delcommand MStop
endfunction
function! s:play(file,...) abort
  if s:playId != 0
    call s:JOB.stop(s:playId)
    let s:playId = 0
  endif
  let s:playId =  s:JOB.start(['mpv','--vid=no',a:file],{
        \ 'on_stdout': function('s:handler'),
        \ 'on_stderr': function('s:handler'),
        \ 'on_exit': function('s:handler'),
        \ })
  command! MStop call zvim#mpv#stop()
endfunction
