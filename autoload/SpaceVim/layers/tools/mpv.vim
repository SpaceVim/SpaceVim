"=============================================================================
" mpv.vim --- mpv layer for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if exists('s:musics_directory')
  finish
else
  let s:musics_directory = '~/Musics'
  let s:mpv_interpreter = 'mpv'
  let s:loop_mode = 'random'
  let s:stop_mpv = 0
endif

let s:JOB = SpaceVim#api#import('job')
let s:NUM = SpaceVim#api#import('data#number')


function! SpaceVim#layers#tools#mpv#config() abort
  let g:_spacevim_mappings_space.m.m = {'name' : '+mpv'}
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'm', 'l'], 'call call('
        \ . string(s:_function('s:list_music')) . ', [])',
        \ 'fuzzy-find-musics', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'm', 'n'], 'call call('
        \ . string(s:_function('s:next')) . ', [])',
        \ 'next-music', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'm', 's'], 'call call('
        \ . string(s:_function('s:stop')) . ', [])',
        \ 'stop-mpv', 1)
endfunction

function! s:list_music() abort
  call s:load_musics()
  if SpaceVim#layers#isLoaded('leaderf')
    Leaderf menu --name MpvPlayer
  elseif SpaceVim#layers#isLoaded('denite')
    Denite menu:MpvPlayer
  else
  endif
endfunction

function! SpaceVim#layers#tools#mpv#set_variable(var) abort
  let s:musics_directory = get(a:var, 'musics_directory', 1)
  let s:mpv_interpreter = get(a:var, 'mpv_interpreter', 1)
endfunction

function! SpaceVim#layers#tools#mpv#play(fpath)
  let s:stop_mpv = 0
  if s:playId != 0
    call s:JOB.stop(s:playId)
    let s:playId = 0
  endif
  let s:playId =  s:JOB.start([s:mpv_interpreter,'--vid=no',a:fpath],{
        \ 'on_stdout': function('s:handler'),
        \ 'on_stderr': function('s:handler'),
        \ 'on_exit': function('s:handler'),
        \ })
  command! MStop call s:stop()
endfunction

function! s:load_musics() abort
  let musics = SpaceVim#util#globpath(s:musics_directory, '*.mp3')
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
    if s:loop_mode ==# 'random' && !s:stop_mpv
      let next = s:NUM.random(0, len(g:unite_source_menu_menus.MpvPlayer.command_candidates))
      echohl TODO
      echo 'playing:' . g:unite_source_menu_menus.MpvPlayer.command_candidates[next][0]
      echohl NONE
      exe g:unite_source_menu_menus.MpvPlayer.command_candidates[next][1]
    endif
  endif
endf
function! s:stop() abort
  if s:playId != 0
    call s:JOB.stop(s:playId)
    let s:playId = 0
  endif
  delcommand MStop
  let s:stop_mpv = 1
endfunction

function! s:next() abort
  if s:playId != 0
    call s:JOB.stop(s:playId)
    let s:playId = 0
  endif
endfunction


" function() wrapper
if v:version > 703 || v:version == 703 && has('patch1170')
  function! s:_function(fstr) abort
    return function(a:fstr)
  endfunction
else
  function! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endfunction
  let s:_s = '<SNR>' . s:_SID() . '_'
  function! s:_function(fstr) abort
    return function(substitute(a:fstr, 's:', s:_s, 'g'))
  endfunction
endif
