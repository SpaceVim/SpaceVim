"=============================================================================
" leader.vim --- mapping leader definition file for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:file = expand('<sfile>:~')

function! SpaceVim#mapping#leader#defindglobalMappings() abort
  if g:spacevim_enable_insert_leader
    inoremap <silent> <Leader><Tab> <C-r>=MyLeaderTabfunc()<CR>
  endif

  " yark and paste
  xnoremap <Leader>y "+y
  xnoremap <Leader>d "+d
  nnoremap <Leader>p "+p
  nnoremap <Leader>P "+P
  xnoremap <Leader>p "+p
  xnoremap <Leader>P "+P

  cnoremap <Leader><C-F> <C-F>

  " Location list movement
  let g:_spacevim_mappings.l = {'name' : '+Location movement'}
  call SpaceVim#mapping#def('nnoremap', '<Leader>lj', ':lnext<CR>',
        \ 'Jump to next location list position',
        \ 'lnext',
        \ 'Next location list')
  call SpaceVim#mapping#def('nnoremap', '<Leader>lk', ':lprev<CR>',
        \ 'Jump to previous location list position',
        \ 'lprev',
        \ 'Previous location list')
  call SpaceVim#mapping#def('nnoremap', '<Leader>lq', ':lclose<CR>',
        \ 'Close the window showing the location list',
        \ 'lclose',
        \ 'Close location list window')

  " quickfix list movement
  let g:_spacevim_mappings.q = {'name' : '+Quickfix movement'}
  call SpaceVim#mapping#def('nnoremap', '<Leader>qj', ':cnext<CR>',
        \ 'Jump to next quickfix list position',
        \ 'cnext',
        \ 'Next quickfix list')
  call SpaceVim#mapping#def('nnoremap', '<Leader>qk', ':cprev<CR>',
        \ 'Jump to previous quickfix list position',
        \ 'cprev',
        \ 'Previous quickfix list')
  call SpaceVim#mapping#def('nnoremap', '<Leader>qq', ':cclose<CR>',
        \ 'Close quickfix list window',
        \ 'cclose',
        \ 'Close quickfix list window')
  call SpaceVim#mapping#def('nnoremap <silent>', '<Leader>qr', 'q',
        \ 'Toggle recording',
        \ '',
        \ 'Toggle recording mode')
endfunction

let s:lnum = expand('<slnum>') + 3
function! SpaceVim#mapping#leader#defindWindowsLeader(key) abort
  if !empty(a:key)
    exe 'nnoremap <silent><nowait> [Window] :<c-u>LeaderGuide "' .
          \ a:key . '"<CR>'
    exe 'nmap ' .a:key . ' [Window]'
    let g:_spacevim_mappings_windows = {}
    nnoremap <silent> [Window]p
          \ :<C-u>vsplit<CR>:wincmd w<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.p = ['vsplit | wincmd w',
          \ 'vsplit vertically,switch to next window',
          \ [
          \ '[WIN p ] is to split windows vertically, switch to the new window',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]v
          \ :<C-u>split<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.v = ['split',
          \ 'split window',
          \ [
          \ '[WIN v] is to split windows, switch to the new window',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]g
          \ :<C-u>vsplit<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.g = ['vsplit',
          \ 'vsplit window',
          \ [
          \ '[WIN g] is to split windows vertically, switch to the new window',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]t
          \ :<C-u>tabnew<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.t = ['tabnew',
          \ 'create new tab',
          \ [
          \ '[WIN t] is to create new tab',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]o
          \ :<C-u>only<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.o = ['only',
          \ 'Close other windows',
          \ [
          \ '[WIN o] is to close all other windows',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]x
          \ :<C-u>call zvim#util#BufferEmpty()<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.x = ['call zvim#util#BufferEmpty()',
          \ 'Empty current buffer',
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
          \ 'Switch to the last buffer',
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
          \ 'Close current windows',
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
          \ 'delete current windows',
          \ [
          \ '[WIN q] is to delete current windows',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [Window]c
          \ :<C-u>call SpaceVim#mapping#clearBuffers()<CR>
    let lnum = expand('<slnum>') + s:lnum - 4
    let g:_spacevim_mappings_windows.c = ['call SpaceVim#mapping#clearBuffers()',
          \ 'Clear all the buffers',
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
    let g:_spacevim_mappings_denite['<space>'] = ['Denite menu:CustomKeyMaps',
          \ 'denite customkeymaps']
  endif
endfunction


function! SpaceVim#mapping#leader#getName(key) abort
  if a:key == g:spacevim_unite_leader
    return '[unite]'
  elseif a:key == g:spacevim_denite_leader
    return '[denite]'
  elseif a:key == ' '
    return '[SPC]'
  elseif a:key == 'g'
    return '[g]'
  elseif a:key == 'z'
    return '[z]'
  elseif a:key == g:spacevim_windows_leader
    return '[WIN]'
  elseif a:key ==# '\'
    return '<leader>'
  else
    return ''
  endif
endfunction

function! SpaceVim#mapping#leader#defindKEYs() abort
  let g:_spacevim_mappings_prefixs = {}
  let g:_spacevim_mappings_prefixs[g:spacevim_windows_leader] = {'name' : '+Window prefix'}
  call extend(g:_spacevim_mappings_prefixs[g:spacevim_windows_leader], g:_spacevim_mappings_windows)
  let g:_spacevim_mappings_prefixs['g'] = {'name' : '+g prefix'}
  call extend(g:_spacevim_mappings_prefixs['g'], g:_spacevim_mappings_g)
  let g:_spacevim_mappings_prefixs['z'] = {'name' : '+z prefix'}
  call extend(g:_spacevim_mappings_prefixs['z'], g:_spacevim_mappings_z)
  let leader = get(g:, 'mapleader', '\')
  let g:_spacevim_mappings_prefixs[leader] = {'name' : '+Leader prefix'}
  call extend(g:_spacevim_mappings_prefixs[leader], g:_spacevim_mappings)
endfunction


" vim:set et sw=2 cc=80:
