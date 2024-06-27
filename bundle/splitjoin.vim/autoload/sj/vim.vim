function! sj#vim#Split()
  if sj#BlankString(getline('.'))
    return 0
  endif

  let new_line = sj#GetMotion('vg_')

  if sj#BlankString(new_line)
    return 0
  else
    let add_whitespace = 1

    if col('.') > 1
      let pair = strpart(getline('.'), col('.') - 2, 2)

      if pair =~ '\s'
        " we're breaking on whitespace, so make sure to add some:
        let add_whitespace = 1
      elseif pair =~ '^\S\S$'
        " we're breaking a word, so make sure not to have any:
        let add_whitespace = 0
      endif
    endif

    if add_whitespace
      let new_line = "\n\\ ".sj#Trim(new_line)
    else
      let new_line = "\n\\".sj#Trim(new_line)
    endif

    call sj#ReplaceMotion('vg_', new_line)
    call sj#Keeppatterns('s/\s\+$//e')

    return 1
  endif
endfunction

function! sj#vim#Join()
  let continuation_pattern = '^\s*\\'
  let current_lineno       = line('.')
  let next_lineno          = current_lineno + 1
  let next_line            = getline(next_lineno)

  if next_lineno > line('$') || next_line !~ continuation_pattern
    return 0
  endif

  if next_line =~ continuation_pattern.'\s'
    " Then there's some whitespace after the \, rely on :join
    keeppatterns exe next_lineno.'s/'.continuation_pattern.'//'
    exe current_lineno.','.next_lineno.'join'
  else
    " No whitespace, let's join them directly
    keeppatterns exe current_lineno.'s/\n'.continuation_pattern.'//'
  endif

  if sj#settings#Read('normalize_whitespace')
    call sj#CompressWhitespaceOnLine()
  endif

  return 1
endfunction

function! sj#vim#SplitIfClause()
  let line = getline('.')
  let pattern = '\v^\s*if .{-} \| .{-} \|\s*endif'

  if line !~# pattern
    return 0
  endif

  let line_no = line('.')
  let lines = split(line, '|')
  let lines = map(lines, 'sj#Trim(v:val)')
  let replacement = join(lines, "\n")

  call sj#ReplaceLines(line_no, line_no, replacement)

  return 1
endfunction

function! sj#vim#JoinIfClause()
  let line = getline('.')
  let pattern = '\v^\s*if'

  if line !~# pattern
    return 0
  endif

  let if_line_no = line('.')
  let endif_line_pattern = '^'.repeat(' ', indent(if_line_no)).'endif'

  let endif_line_no = search(endif_line_pattern, 'W')

  if endif_line_no <= 0
    return 0
  endif

  if endif_line_no - if_line_no != 2
    return 0
  endif

  let lines = sj#GetLines(if_line_no, endif_line_no)
  let lines = map(lines, 'sj#Trim(v:val)')
  let replacement = join(lines, ' | ')

  call sj#ReplaceLines(if_line_no, endif_line_no, replacement)

  return 1
endfunction
