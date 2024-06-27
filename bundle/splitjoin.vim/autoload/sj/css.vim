function! sj#css#SplitDefinition()
  if !s:LocateDefinition()
    return 0
  endif

  if getline('.') !~ '{.*}' " then there's nothing to split
    return 0
  endif

  if getline('.')[col('.') - 1 : col('.')] == '{}'
    " nothing in the body
    let body = ''
  else
    let body = sj#GetMotion('vi{')
  endif

  let lines = split(body, ";\s*")
  let lines = sj#TrimList(lines)
  let lines = filter(lines, '!sj#BlankString(v:val)')

  let body = join(lines, ";\n")
  if !sj#BlankString(body)
    let body .= ";"
  endif

  call sj#ReplaceMotion('va{', "{\n".body."\n}")

  if sj#settings#Read('align')
    let alignment_start = line('.') + 1
    let alignment_end   = alignment_start + len(lines) - 1
    call sj#Align(alignment_start, alignment_end, 'css_declaration')
  endif

  return 1
endfunction

function! sj#css#JoinDefinition()
  if !s:LocateDefinition()
    return 0
  endif

  if getline('.') =~ '{.*}' " then there's nothing to join
    return 0
  endif

  normal! 0
  call search('{', 'Wc', line('.'))

  if getline(line('.') + 1) =~ '^}'
    " nothing in the body
    let body = ''
  else
    let body = sj#GetMotion('Vi{')
  endif

  let lines = split(body, ";\\?\s*\n")
  let lines = sj#TrimList(lines)
  let lines = filter(lines, 'v:val !~ "^\s*$"')
  if sj#settings#Read('normalize_whitespace')
    let lines = map(lines, "substitute(v:val, '\\s*:\\s\\+', ': ', '')")
  endif

  let body = join(lines, "; ")
  let body = substitute(body, '\S.*\zs;\?$', ';', '')
  let body = substitute(body, '{;', '{', '') " for SCSS

  if body == ''
    call sj#ReplaceMotion('va{', '{}')
  else
    call sj#ReplaceMotion('va{', '{ '.body.' }')
  endif

  return 1
endfunction

function! sj#css#JoinMultilineSelector()
  let line = getline('.')

  let start_line = line('.')
  let end_line   = start_line
  let col        = col('.')
  let limit_line = line('$')

  while !sj#BlankString(line) && line !~ '{\s*$' && end_line < limit_line
    call cursor(end_line + 1, col)
    let end_line = line('.')
    let line     = getline('.')
  endwhile

  if start_line == end_line
    return 0
  else
    if line =~ '^\s*{\s*$'
      let end_line = end_line - 1
    endif

    exe start_line.','.end_line.'join'
    return 1
  endif
endfunction

function! sj#css#SplitMultilineSelector()
  if getline('.') !~ '.*,.*{\s*$'
    " then there is nothing to split
    return 0
  endif

  let definition = getline('.')
  let replacement = substitute(definition, ',\s*', ",\n", 'g')

  call sj#ReplaceMotion('V', replacement)

  return 1
endfunction

function! s:LocateDefinition()
  if search('{', 'bcW', line('.')) <= 0 && search('{', 'cW', line('.')) <= 0
    return 0
  else
    return 1
  endif
endfunction
