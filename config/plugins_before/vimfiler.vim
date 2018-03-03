function! s:open_vimfiler() abort
  silent VimFiler
  doautocmd WinEnter
endfunction

nnoremap <silent> <F3> :call <SID>open_vimfiler()<CR>
