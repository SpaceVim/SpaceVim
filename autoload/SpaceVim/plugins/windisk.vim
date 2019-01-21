func! SpaceVim#plugins#windisk#open()
  let disks = s:get_disks()
  if !empty(disks)
    " 1. open plugin buffer
    noautocmd vsplit __windisk__
    let s:disk_buffer_nr = bufnr('%')
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber
    " 2. init buffer option and syntax
    let lines = disks
    setlocal modifiable
    call setline(1, lines)
    setlocal nomodifiable
    " 2. updated content
    " 3. init buffer key bindings
    nnoremap <buffer> <Cr> :call <SID>open_disk(getline('.'))<cr>
  else
    " TODO: print warnning, not sure if it is needed.
  endif
endf

func! s:get_disks()
  return map(filter(range(65, 97), "isdirectory(nr2char(v:val) . ':/')"), 'nr2char(v:val) . ":/"')
endf


function! s:open_disk(d) abort
  call s:close_disk_buffer()
  exe 'VimFiler -no-toggle ' . a:d
endfunction


function! s:close_disk_buffer() abort
  exe 'bd ' . s:disk_buffer_nr
endfunction

