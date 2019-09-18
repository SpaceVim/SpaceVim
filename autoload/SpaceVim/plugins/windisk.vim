"=============================================================================
" windisk.vim --- disk manager for windows
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

func! SpaceVim#plugins#windisk#open() abort
  let disks = s:get_disks()
  if !empty(disks)
    " 1. open plugin buffer
    noautocmd vsplit __windisk__
    vertical resize 20
    let s:disk_buffer_nr = bufnr('%')
    set ft=SpaceVimWinDiskManager
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber winfixwidth
    " 2. init buffer option and syntax
    let lines = disks
    setlocal modifiable
    call setline(1, lines)
    setlocal nomodifiable
    " 2. updated content
    " 3. init buffer key bindings
    nnoremap <buffer><silent> <Cr> :call <SID>open_disk(getline('.'))<cr>
  else
    " TODO: print warnning, not sure if it is needed.
  endif
endf

func! s:get_disks() abort
  return map(filter(range(65, 97), "isdirectory(nr2char(v:val) . ':/')"), 'nr2char(v:val) . ":/"')
endf


function! s:open_disk(d) abort
  call s:close_disk_buffer()
  if g:spacevim_filemanager ==# 'vimfiler'
    exe 'VimFiler -no-toggle ' . a:d
  elseif g:spacevim_filemanager ==# 'nerdtree'
  elseif g:spacevim_filemanager ==# 'defx'
    exe 'Defx -no-toggle -no-resume ' . a:d
  endif
  doautocmd WinEnter
endfunction


function! s:close_disk_buffer() abort
  exe 'bd ' . s:disk_buffer_nr
endfunction

