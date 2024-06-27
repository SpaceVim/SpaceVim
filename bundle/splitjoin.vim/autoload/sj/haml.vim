" TODO (2013-05-09) Only works for very simple things, needs work
function! sj#haml#SplitInterpolation()
  let lineno  = line('.')
  let line    = getline('.')
  let indent  = indent('.')
  let pattern = '^\s*%.\{-}\zs='

  if line !~ pattern
    return 0
  endif

  call sj#Keeppatterns('s/'.pattern.'/\r=/')
  call s:SetIndent(lineno + 1, lineno + 1, indent + &sw)

  return 1
endfunction

function! sj#haml#JoinInterpolation()
  if line('.') == line('$')
    return 0
  endif

  let line      = getline('.')
  let next_line = getline(line('.') + 1)

  if !(line =~ '^\s*%\k\+\s*$' && next_line =~ '^\s*=')
    return 0
  end

  call sj#Keeppatterns('s/\n\s*//')
  return 1
endfunction

" Sets the absolute indent of the given range of lines to the given indent
function! s:SetIndent(from, to, indent)
  let new_whitespace = repeat(' ', a:indent)
  exe a:from.','.a:to.'s/^\s*/'.new_whitespace
endfunction

function! sj#haml#SplitInlineInterpolation()
  let lineno  = line('.')
  let indent  = indent(lineno)
  let line    = getline(lineno)
  let pattern = '^\(.*\)\s*#{\(.\{-}\)}\s*$'

  if line !~ pattern
    return 0
  endif

  let new_line = sj#ExtractRx(line, pattern, '\1')
  let code     = sj#ExtractRx(line, pattern, '\2')

  call sj#ReplaceMotion('V', new_line."\n= ".code)
  call sj#SetIndent(lineno + 1, lineno + 1, indent)
  return 1
endfunction

function! sj#haml#JoinToInlineInterpolation()
  if line('.') == line('$')
    return 0
  endif

  let lineno      = line('.')
  let line        = getline(lineno)
  let indent      = indent(lineno)
  let next_indent = indent(lineno + 1)
  let next_line   = getline(lineno + 1)

  if indent == next_indent && next_line =~ '^\s*='
    let code = substitute(sj#Trim(next_line), '^=\s*', '', '')
    let line = sj#Rtrim(line).' #{'.code.'}'
    call sj#ReplaceLines(lineno, lineno, line)

    return 1
  else
    return 0
  endif
endfunction
