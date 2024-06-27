function! sj#elixir#SplitDoBlock()
  let [function_name, function_start, function_end, function_type] =
        \ sj#argparser#elixir#LocateFunction()
  if function_start < 0
    return 0
  endif

  let is_if = function_name == 'if' || function_name == 'unless'

  let parser = sj#argparser#elixir#Construct(function_start, function_end, getline('.'))
  call parser.Process()

  let do_body   = ''
  let else_body = ''
  let args      = []

  for arg in parser.args
    if arg =~ '^do:' && do_body == ''
      let do_body = substitute(arg, '^do:\s*', '', '')
    elseif arg =~ '^else:' && is_if && else_body == ''
      let else_body = substitute(arg, '^else:\s*', '', '')
    else
      call add(args, arg)
    endif
  endfor

  if do_body == ''
    return 0
  endif

  let line = getline('.')

  if is_if && function_type == 'with_round_braces'
    " skip the round brackets before the if-clause
    let new_line = strpart(line, 0, function_start - 2) . ' ' . join(args, ', ')
  else
    let new_line = strpart(line, 0, function_start - 1) . join(args, ', ')
  endif

  if function_end > 0
    if is_if && function_type == 'with_round_braces'
      " skip the round brackets after the if-clause
      let new_line .= strpart(line, function_end + 1)
    else
      let new_line .= strpart(line, function_end)
    end
  else
    " we didn't detect an end, so it goes on to the end of the line
  endif

  if else_body != ''
    let do_block = " do\n" . do_body . "\nelse\n" . else_body . "\nend"
  else
    let do_block = " do\n" . do_body . "\nend"
  endif

  call sj#ReplaceLines(line('.'), line('.'), new_line . do_block)
  return 1
endfunction

function! sj#elixir#JoinDoBlock()
  let do_pattern = '\s*do\s*\%(#.*\)\=$'
  let def_lineno = line('.')
  let def_line   = getline(def_lineno)

  if def_line !~ do_pattern
    return 0
  endif

  let [function_name, function_start, function_end, function_type] =
        \ sj#argparser#elixir#LocateFunction()
  if function_start < 0
    return 0
  endif

  let is_if       = function_name == 'if' || function_name == 'unless'
  let body_lineno = line('.') + 1
  let body_line   = getline(body_lineno)

  if is_if && getline(line('.') + 2) =~ '^\s*else\>'
    let else_lineno = line('.') + 2
    let else_line   = getline(else_lineno)

    let else_body_lineno = line('.') + 3
    let else_body_line   = getline(else_body_lineno)

    let end_lineno = line('.') + 4
    let end_line   = getline(end_lineno)
  else
    let else_line = ''

    let end_lineno = line('.') + 2
    let end_line   = getline(end_lineno)
  endif

  if end_line !~ '^\s*end$'
    return 0
  endif

  exe 'keeppatterns s/'.do_pattern.'//'
  if function_end < 0
    let function_end = col('$') - 1
  endif

  let args = sj#GetCols(function_start, function_end)
  let joined_args = ', do: '.sj#Trim(body_line)
  if else_line != ''
    let joined_args .= ', else: '.sj#Trim(else_body_line)
  endif

  call sj#ReplaceCols(function_start, function_end, args . joined_args)
  exe body_lineno.','.end_lineno.'delete _'
  return 1
endfunction

function! sj#elixir#JoinCommaDelimitedItems()
  if getline('.') !~ ',\s*$'
    return 0
  endif

  let start_lineno = line('.')
  let end_lineno   = start_lineno
  let lineno       = nextnonblank(start_lineno + 1)
  let line         = getline(lineno)

  while lineno <= line('$') && line =~ ',\s*$'
    let end_lineno = lineno
    let lineno     = nextnonblank(lineno + 1)
    let line       = getline(lineno)
  endwhile

  let end_lineno = lineno

  call cursor(start_lineno, 0)
  exe "normal! V".(end_lineno - start_lineno)."jJ"
  return 1
endfunction

function! sj#elixir#SplitArray()
  let [from, to] = sj#LocateBracesAroundCursor('[', ']', [
        \ 'elixirInterpolationDelimiter',
        \ 'elixirString',
        \ 'elixirStringDelimiter',
        \ 'elixirSigilDelimiter',
        \ ])

  if from < 0
    return 0
  endif

  let items = sj#ParseJsonObjectBody(from + 1, to - 1)

  if len(items) == 0 || to - from < 2
    return 1
  endif

  " substitute [1, 2, | tail]
  let items[-1] = substitute(items[-1], "\\(|[^>].*\\)", "\n\\1", "")
  let body = "[\n" . join(items, ",\n") . "\n]"

  call sj#ReplaceMotion('Va[', body)
  return 1
endfunction

function! sj#elixir#JoinArray()
  normal! $

  if getline('.')[col('.') - 1] != '['
    return 0
  endif

  let body = sj#Trim(sj#GetMotion('Vi['))
  " remove trailing comma
  let body = substitute(body, ',\ze\_s*$', '', '')

  let items = split(body, ",\s*\n")
  if len(items) == 0
    return 0
  endif

  " join isolated | tail on the last line
  let items[-1] = substitute(items[-1], "[[:space:]]*\\(|[^>].*\\)", " \\1", "")

  let body = join(sj#TrimList(items), ', ')
  call sj#ReplaceMotion('Va[', '['.body.']')
  return 1
endfunction

let s:pipe_pattern = '^\s*|>\s\+'
let s:atom_pattern = ':\k\+'
let s:module_pattern = '\k\%(\k\|\.\)*'
let s:function_pattern = '\k\+[?!]\='
let s:atom_or_module_pattern = '\%(' . s:atom_pattern . '\.\|' . s:module_pattern . '\.\)\='

function! sj#elixir#SplitPipe()
  let line = getline('.')

  call sj#PushCursor()
  normal! 0f(
  let [function_name, function_start, function_end, function_type] =
        \ sj#argparser#elixir#LocateFunction()
  call sj#PopCursor()

  " We only support function calls that start at the beginning of the line
  " (accounting for whitespace)
  let prefix = strpart(line, 0, function_start - 1)
  let prefix_pattern = '^\s*' . s:atom_or_module_pattern . function_name . '\((\|\s\+\)$'

  if function_start < 0 || prefix !~ prefix_pattern
    return 0
  endif

  let comment_pattern = '\s*\(#.*\)\=$'

  if function_end < 0
    let comment_start = match(line, comment_pattern)

    if comment_start < 0
      let rest = 'none'
    else
      let rest = strpart(line, comment_start)
      let function_end = comment_start
    endif
  else
    let rest = strpart(line, function_end + 1)

    if rest !~ '^' . comment_pattern
      return 0
    endif
  end

  let parser = sj#argparser#elixir#Construct(function_start, function_end, line)
  call parser.Process()

  let args = parser.args

  let function_call = sj#Trim(strpart(line, 0, function_start - 2))
  let result = args[0] . "\n|> " . function_call . '(' . join(args[1:], ', ') . ')' . rest

  call sj#ReplaceLines(line('.'), line('.'), result)

  return 1
endfunction

function! sj#elixir#JoinPipe()
  call sj#PushCursor()

  let line = getline('.')
  if line !~ s:pipe_pattern
    normal! j
    let line = getline('.')
  endif

  let line_num = line('.')
  let prev_line = sj#Trim(getline(line_num - 1))

  if line !~ s:pipe_pattern || prev_line =~ s:pipe_pattern
    call sj#PopCursor()
    return 0
  endif

  let empty_args_pattern = s:pipe_pattern . '\(' . s:atom_or_module_pattern . s:function_pattern . '\)()'

  if line =~ empty_args_pattern
    let function_name = substitute(line, empty_args_pattern, '\1', '')
    let result = function_name . '(' . prev_line . ')'
    call sj#PopCursor()
  else
    normal! f(l
    let [function_name, function_start, function_end, function_type] =
          \ sj#argparser#elixir#LocateFunction()
    call sj#PopCursor()

    if function_start < 0
      return 0
    endif

    let parser = sj#argparser#elixir#Construct(function_start, function_end, line)
    call parser.Process()

    let args = parser.args
    let function_call = substitute(strpart(line, 0, function_start - 2), '|>\s\+', '', '')
    let result = function_call . '(' . prev_line . ', ' . join(args, ', ') . ')'
  endif

  call sj#ReplaceLines(line_num - 1, line_num, result)
  return 1
endfunction
