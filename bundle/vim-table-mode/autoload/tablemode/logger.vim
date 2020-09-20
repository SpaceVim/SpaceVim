function! tablemode#logger#log(message)
  if g:table_mode_verbose
    echom a:message
  endif
endfunction
