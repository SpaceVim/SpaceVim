function! sj#perl#SplitSuffixIfClause()
  let pattern = '\(.*\) \(if\|unless\|while\|until\) \(.*\);\s*$'

  if sj#settings#Read('perl_brace_on_same_line')
    let replacement = "\\2 (\\3) {\n\\1;\n}"
  else
    let replacement = "\\2 (\\3) \n{\n\\1;\n}"
  endif

  return s:Split(pattern, replacement)
endfunction

function! sj#perl#SplitPrefixIfClause()
  let pattern = '\<if\s*(.\{-})\s*{.*}'

  if search(pattern, 'Wbc') <= 0
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

function! sj#perl#JoinIfClause()
  let current_line      = getline('.')
  let if_clause_pattern = '^\s*\(if\|unless\|while\|until\)\s*(\(.*\))\s*{\=\s*$'

  if current_line !~ if_clause_pattern
    return 0
  endif

  let condition = substitute(current_line, if_clause_pattern, '\2', '')
  let operation = substitute(current_line, if_clause_pattern, '\1', '')
  let start_line = line('.')

  call search('{', 'W')
  if searchpair('{', '', '}', 'W') <= 0
    return 0
  endif

  let end_line = line('.')
  let body     = sj#GetMotion('Vi{')
  let body     = join(split(body, ";\\s*\n"), '; ')
  let body     = substitute(body, ';\s\+', '; ', 'g')
  let body     = sj#Trim(body)

  let replacement = body.' '.operation.' '.condition.';'
  call sj#ReplaceLines(start_line, end_line, replacement)

  return 1
endfunction

function! sj#perl#SplitAndClause()
  let pattern = '\(.*\) and \(.*\);\s*$'

  if sj#settings#Read('perl_brace_on_same_line')
    let replacement = "if (\\1) {\n\\2;\n}"
  else
    let replacement = "if (\\1) \n{\n\\2;\n}"
  endif

  return s:Split(pattern, replacement)
endfunction

function! sj#perl#SplitOrClause()
  let pattern = '\(.*\) or \(.*\);\s*$'

  if sj#settings#Read('perl_brace_on_same_line')
    let replacement = "unless (\\1) {\n\\2;\n}"
  else
    let replacement = "unless (\\1) \n{\n\\2;\n}"
  endif

  return s:Split(pattern, replacement)
endfunction

function! sj#perl#SplitHash()
  let [from, to] = sj#LocateBracesOnLine('{', '}')

  if from < 0 && to < 0
    return 0
  endif

  let pairs = sj#ParseJsonObjectBody(from + 1, to - 1)
  let body  = "{\n".join(pairs, ",\n").",\n}"
  call sj#ReplaceMotion('Va{', body)

  if sj#settings#Read('align')
    let body_start = line('.') + 1
    let body_end   = body_start + len(pairs) - 1
    call sj#Align(body_start, body_end, 'hashrocket')
  endif

  return 1
endfunction

function! sj#perl#JoinHash()
  let line = getline('.')

  if search('{\s*$', 'c', line('.')) <= 0
    return 0
  endif

  let body = sj#GetMotion('Vi{')

  let lines = split(body, ",\n")
  let lines = sj#TrimList(lines)
  if sj#settings#Read('normalize_whitespace')
    let lines = map(lines, 'substitute(v:val, "=>\\s\\+", "=> ", "")')
    let lines = map(lines, 'substitute(v:val, "\\s\\+=>", " =>", "")')
  endif

  let body = join(lines, ', ')

  call sj#ReplaceMotion('Va{', '{'.body.'}')
  return 1
endfunction

function! sj#perl#SplitSquareBracketedList()
  let [from, to] = sj#LocateBracesOnLine('[', ']')
  if from < 0 && to < 0
    return 0
  endif

  let items = sj#ParseJsonObjectBody(from + 1, to - 1)
  let body  = "[\n".join(items, ",\n")
  if sj#settings#Read('trailing_comma')
      let body .= ","
  endif
  let body .= "\n]"
  call sj#ReplaceMotion('Va[', body)

  return 1
endfunction

function! sj#perl#SplitRoundBracketedList()
  let [from, to] = sj#LocateBracesOnLine('(', ')')
  if from < 0 && to < 0
    return 0
  endif

  let items = sj#ParseJsonObjectBody(from + 1, to - 1)
  let body  = "(\n".join(items, ",\n")
  if sj#settings#Read('trailing_comma')
      let body .= ","
  endif
  let body .= "\n)"
  call sj#ReplaceMotion('Va(', body)

  return 1
endfunction

function! sj#perl#SplitWordList()
  let [from, to] = sj#LocateBracesOnLine('qw(', ')')
  if from < 0 && to < 0
    return 0
  endif

  call search('qw\zs(', 'b', line('.'))
  let remainder_of_line = getline('.')[col('.') - 1 : -1]

  if remainder_of_line !~ '\%(\w\|\s\)\+)'
    return 0
  endif

  let items = split(matchstr(remainder_of_line, '\%(\k\|\s\)\+'), '\s\+')
  let body  = "(\n".join(items, "\n")."\n)"
  call sj#ReplaceMotion('Va(', body)

  return 1
endfunction

function! sj#perl#JoinSquareBracketedList()
  let line = getline('.')

  if search('[\s*$', 'c', line('.')) <= 0
    return 0
  endif

  let body = sj#GetMotion('Vi[')

  let lines = split(body, ",\n")
  let lines = sj#TrimList(lines)
  let body = join(lines, ', ')

  call sj#ReplaceMotion('Va[', '['.body.']')
  return 1
endfunction

function! sj#perl#JoinRoundBracketedList()
  let line = getline('.')

  if search('(\s*$', 'c', line('.')) <= 0
    return 0
  endif

  let body = sj#GetMotion('Vi(')

  let lines = split(body, ",\n")
  let lines = sj#TrimList(lines)
  let body = join(lines, ', ')

  call sj#ReplaceMotion('Va(', '('.body.')')
  return 1
endfunction

function! sj#perl#JoinWordList()
  let line = getline('.')

  if search('qw\zs(\s*$', 'c', line('.')) <= 0
    return 0
  endif

  let body = sj#GetMotion('Vi(')

  let lines = split(body, "\n")
  let lines = sj#TrimList(lines)
  let body = join(lines, ' ')

  call sj#ReplaceMotion('Va(', '('.body.')')
  return 1
endfunction

function! s:Split(pattern, replacement_pattern)
  let line = getline('.')

  if line !~ a:pattern
    return 0
  endif

  call sj#ReplaceMotion('V', substitute(line, a:pattern, a:replacement_pattern, ''))

  return 1
endfunction
