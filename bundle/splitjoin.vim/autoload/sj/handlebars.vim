function! sj#handlebars#SplitComponent()
  if !sj#SearchUnderCursor('{{#\=\%(\k\|-\|\/\)\+ .\{-}}}')
    return 0
  endif

  let body = sj#GetMotion('vi{')
  let body = substitute(body, '\s\+\(\k\+=\)', '\n\1', 'g')
  if !sj#settings#Read('handlebars_closing_bracket_on_same_line')
    let body = substitute(body, '}$', "\n}", '')
  endif

  if sj#settings#Read('handlebars_hanging_arguments')
    " substitute just the first newline with a space
    let body = substitute(body, '\n', ' ', '')
  endif

  call sj#ReplaceMotion('vi{', body)
  return 1
endfunction

function! sj#handlebars#JoinComponent()
  if !(sj#SearchUnderCursor('{{#\=\%(\k\|-\|\/\)\+.*$') && getline('.') !~ '}}')
    return 0
  endif

  normal! vi{J
  call sj#Keeppatterns('s/\s\+}}/}}/ge')
  return 1
endfunction

function! sj#handlebars#SplitBlockComponent()
  let saved_iskeyword = &iskeyword

  try
    set iskeyword+=-,/
    let start_pattern = '{{#\k\+\%( .\{-}\)\=}}'

    if !search(start_pattern, 'bWc', line('.'))
      return 0
    endif

    call search('\k', 'W', line('.'))
    let component_name = expand('<cword>')
    call search(start_pattern, 'eW', line('.'))
    let start_col = col('.') + 1

    if !search('{{/'.component_name.'}}', 'W', line('.'))
      return 0
    endif
    let end_col = col('.') - 1

    if end_col - start_col > 0
      let body = sj#GetCols(start_col, end_col)
      call sj#ReplaceCols(start_col, end_col, "\n".sj#Trim(body)."\n")
    else
      " empty block component
      call sj#ReplaceCols(start_col, start_col, "\n{")
    endif

    return 1
  finally
    let &iskeyword = saved_iskeyword
  endtry
endfunction

function! sj#handlebars#JoinBlockComponent()
  let saved_iskeyword = &iskeyword

  try
    set iskeyword+=-,/
    let start_pattern = '{{#\k\+\%( .\{-}\)\=}}\s*$'

    if !search(start_pattern, 'bWc', line('.'))
      return 0
    endif

    call search('\k', 'W', line('.'))
    let component_name = expand('<cword>')
    let start_line = line('.')

    if !search('{{/'.component_name.'}}', 'W')
      return 0
    endif
    let end_line = line('.')

    if end_line - start_line <= 0
      " not right, there needs to be at least one line of a difference
      return 0
    endif

    if end_line - start_line > 1
      let body = join(sj#TrimList(getbufline('%', start_line + 1, end_line -1)), ' ')
    else
      let body = ''
    endif

    let start_tag = sj#Rtrim(getline(start_line))
    let end_tag   = sj#Ltrim(getline(end_line))

    call sj#ReplaceLines(start_line, end_line, start_tag.body.end_tag)
    return 1
  finally
    let &iskeyword = saved_iskeyword
  endtry
endfunction
