function! s:perf_test(cnt) "{{{1
  let start = reltime()
  for i in range(1, a:cnt)
    call choosewin#font#large()
    call choosewin#font#small()
  endfor
  echo a:cnt . ": " . reltimestr(reltime(start))
endfunction
" call s:perf_test(20)

