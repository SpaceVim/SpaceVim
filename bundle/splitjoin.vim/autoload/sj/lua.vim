let s:function_pattern = '\(\<function\>.\{-}(.\{-})\)\(.*\)\<end\>'

function! sj#lua#SplitFunctionString(str)
  let head = sj#ExtractRx(a:str, s:function_pattern, '\1')
  let body = sj#Trim(sj#ExtractRx(a:str, s:function_pattern, '\2'))

  if sj#BlankString(body)
    let body = ''
  else
    let body = substitute(body, "; ", "\n", "").'\n'
  endif

  let replacement = head."\n".body."end"
  let new_line    = substitute(a:str, s:function_pattern, replacement, '')

  return new_line
endfunction

function! sj#lua#SplitFunction()
  let line = getline('.')

  if line !~ s:function_pattern
    return 0
  else
    call sj#ReplaceMotion('V', sj#lua#SplitFunctionString(line))

    return 1
  endif
endfunction

function! sj#lua#JoinFunction()
  normal! 0
  if search('\<function\>', 'cW', line('.')) < 0
    return 0
  endif

  let function_lineno = line('.')
  if searchpair('\<function\>', '', '^\s*\<end\>', 'W') <= 0
    return 0
  endif
  let end_lineno = line('.')

  let function_line = getline(function_lineno)
  let end_line      = sj#Trim(getline(end_lineno))

  if end_lineno - function_lineno > 1
    let body_lines = sj#GetLines(function_lineno + 1, end_lineno - 1)
    let body_lines = sj#TrimList(body_lines)
    let body       = join(body_lines, '; ')
    let body       = ' '.body.' '
  else
    let body = ' '
  endif

  let replacement = function_line.body.end_line
  call sj#ReplaceLines(function_lineno, end_lineno, replacement)

  return 1
endfunction

function! sj#lua#SplitTable()
  let [from, to] = sj#LocateBracesOnLine('{', '}')

  if from < 0 && to < 0
    return 0
  else
    let parser = sj#argparser#js#Construct(from + 1, to -1, getline('.'))
    call parser.Process()
    let pairs = filter(parser.args, 'v:val !~ "^\s*$"')

    let idx = 0
    while idx < len(pairs)
      let item = pairs[idx]
      if item =~ s:function_pattern
        let pairs[idx] = sj#lua#SplitFunctionString(item)
      endif
      let idx = idx + 1
    endwhile

    let body  = "{\n".join(pairs, ",\n").",\n}"
    call sj#ReplaceMotion('Va{', body)

    if sj#settings#Read('align')
      let body_start = line('.') + 1
      let body_end   = body_start + len(pairs) - 1
      call sj#Align(body_start, body_end, 'lua_table')
    endif

    return 1
  endif
endf

function! sj#lua#JoinTable()
  let line = getline('.')

  if line =~ '{\s*$'
    call search('{', 'c', line('.'))
    let body = sj#GetMotion('Vi{')

    let parser = sj#argparser#js#Construct(0, strlen(body), body)
    call parser.Process()

    let lines = sj#TrimList(parser.args)

    let idx = 0
    while idx < len(lines)
      let item = lines[idx]
      if item =~ s:function_pattern
        let head = sj#Trim(sj#ExtractRx(item, s:function_pattern, '\1'))
        let body = sj#Trim(sj#ExtractRx(item, s:function_pattern, '\2'))
        let body_lines = sj#TrimList(split(body, "\n"))
        let replacement = head . ' ' . join(body_lines, '; '). ' end'

        let lines[idx] = substitute(item, s:function_pattern, replacement, '')
      endif
      let idx = idx + 1
    endwhile

    if sj#settings#Read('normalize_whitespace')
      let lines = map(lines, "substitute(v:val, '\\s\\+=\\s\\+', ' = ', '')")
    endif

    let body = substitute(join(lines, ', '), ',\s*$', '', '')

    call sj#ReplaceMotion('Va{', '{ '.body.' }')

    return 1
  else
    return 0
  end
endf
