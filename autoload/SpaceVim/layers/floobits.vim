"=============================================================================
" floobits.vim --- SpaceVim floobits layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#floobits#plugins() abort
  let plugins = [
        \ ['floobits/floobits-neovim',      { 'on_cmd' : ['FlooJoinWorkspace','FlooShareDirPublic','FlooShareDirPrivate']}],
        \ ]
  return plugins
endfunction 


function! SpaceVim#layers#floobits#config() abort
  let g:_spacevim_mappings_space.m.f = {'name' : '+floobits'}
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'f', 'c'], 'silent call call('
        \ . string(s:_function('s:floobits_clear_highlights')) . ', [])',
        \ 'Clears all mirrored highlights', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'f', 'd'], 'silent call call('
        \ . string(s:_function('s:floobits_load_rcfile')) . ', [])',
        \ 'Load floobits rcfile', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'f', 'f'], 'silent call call('
        \ . string(s:_function('s:floobits_follow_user')) . ', [])',
        \ 'Follow a users changes', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'f', 'j'], 'silent call call('
        \ . string(s:_function('s:floobits_join_workspace')) . ', [])',
        \ 'Join an existing floobits workspace', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'f', 'l'], 'silent call call('
        \ . string(s:_function('s:floobits_leave_workspace')) . ', [])',
        \ 'Leave floobits workspace', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'f', 'R'], 'silent call call('
        \ . string(s:_function('s:floobits_share_dir_private')) . ', [])',
        \ 'Share dir private', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'f', 'U'], 'silent call call('
        \ . string(s:_function('s:floobits_share_dir_public')) . ', [])',
        \ 'Share dir public', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'f', 's'], 'silent call call('
        \ . string(s:_function('s:floobits_summon')) . ', [])',
        \ 'Summon everyone', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'f', 't'], 'silent call call('
        \ . string(s:_function('s:floobits_follow_mode_toggle')) . ', [])',
        \ 'Toggle following of recent changes', 1)
endfunction

function! s:floobits_follow_mode_toggle() abort
  
endfunction

function! s:floobits_summon() abort
  
endfunction

function! s:floobits_clear_highlights() abort
  
endfunction

function! s:floobits_follow_user() abort
  
endfunction

function! s:floobits_load_rcfile() abort
  
endfunction

function! s:floobits_join_workspace() abort
  
endfunction

function! s:floobits_leave_workspace() abort
  
endfunction

function! s:floobits_share_dir_private() abort
  
endfunction

function! s:floobits_share_dir_public() abort
  
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
