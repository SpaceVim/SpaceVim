function! sj#coffee#SplitFunction()
  let lineno = line('.')
  let line   = getline('.')
  let indent = indent(lineno)

  if line !~ '[-=]>'
    return 0
  else
    call sj#Keeppatterns('s/\([-=]\)>\s*/\1>\r/')
    call sj#SetIndent(lineno, indent)
    call sj#SetIndent(lineno + 1, indent + &sw)
    return 1
  endif
endfunction

function! sj#coffee#JoinFunction()
  let line = getline('.')

  if line !~ '[-=]>'
    return 0
  else
    call sj#Keeppatterns('s/\([-=]\)>\_s\+/\1> /')
    return 1
  endif
endfunction

function! sj#coffee#SplitIfClause()
  let line            = getline('.')
  let base_indent     = indent('.')
  let suffix_pattern  = '\v(.*\S.*) (if|unless|while|until|for) (.*)'
  let postfix_pattern = '\v(if|unless|while|until) (.*) then (.*)'

  if line =~ suffix_pattern
    call sj#ReplaceMotion('V', substitute(line, suffix_pattern, '\2 \3\n\1', ''))
    call sj#SetIndent(line('.'), base_indent)
    call sj#SetIndent(line('.') + 1, base_indent + &sw)
    return 1
  elseif line =~ postfix_pattern
    call sj#ReplaceMotion('V', substitute(line, postfix_pattern, '\1 \2\n\3', ''))
    call sj#SetIndent(line('.'), base_indent)
    call sj#SetIndent(line('.') + 1, base_indent + &sw)
    return 1
  else
    return 0
  endif
endfunction

function! sj#coffee#JoinIfElseClause()
  let if_lineno    = line('.')
  let else_lineno  = line('.') + 2
  let if_line      = getline(if_lineno)
  let else_line    = getline(else_lineno)
  let base_indent  = indent('.')
  let if_pattern   = '\v^\s*(if|unless|while|until|for)\s'
  let else_pattern = '\v^\s*else$'

  if if_line !~ if_pattern || else_line !~ else_pattern
    return 0
  endif

  if indent(if_lineno) != indent(else_lineno)
    return 0
  endif

  let if_clause   = sj#Trim(if_line)
  let true_body   = sj#Trim(getline(line('.') + 1))
  let else_clause = sj#Trim(else_line)
  let false_body  = sj#Trim(getline(line('.') + 3))

  let assignment_pattern = '^\(\w\+\)\s*=\s*'
  if true_body =~ assignment_pattern && false_body =~ assignment_pattern
    " it might start with the assignment of a single variable, let's see
    let match_index = matchend(true_body, assignment_pattern)
    if strpart(true_body, 0, match_index) == strpart(false_body, 0, match_index)
      " assignment, change the components a bit
      let if_clause  = strpart(true_body, 0, match_index).if_clause
      let true_body  = strpart(true_body, match_index)
      let false_body = strpart(false_body, match_index)
    endif
  endif

  call sj#ReplaceMotion('Vjjj', if_clause.' then '.true_body.' else '.false_body)
  call sj#SetIndent(line('.'), base_indent)

  return 1
endfunction

function! sj#coffee#JoinIfClause()
  let line        = getline('.')
  let base_indent = indent('.')
  let pattern     = '\v^\s*(if|unless|while|until|for)\ze\s'

  if line !~ pattern
    return 0
  endif

  let if_clause = sj#Trim(getline('.'))
  let body      = sj#Trim(getline(line('.') + 1))

  if sj#settings#Read('coffee_suffix_if_clause')
    call sj#ReplaceMotion('Vj', body.' '.if_clause)
  else
    call sj#ReplaceMotion('Vj', if_clause.' then '.body)
  endif
  call sj#SetIndent(line('.'), base_indent)

  return 1
endfunction

function! sj#coffee#SplitTernaryClause()
  let lineno  = line('.')
  let indent  = indent('.')
  let line    = getline('.')
  let pattern = '\v^(\s*)(.*)if (.*) then (.*) else ([^)]*)(.*)$'

  if line =~ pattern
    let body_when_true  = sj#ExtractRx(line, pattern, '\4')
    let body_when_false = sj#ExtractRx(line, pattern, '\5')
    let replacement     = "if \\3\r\\2".body_when_true."\\6\relse\r\\2".body_when_false."\\6"
    exe 's/'.pattern.'/'.escape(replacement, '/')

    call sj#SetIndent(lineno, lineno + 3, indent)
    normal! >>kk>>

    return 1
  else
    return 0
  endif
endfunction

function! sj#coffee#SplitObjectLiteral()
  let [from, to] = sj#LocateBracesOnLine('{', '}')
  let bracket    = '{'

  if from < 0 && to < 0
    let [from, to] = sj#LocateBracesOnLine('(', ')')
    let bracket    = '('
  endif

  if from < 0 && to < 0
    return 0
  endif

  let lineno = line('.')
  let indent = indent(lineno)
  let pairs  = sj#ParseJsonObjectBody(from + 1, to - 1)

  " Some are arguments, some are real pairs
  let arguments  = []
  while len(pairs) > 0
    let item = pairs[0]

    if item =~ '^\k\+:'
      " we've reached the pairs, stop here
      break
    else
      call add(arguments, remove(pairs, 0))
    endif
  endwhile

  if len(pairs) == 0
    " nothing to split
    return 0
  endif

  if len(arguments) > 0
    let argument_list = ' '.join(arguments, ', ').', '
  else
    let argument_list = ''
  endif

  let body = argument_list."\n".join(pairs, "\n")
  call sj#ReplaceMotion('Va'.bracket, body)

  " clean the remaining whitespace
  call sj#Keeppatterns('s/\s\+$//e')

  call sj#SetIndent(lineno + 1, lineno + len(pairs), indent + &sw)

  if sj#settings#Read('align')
    let body_start = lineno + 1
    let body_end   = body_start + len(pairs) - 1
    call sj#Align(body_start, body_end, 'json_object')
  endif

  return 1
endfunction

function! sj#coffee#JoinObjectLiteral()
  if line('.') == line('$')
    return 0
  endif

  let [start_line, end_line] = s:IndentedLinesBelow('.')

  if start_line == -1
    return 0
  endif

  let lines = sj#GetLines(start_line, end_line)
  let lines = sj#TrimList(lines)
  let lines = map(lines, 'sj#Trim(v:val)')
  if sj#settings#Read('normalize_whitespace')
    let lines = map(lines, 'substitute(v:val, ":\\s\\+", ": ", "")')
  endif
  let body = getline('.').' { '.join(lines, ', ').' }'
  call sj#ReplaceLines(start_line - 1, end_line, body)

  return 1
endfunction

function! sj#coffee#SplitTripleString()
  if search('["'']\{3}.\{-}["'']\{3}\s*$', 'Wbc', line('.')) <= 0
    return 0
  endif

  let start_col    = col('.')
  let quote        = getline('.')[col('.') - 1]
  let double_quote = repeat(quote, 2)
  let triple_quote = repeat(quote, 3)

  normal! lll
  if search(double_quote.'\zs'.quote, 'W', line('.')) <= 0
    return 0
  endif
  let end_col = col('.')

  let body     = sj#GetCols(start_col, end_col)
  let new_body = substitute(body, '^'.triple_quote.'\(.*\)'.triple_quote.'$', '\1', '')
  let new_body = triple_quote."\n".new_body."\n".triple_quote

  call sj#ReplaceCols(start_col, end_col, new_body)
  normal! j>>j<<

  return 1
endfunction

function! sj#coffee#SplitString()
  if search('["''].\{-}["'']\s*$', 'Wbc', line('.')) <= 0
    return 0
  endif

  let quote       = getline('.')[col('.') - 1]
  let multi_quote = repeat(quote, 2) " Note: only two quotes

  let body     = sj#GetMotion('vi'.quote)
  let new_body = substitute(body, '\\'.quote, quote, 'g')
  let new_body = multi_quote."\n".new_body."\n".multi_quote

  call sj#ReplaceMotion('vi'.quote, new_body)
  normal! j>>

  return 1
endfunction

function! sj#coffee#JoinString()
  if search('\%("""\|''''''\)\s*$', 'Wbc') <= 0
    return 0
  endif
  let start       = getpos('.')
  let multi_quote = expand('<cword>')
  let quote       = multi_quote[0]

  normal! j

  if search(multi_quote, 'Wce') <= 0
    return 0
  endif
  let end = getpos('.')

  let body     = sj#GetByPosition(start, end)
  let new_body = substitute(body, '^'.multi_quote.'\_s*\(.*\)\_s*'.multi_quote.'$', '\1', 'g')
  let new_body = substitute(new_body, quote, '\\'.quote, 'g')
  let new_body = sj#Trim(new_body)
  let new_body = quote.new_body.quote

  call sj#ReplaceByPosition(start, end, new_body)

  return 1
endfunction

function! s:IndentedLinesBelow(line)
  let current_line = line(a:line)
  let first_line   = nextnonblank(current_line + 1)
  let next_line    = first_line
  let base_indent  = indent(current_line)

  if indent(first_line) <= base_indent
    return [-1, -1]
  endif

  while next_line <= line('$') && indent(next_line) > base_indent
    let current_line = next_line
    let next_line    = nextnonblank(current_line + 1)
  endwhile

  return [first_line, current_line]
endfunction
