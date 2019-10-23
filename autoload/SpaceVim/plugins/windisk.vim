"=============================================================================
" windisk.vim --- disk manager for windows
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:ICONV = SpaceVim#api#import('iconv')

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

function! s:diskinfo() abort
  let dickinfo = systemlist('wmic LOGICALDISK LIST BRIEF')[1:]
  let rst = []
  for line in dickinfo
    let info = split(s:ICONV.iconv(line, 'cp936', &enc))
    if len(info) >= 4
      let diskid = info[0]
      let freespace = info[2]
      let size = info[3]
      let name = get(info, 4, '')
      call add(rst, {
            \ 'disk' : diskid,
            \ 'free' : freespace,
            \ 'size' : size,
            \ 'name' : name,
            \ })
    endif
  endfor
  return rst
endfunction

func! s:get_disks() abort
  " use wmic command is better
  " return map(filter(range(65, 97), "isdirectory(nr2char(v:val) . ':/')"), 'nr2char(v:val) . ":/"')
  let diskinfo = s:diskinfo()
  let line = map(diskinfo, 's:diskToLine(v:val)')
  return line
endf

function! s:diskToLine(disk) abort
  return a:disk.disk . '/' . ' ' . (empty(a:disk.name) ? '本地磁盘' : a:disk.name)
endfunction


function! s:open_disk(d) abort
  let disk = split(a:d)[0]
  call s:close_disk_buffer()
  if g:spacevim_filemanager ==# 'vimfiler'
    exe 'VimFiler -no-toggle ' . disk
  elseif g:spacevim_filemanager ==# 'nerdtree'
  elseif g:spacevim_filemanager ==# 'defx'
    exe 'Defx -no-toggle -no-resume ' . disk
  endif
  doautocmd WinEnter
endfunction


function! s:close_disk_buffer() abort
  exe 'bd ' . s:disk_buffer_nr
endfunction

