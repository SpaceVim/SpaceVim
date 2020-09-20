" This theme has been improved and renamed to base16_vim. The following is
" provided for backward compatibility.

function! airline#themes#base16_shell#refresh()
  call airline#themes#base16_vim#refresh()
  let g:airline#themes#base16_shell#palette
        \ = g:airline#themes#base16_vim#palette
endfunction

call airline#themes#base16_shell#refresh()
