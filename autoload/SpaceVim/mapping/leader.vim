"=============================================================================
" leader.vim --- mapping leader definition file for SpaceVim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


""
" @section windows-and-tabs, usage-windows-and-tabs
" @parentsection usage
" Window manager key bindings can only be used in normal mode.
" The default leader `[WIN]` is `s`, you can change it via `windows_leader`
" in the `[options]` section:
" >
"   [options]
"     windows_leader = "s"
" <
" >
"   Key Bindings | Descriptions
"   ------------ | --------------------------------------------------
"    q           | Smart buffer close
"    WIN v       | :split
"    WIN V       | Split with previous buffer
"    WIN g       | :vsplit
"    WIN G       | Vertically split with previous buffer
"    WIN t       | Open new tab (:tabnew)
"    WIN o       | Close other windows (:only)
"    WIN x       | Remove buffer, leave blank window
"    WIN q       | Remove current buffer
"    WIN Q       | Close current buffer (:close)
"    Shift-Tab   | Switch to alternate window (switch back and forth)
" <
" SpaceVim has mapped normal `q` (record a macro) as smart buffer close,
" and record a macro (vim's `q`) has been mapped to `<Leader> q r`,
" if you want to disable this feature, you can use `vimcompatible` mode.
" 
" @subsection General Editor windows
" >
"   Key Bindings | Descriptions
"   ------------ | --------------------------------
"    <F2>        | Toggle tagbar
"    <F3>        | Toggle Vimfiler
"    Ctrl-Down   | Move to split below ( Ctrl-w j )
"    Ctrl-Up     | Move to upper split ( Ctrl-w k )
"    Ctrl-Left   | Move to left split ( Ctrl-w h )
"    Ctrl-Right  | Move to right split ( Ctrl-w l )
" <
" @subsection Window manipulation key bindings
" 
" Every window has a number displayed at the start of the statusline
" and can be quickly accessed using `SPC number`.
" >
"   Key Bindings | Descriptions
"   ------------ | ---------------------
"    SPC 1       | go to window number 1
"    SPC 2       | go to window number 2
"    SPC 3       | go to window number 3
"    SPC 4       | go to window number 4
"    SPC 5       | go to window number 5
"    SPC 6       | go to window number 6
"    SPC 7       | go to window number 7
"    SPC 8       | go to window number 8
"    SPC 9       | go to window number 9
" <
" Windows manipulation commands (start with `w`):
" >
"   Key Bindings          | Descriptions
"   --------------------- | --------------------------------------------------
"    SPC w .              | windows transient state
"    SPC w <Tab>          | switch to alternate window in the current frame
"    SPC w =              | balance split windows
"    SPC w c              | Distraction-free reading current window
"    SPC w C              | Distraction-free reading other windows
"    SPC w d              | delete a window
"    SPC w D              | delete another window using vim-choosewin
"    SPC w f              | toggle follow mode
"    SPC w F              | create new tab
"    SPC w h              | move to window on the left
"    SPC w H              | move window to the left
"    SPC w j              | move to window below
"    SPC w J              | move window to the bottom
"    SPC w k              | move to window above
"    SPC w K              | move window to the top
"    SPC w l              | move to window on the right
"    SPC w L              | move window to the right
"    SPC w m              | maximize/minimize a window
"    SPC w M              | swap windows using vim-choosewin
"    SPC w o              | cycle and focus between tabs
"    SPC w r              | rotate windows forward
"    SPC w R              | rotate windows backward
"    SPC w s  /  SPC w -  | horizontal split
"    SPC w S              | horizontal split and focus new window
"    SPC w u              | undo window layout
"    SPC w U              | redo window layout
"    SPC w v  /  SPC w /  | vertical split
"    SPC w V              | vertical split and focus new window
"    SPC w w              | cycle and focus between windows
"    SPC w W              | select window using vim-choosewin
"    SPC w x              | exchange current window with next one
" <



let s:file = expand('<sfile>:~')
let s:lnum = expand('<slnum>') + 3
function! SpaceVim#mapping#leader#defindWindowsLeader(key) abort
  if !empty(a:key)
    exe 'nnoremap <silent><nowait> [Window] :<c-u>LeaderGuide "' .
          \ a:key . '"<CR>'
    exe 'nmap ' .a:key . ' [Window]'
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
  call SpaceVim#logger#debug('defind SPC h k prefixs')
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
