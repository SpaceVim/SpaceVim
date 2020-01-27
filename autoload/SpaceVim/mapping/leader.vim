"=============================================================================
" leader.vim --- mapping leader definition file for SpaceVim
" Copyright (c) 2016-2019 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:file = expand('<sfile>:~')
let s:lnum = expand('<slnum>') + 3
function! SpaceVim#mapping#leader#defindWindowsLeader(key) abort
  if !empty(a:key)
    exe 'nnoremap <silent><nowait> [Window] :<c-u>LeaderGuide "' .
          \ a:key . '"<CR>'
    exe 'nmap ' .a:key . ' [Window]'
    let g:_spacevim_mappings_windows = {}
    nnoremap <silent> [Window]v
          \ :<C-u>split<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.v = ['split',
          \ 'split-window',
          \ [
          \ '[WIN v] is to split windows, switch to the new window',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]V
          \ :<C-u>split +bp<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.V = ['split +bp',
          \ 'split-previous-buffer',
          \ [
          \ '[WIN V] is to split previous buffer, switch to the new window',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]g
          \ :<C-u>vsplit<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.g = ['vsplit',
          \ 'vsplit-window',
          \ [
          \ '[WIN g] is to split previous buffer vertically, switch to the new window',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]G
          \ :<C-u>vsplit +bp<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.G = ['vsplit +bp',
          \ 'vsplit-previous-buffer',
          \ [
          \ '[WIN G] is to split windows vertically, switch to the new window',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]t
          \ :<C-u>tabnew<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.t = ['tabnew',
          \ 'create-new-tab',
          \ [
          \ '[WIN t] is to create new tab',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]o
          \ :<C-u>only<Space><Bar><Space>doautocmd WinEnter<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.o = ['only | doautocmd WinEnter',
          \ 'close-other-windows',
          \ [
          \ '[WIN o] is to close all other windows',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]x
          \ :<C-u>call SpaceVim#mapping#BufferEmpty()<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.x = ['call SpaceVim#mapping#BufferEmpty()',
          \ 'empty-current-buffer',
          \ [
          \ '[WIN x] is to empty current buffer',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]\
          \ :<C-u>b#<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows['\'] = ['b#',
          \ 'switch-to-the-last-buffer',
          \ [
          \ '[WIN \] is to switch to the last buffer',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]Q
          \ :<C-u>close<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.Q = ['close',
          \ 'close-current-windows',
          \ [
          \ '[WIN Q] is to close current windows',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]q
          \ :<C-u>call SpaceVim#mapping#close_current_buffer()<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.q = ['call SpaceVim#mapping#close_current_buffer()',
          \ 'delete-current-windows',
          \ [
          \ '[WIN q] is to delete current windows',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]c
          \ :<C-u>call SpaceVim#mapping#clear_buffers()<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.c = ['call SpaceVim#mapping#clear_buffers()',
          \ 'clear-all-the-buffers',
          \ [
          \ '[WIN c] is to clear all the buffers',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
  endif
endfunction

function! SpaceVim#mapping#leader#defindDeniteLeader(key) abort
  if !empty(a:key)
    if a:key ==# 'F'
      nnoremap <leader>F F
    endif
    exe 'nnoremap <silent><nowait> [denite] :<c-u>LeaderGuide "' .
          \ a:key . '"<CR>'
    exe 'nmap ' .a:key . ' [denite]'
    let g:_spacevim_mappings_denite = {}
    nnoremap <silent> [denite]r
          \ :<C-u>Denite -resume<CR>
    let g:_spacevim_mappings_denite.r = ['Denite -resume',
          \ 'resume denite window']
    nnoremap <silent> [denite]f  :<C-u>Denite file_rec<cr>
    let g:_spacevim_mappings_denite.f = ['Denite file_rec', 'file_rec']
    nnoremap <silent> [denite]i  :<C-u>Denite file_rec/git<cr>
    let g:_spacevim_mappings_denite.i = ['Denite file_rec/git', 'git files']
    nnoremap <silent> [denite]g  :<C-u>Denite grep<cr>
    let g:_spacevim_mappings_denite.g = ['Denite grep', 'denite grep']
    nnoremap <silent> [denite]t  :<C-u>Denite tag<CR>
    let g:_spacevim_mappings_denite.t = ['Denite tag', 'denite tag']
    nnoremap <silent> [denite]T  :<C-u>Denite tag:include<CR>
    let g:_spacevim_mappings_denite.T = ['Denite tag/include',
          \ 'denite tag/include']
    nnoremap <silent> [denite]j  :<C-u>Denite jump<CR>
    let g:_spacevim_mappings_denite.j = ['Denite jump', 'denite jump']
    nnoremap <silent> [denite]h  :<C-u>Denite neoyank<CR>
    let g:_spacevim_mappings_denite.h = ['Denite neoyank', 'denite neoyank']
    nnoremap <silent> [denite]<C-h>  :<C-u>DeniteCursorWord help<CR>
    let g:_spacevim_mappings_denite['<C-h>'] = ['DeniteCursorWord help',
          \ 'denite with cursor word help']
    nnoremap <silent> [denite]o  :<C-u>Denite -buffer-name=outline
          \  -auto-preview outline<CR>
    let g:_spacevim_mappings_denite.o = ['Denite outline', 'denite outline']
    nnoremap <silent> [denite]e  :<C-u>Denite
          \ -buffer-name=register register<CR>
    let g:_spacevim_mappings_denite.e = ['Denite register', 'denite register']
    nnoremap <silent> [denite]<Space> :Denite menu:CustomKeyMaps<CR>
    let g:_spacevim_mappings_denite['<Space>'] = ['Denite menu:CustomKeyMaps',
          \ 'denite customkeymaps']
  endif
endfunction


function! SpaceVim#mapping#leader#getName(key) abort
  if a:key ==# ' '
    return '[SPC]'
  elseif a:key ==# 'g'
    return '[g]'
  elseif a:key ==# 'z'
    return '[z]'
  elseif a:key ==# g:spacevim_windows_leader
    return '[WIN]'
  elseif a:key ==# '\'
    return '<leader>'
  else
    return ''
  endif
endfunction

function! SpaceVim#mapping#leader#defindKEYs() abort
  let g:_spacevim_mappings_prefixs = {}
  if !g:spacevim_vimcompatible && !empty(g:spacevim_windows_leader)
    let g:_spacevim_mappings_prefixs[g:spacevim_windows_leader] = {'name' : '+Window prefix'}
    call extend(g:_spacevim_mappings_prefixs[g:spacevim_windows_leader], g:_spacevim_mappings_windows)
  endif
  let g:_spacevim_mappings_prefixs['g'] = {'name' : '+g prefix'}
  call extend(g:_spacevim_mappings_prefixs['g'], g:_spacevim_mappings_g)
  let g:_spacevim_mappings_prefixs['z'] = {'name' : '+z prefix'}
  call extend(g:_spacevim_mappings_prefixs['z'], g:_spacevim_mappings_z)
  let leader = get(g:, 'mapleader', '\')
  let g:_spacevim_mappings_prefixs[leader] = {'name' : '+Leader prefix'}
  call extend(g:_spacevim_mappings_prefixs[leader], g:_spacevim_mappings)
endfunction


" vim:set et sw=2 cc=80:
