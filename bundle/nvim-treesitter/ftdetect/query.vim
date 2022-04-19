" Last Change: 2020 Sep 01

function! s:shouldFt(path)
  let l:q_dir = fnamemodify(a:path, ":p:h:h:t")

  if l:q_dir =~? "queries"
    setlocal ft=query
  endif
endfunction

autocmd BufNewFile,BufRead *.scm call s:shouldFt(expand("%"))
