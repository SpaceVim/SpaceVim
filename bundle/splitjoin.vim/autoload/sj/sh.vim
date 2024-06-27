function! sj#sh#SplitBySemicolon()
  let line   = getline('.')
  let parser = sj#argparser#sh#Construct(0, col('$'), line)
  call parser.Process()

  if len(parser.args) <= 1
    return 0
  endif

  let body = join(parser.args, "\n")
  call sj#ReplaceMotion('V', body)
  return 1
endfunction

function! sj#sh#SplitWithBackslash()
  if !search('\S', 'Wc', line('.'))
    return 0
  endif

  exe "normal! i\\\<cr>"
  return 1
endfunction

function! sj#sh#JoinWithSemicolon()
  if !nextnonblank(line('.') + 1)
    return 0
  endif

  call sj#Keeppatterns('s/;\=\s*\n\_s*/; /e')
  return 1
endfunction

function! sj#sh#JoinBackslashedLine()
  if getline('.') !~ '\\\s*$'
    return 0
  endif

  call sj#Keeppatterns('s/\\\=\s*\n\_s*//e')
  return 1
endfunction
