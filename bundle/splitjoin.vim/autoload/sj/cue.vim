function! sj#cue#SplitImports()
  let pattern = '^import\s\+\(\%(\k\+\s\+\)\=\%(".*"\)\)$'

  if getline('.') =~ pattern
    call sj#Keeppatterns('s/' . pattern . '/import (\r\1\r)/')
    normal! k==
    return 1
  else
    return 0
  endif
endfunction

function! sj#cue#SplitStructLiteral()
  let [from, to] = sj#LocateBracesOnLine('{', '}')

  if from < 0 && to < 0
    return 0
  endif

  let pairs = sj#ParseJsonObjectBody(from + 1, to - 1)
  let body = join(pairs, "\n")
  let body  = "{\n".body."\n}"
  call sj#ReplaceMotion('Va{', body)

  if sj#settings#Read('align')
    let body_start = line('.') + 1
    let body_end   = body_start + len(pairs) - 1
    call sj#Align(body_start, body_end, 'json_object')
  endif

  return 1
endfunction

function! sj#cue#JoinStructLiteral()
  let line = getline('.')

  if line =~ '{\s*$'
    call search('{', 'c', line('.'))
    let body = sj#GetMotion('Vi{')

    let lines = split(body, "\n")
    let lines = sj#TrimList(lines)
    if sj#settings#Read('normalize_whitespace')
      let lines = map(lines, 'substitute(v:val, ":\\s\\+", ": ", "")')
    endif

    let body = join(lines, ', ')
    let body = substitute(body, ',$', '', '')

    if sj#settings#Read('curly_brace_padding')
      let body = '{ '.body.' }'
    else
      let body = '{'.body.'}'
    endif

    call sj#ReplaceMotion('Va{', body)

    return 1
  else
    return 0
  endif
endfunction

function! sj#cue#SplitArray()
  return s:SplitList(['[', ']'], 'cursor_on_line')
endfunction

function! sj#cue#JoinArray()
  return s:JoinList(['[', ']'], 'padding')
endfunction

function! sj#cue#SplitArgs()
  return s:SplitList(['(', ')'], 'cursor_inside')
endfunction

function! sj#cue#JoinArgs()
  return s:JoinList(['(', ')'], 'no_padding')
endfunction

function! s:SplitList(delimiter, cursor_position)
  let start = a:delimiter[0]
  let end   = a:delimiter[1]

  let lineno = line('.')
  let indent = indent('.')

  if a:cursor_position == 'cursor_inside'
    let [from, to] = sj#LocateBracesAroundCursor(start, end)
  elseif a:cursor_position == 'cursor_on_line'
    let [from, to] = sj#LocateBracesOnLine(start, end)
  else
    echoerr "Invalid value for a:cursor_position: ".a:cursor_position
    return
  endif

  if from < 0 && to < 0
    return 0
  endif

  let items = sj#ParseJsonObjectBody(from + 1, to - 1)
  if empty(items)
    return 0
  endif

  let body = start."\n".join(items, ",\n")."\n".end

  call sj#ReplaceMotion('Va'.start, body)

  let end_line = lineno + len(items) + 1
  call sj#SetIndent(end_line, indent)

  return 1
endfunction

function! s:JoinList(delimiter, delimiter_padding)
  let start = a:delimiter[0]
  let end   = a:delimiter[1]

  let line = getline('.')

  if line !~ start . '\s*$'
    return 0
  endif

  call search(start, 'c', line('.'))
  let body = sj#GetMotion('Vi'.start)

  let lines = split(body, "\n")
  let lines = sj#TrimList(lines)
  let body  = sj#Trim(join(lines, ' '))
  let body  = substitute(body, ',\s*$', '', '')

  if a:delimiter_padding == 'padding'
    let body = start.' '.body.' '.end
  else
    let body = start.body.end
  endif

  call sj#ReplaceMotion('Va'.start, body)

  return 1
endfunction

