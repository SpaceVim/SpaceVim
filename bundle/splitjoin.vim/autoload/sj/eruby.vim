function! sj#eruby#SplitIfClause()
  let line    = getline('.')
  let pattern = '\v\<\%(.*\S.*) (if|unless) (.*)\s*\%\>'

  if line =~ pattern
    let body = substitute(line, pattern, '<% \2 \3%>\n<%\1 %>\n<% end %>', '')
    call sj#ReplaceMotion('V', body)

    return 1
  end

  return 0
endfunction

function! sj#eruby#JoinIfClause()
  let line    = getline('.')
  let pattern = '\v^\s*\<\%\s*(if|unless)'

  if line =~ pattern
    normal! jj

    if getline('.') =~ 'end'
      let body = sj#GetMotion('Vkk')

      let [if_line, body, end_line] = split(body, '\n')

      let if_line = sj#ExtractRx(if_line, '<%\s*\(.\{-}\)\s*%>',    '\1')
      let body    = sj#ExtractRx(body,    '\(<%=\?\s*.\{-}\)\s*%>', '\1')

      let replacement = body.' '.if_line.' %>'

      call sj#ReplaceMotion('gv', replacement)

      return 1
    endif
  endif

  return 0
endfunction

function! sj#eruby#SplitHtmlTags()
  if eval(sj#SkipSyntax(['erubyDelimiter', 'erubyExpression']))
    return 0
  endif

  return sj#html#SplitTags()
endfunction

function! sj#eruby#SplitHtmlAttributes()
  if eval(sj#SkipSyntax(['erubyDelimiter', 'erubyExpression']))
    return 0
  endif

  return sj#html#SplitAttributes()
endfunction
