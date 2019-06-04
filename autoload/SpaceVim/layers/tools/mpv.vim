"=============================================================================
" mpv.vim --- mpv layer for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#tools#mpv#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ['a', 'm'],
        \ '', 'list music', 0)
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
function! SpaceVim#layers#tools#mpv#stop() abort
    if s:playId != 0
        call jobstop(s:playId)
        let s:playId = 0
    endif
    delcommand MStop
endfunction
function! SpaceVim#layers#tools#mpv#play(file,...) abort
    if has('nvim')
        if s:playId != 0
            call jobstop(s:playId)
            let s:playId = 0
        endif
        let s:playId =  jobstart(['mpv','--vid=no',a:file],{
                    \ 'on_stdout': function('s:handler'),
                    \ 'on_stderr': function('s:handler'),
                    \ 'on_exit': function('s:handler'),
                    \ })
    else
        if type(s:playId) == 8 && job_status(s:playId) ==# 'run'
            call job_stop(s:playId)
            let s:playId =0
        endif
        let s:playId = job_start(['mpv','--vid=no',a:file])
    endif
    command! MStop call zvim#mpv#stop()
endfunction
