function! s:test()

  if l:x == 1
    if l:y == "hello andy"
      echom "hello andy" " CURSOR
    endif
    call one()
  else
    call two()
  elseif
    call three()
  endif

  let l:str = "hello"

  return l:str

endfunction


