" Taken from Marc Weber's scss indent script:
" https://github.com/cakebaker/scss-syntax.vim/blob/master/autoload/scss_indent.vim
" usage:
" set indentexpr=scss_indent#GetIndent(v:lnum)
fun! vaxe#hss#GetIndent(lnum)
  " { -> increase indent
  " } -> decrease indent
  if a:lnum == 1
    " start at 0 indentation
    return 0
  endif

  " try to find last line ending with { or }
  " ignoring // comments
  let regex = '\([{}]\)\%(\/\/.*\)\?$'
  let nr = search(regex, 'bnW')
  if nr > 0
    let last = indent(nr)
    let m = matchlist(getline(nr), regex)
    let m_curr = matchlist(getline(a:lnum), regex)
    echoe string(m).string(m_curr)
    if !empty(m_curr) && m_curr[1] == '}' && m[1] == '{'
      " last was open, current is close, use same indent
      return last
    elseif !empty(m_curr) && m_curr[1] == '}' && m[1] == '}'
      " } line and last line was }: decrease
      return last - &sw
    endif
    if m[1] == '{'
      " line after {: increase indent
      return last + &sw
    else
      " line after } or { - same indent
      return last
    endif
  else
    return 0
  endif
endfun
