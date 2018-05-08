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
  call SpaceVim#mapping#space#def('nnoremap', ['p', 'c'], 'silent call call('
        \ . string(s:_function('s:floobits_clear_highlights')) . ', [])',
        \ 'Clears all mirrored highlights', 1)
endfunction

 ""     (spacemacs/set-leader-keys
        "Pc" 'floobits-clear-highlights
        "Pd" 'spacemacs/floobits-load-rcfile
        "Pf" 'floobits-follow-user
        "Pj" 'floobits-join-workspace
        "Pl" 'floobits-leave-workspace
        "PR" 'floobits-share-dir-private
        "Ps" 'floobits-summon
        "Pt" 'floobits-follow-mode-toggle
        "PU" 'floobits-share-dir-public))))
function! s:floobits_clear_highlights() abort
  
endfunction

function! s:floobits_follow_user() abort
  
endfunction

function! s:floobits_load_rcfile() abort
  
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
