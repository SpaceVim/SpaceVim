function! sj#php#SplitBraces()
  return s:SplitList('(', ')')
endfunction

function! sj#php#SplitArray()
  return s:SplitList('[', ']')
endfunction

function! sj#php#JoinBraces()
  return s:JoinList('(', ')')
endfunction

function! sj#php#JoinArray()
  return s:JoinList('[', ']')
endfunction

function! sj#php#JoinHtmlTags()
  if synIDattr(synID(line("."), col("."), 1), "name") =~ '^php'
    " then we're in php, don't try to join tags
    return 0
  else
    return sj#html#JoinTags()
  endif
endfunction

function! sj#php#SplitIfClause()
  let pattern = '\<if\s*(.\{-})\s*{.*}'

  if search(pattern, 'Wbc', line('.')) <= 0
    return 0
  endif

  normal! f(
  normal %
  normal! f{

  let body = sj#GetMotion('Va{')
  let body = substitute(body, '^{\s*\(.\{-}\)\s*}$', "{\n\\1\n}", '')
  call sj#ReplaceMotion('Va{', body)

  return 1
endfunction

function! sj#php#SplitElseClause()
  let pattern = '\<else\s*{.*}'

  if search(pattern, 'Wbc', line('.')) <= 0
    return 0
  endif

  normal! f{

  let body = sj#GetMotion('Va{')
  let body = substitute(body, '^{\s*\(.\{-}\)\s*}$', "{\n\\1\n}", '')
  call sj#ReplaceMotion('Va{', body)

  return 1
endfunction

function! sj#php#JoinIfClause()
  let pattern = '\<if\s*(.\{-})\s*{\s*$'

  if search(pattern, 'Wbc', line('.')) <= 0
    return 0
  endif

  normal! f(
  normal %
  normal! f{

  let body = sj#GetMotion('Va{')
  let body = substitute(body, "\\s*\n\\s*", ' ', 'g')
  call sj#ReplaceMotion('Va{', body)

  return 1
endfunction

function! sj#php#JoinElseClause()
  let pattern = '\<else\s*{\s*$'

  if search(pattern, 'Wbc', line('.')) <= 0
    return 0
  endif

  normal! f{

  let body = sj#GetMotion('Va{')
  let body = substitute(body, "\\s*\n\\s*", ' ', 'g')
  call sj#ReplaceMotion('Va{', body)

  return 1
endfunction

function! sj#php#SplitPhpMarker()
  if sj#SearchUnderCursor('<?=\=\%(php\)\=.\{-}?>') <= 0
    return 0
  endif

  let start_col = col('.')
  let skip = sj#SkipSyntax(['phpStringSingle', 'phpStringDouble', 'phpComment'])
  if sj#SearchSkip('?>', skip, 'We', line('.')) <= 0
    return 0
  endif
  let end_col = col('.')

  let body = sj#GetCols(start_col, end_col)
  let body = substitute(body, '^<?\(=\=\%(php\)\=\)\s*', "<?\\1\n", '')
  let body = substitute(body, '\s*?>$', "\n?>", '')

  call sj#ReplaceCols(start_col, end_col, body)
  return 1
endfunction

function! sj#php#JoinPhpMarker()
  if sj#SearchUnderCursor('<?=\=\%(php\)\=\s*$') <= 0
    return 0
  endif

  let start_lineno = line('.')
  let skip = sj#SkipSyntax(['phpStringSingle', 'phpStringDouble', 'phpComment'])
  if sj#SearchSkip('?>', skip, 'We') <= 0
    return 0
  endif
  let end_lineno = line('.')

  let saved_joinspaces = &joinspaces
  set nojoinspaces
  exe start_lineno.','.end_lineno.'join'
  let &joinspaces = saved_joinspaces

  return 1
endfunction

function! s:SplitList(start_char, end_char)
  let [from, to] = sj#LocateBracesOnLine(a:start_char, a:end_char)

  if from < 0 && to < 0
    return 0
  endif

  let pairs = sj#ParseJsonObjectBody(from + 1, to - 1)

  if len(pairs) < 1
    return 0
  endif

  let body  = a:start_char."\n".join(pairs, ",\n")
  if sj#settings#Read('trailing_comma')
    let body = body.','
  endif
  let body = body."\n".a:end_char

  call sj#ReplaceMotion('Va'.a:start_char, body)

  let body_start = line('.') + 1
  let body_end   = body_start + len(pairs)

  call sj#PushCursor()
  exe "normal! jV".(body_end - body_start)."j2="
  call sj#PopCursor()

  if sj#settings#Read('align')
    call sj#Align(body_start, body_end, 'hashrocket')
  endif

  return 1
endfunction

function! s:JoinList(start_char, end_char)
  let line = getline('.')

  if line !~ a:start_char.'\s*$'
    return 0
  endif

  call search(a:start_char.'\s*$', 'ce', line('.'))

  let body = sj#Trim(sj#GetMotion('Vi'.a:start_char))
  let body = substitute(body, ',$', '', '')

  if sj#settings#Read('normalize_whitespace')
    let body = substitute(body, '\s*=>\s*', ' => ', 'g')
  endif
  let body = join(sj#TrimList(split(body, "\n")), ' ')
  call sj#ReplaceMotion('Va'.a:start_char, a:start_char.body.a:end_char)

  return 1
endfunction

function! s:SplitNextArrow()
  let l:arrow_or_paren = search('\v(\(|\S\zs-\>\ze)', '', line('.'))

  if ! arrow_or_paren
    return
  endif

  if matchstr(getline('.'), '\%' . col('.') . 'c.') == '('
    normal! %
  else
    exe "normal! i\<cr>"
  endif

  call s:SplitNextArrow()
endfunction

function! sj#php#SplitMethodChain()
  let pattern = '->[^-);]*'

  if sj#SearchUnderCursor('\S'.pattern) <= 0
    return 0
  endif

  call search(pattern, 'W', line('.'))
  let start_col = col('.')
  call search(pattern, 'We', line('.'))
  let end_col = col('.')

  " try to find a (...) after the keyword
  let current_line = line('.')
  normal! l
  if getline('.')[col('.') - 1] == '('
    normal! %
    if line('.') == current_line
      " the closing ) is on the same line, grab that one as well
      let end_col = col('.')
    endif
  endif

  let body = sj#GetCols(start_col, end_col)
  call sj#ReplaceCols(start_col, end_col, "\n".body)

  if sj#settings#Read('php_method_chain_full')
    normal! j
    call s:SplitNextArrow()
  endif

  return 1
endfunction

function! sj#php#JoinMethodChain()
  let next_line = nextnonblank(line('.') + 1)

  if getline(next_line) !~ '->'
    return 0
  endif

  call sj#Keeppatterns('s/\n\_s*//g')

  if sj#settings#Read('php_method_chain_full')
    call sj#php#JoinMethodChain()
  endif

  return 1
endfunction
