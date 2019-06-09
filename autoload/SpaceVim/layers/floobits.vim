"=============================================================================
" floobits.vim --- SpaceVim floobits layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#floobits#plugins() abort
  let plugins = [
        \ ['floobits/floobits-neovim',      { 'on_cmd' : [
        \ 'FlooJoinWorkspace',
        \ 'FlooShareDirPublic',
        \ 'FlooShareDirPrivate'
        \ ]}],
        \ ]
  return plugins
endfunction 


function! SpaceVim#layers#floobits#config() abort
  let g:_spacevim_mappings_space.m.f = {'name' : '+floobits'}
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'f', 'j'], 'FlooJoinWorkspace',
        \ 'Join workspace', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'f', 't'], 'FlooToggleFollowMode',
        \ 'Toggle follow mode', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'f', 's'], 'FlooSummon',
        \ 'Summon everyone', 1)
endfunction

