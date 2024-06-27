function! sj#jsx#SplitJsxExpression()
  " Examples:
  "
  "   let x = <tag>
  "   () => <tag>
  "   return <tag>
  "
  let pattern = '\%(\%(let\|const\|var\)\s\+\k\+\s*=\s*\|)\s*=>\|return\s\+\)\s*' .
        \ '\zs<\k[^>/[:space:]]*'

  if sj#SearchUnderCursor(pattern) <= 0
    return 0
  endif

  " is it a fully-closed jsx tag?
  let body = sj#GetMotion('vat')
  if body =~ '^<\(\k\+\).*</\1>$'
    if body =~ "\n"
      " multiple lines, not splitting
      return 0
    endif

    call sj#ReplaceMotion('vat', "(\n".sj#Trim(body)."\n)")
    return 1
  endif

  " is it a self-closing tag?
  let body = sj#GetMotion('va>')
  if body =~ '^<\k\+.*/>$'
    if body =~ "\n"
      " multiple lines, not splitting
      return 0
    endif

    call sj#ReplaceMotion('va>', "(\n".sj#Trim(body)."\n)")
    return 1
  endif

  return 0
endfunction

function! sj#jsx#JoinJsxExpression()
  " Examples:
  "
  "   let x = (
  "   () => (
  "   return (
  "
  let pattern = '\%(\%(let\|const\|var\)\s\+\k\+\s*=\s*\|)\s*=>\|return\s\+\)\s*($'
  if sj#SearchUnderCursor(pattern) <= 0
    return 0
  endif

  normal! $
  let body = sj#Trim(sj#GetMotion('vi('))
  if body =~ "\n"
    " multiline tag, no point in handling
    return 0
  endif

  if body !~ '^<\k\+.*/>$' && body !~ '^<\(\k\+\).*</\1>$'
    " doesn't look like a tag
    return 0
  endif

  call sj#ReplaceMotion('va(', body)
  return 1
endfunction

function! sj#jsx#SplitSelfClosingTag()
  if s:noTagUnderCursor()
    return 0
  endif

  let tag = sj#GetMotion('va<')
  if tag == '' || tag !~ '^<\k'
    return 0
  endif

  " is it self-closing?
  if tag !~ '/>$'
    return 0
  endif

  let tag_name = matchstr(tag, '^<\zs\k[^>/[:space:]]*')
  let replacement = substitute(tag, '\s*/>$', '>\n</'.tag_name.'>', '')
  call sj#ReplaceMotion('va<', replacement)
  return 1
endfunction

" Needs to be called with the cursor on a starting or ending tag to work.
function! sj#jsx#JoinHtmlTag()
  if s:noTagUnderCursor()
    return 0
  endif

  let tag = sj#GetMotion('vat')
  if tag =~ '^\s*$'
    return 0
  endif

  let tag_name          = matchstr(tag, '^<\zs\k[^>/[:space:]]*')
  let empty_tag_pattern = '>\_s*</\s*'.tag_name.'\s*>$'

  if tag =~ empty_tag_pattern
    " then there's no contents, let's turn it into a self-closing tag
    let self_closing_tag = substitute(tag, empty_tag_pattern, ' />', '')
    if self_closing_tag == tag
      " then the substitution failed for some reason
      return 0
    endif

    call sj#ReplaceMotion('vat', self_closing_tag)
  else
    " There's contents in the tag, let's try to single-line it
    if len(split(tag, "\n")) == 1
      " already single-line, nothing to do
      return 0
    endif

    let body = sj#GetMotion('vit')
    let body = join(sj#TrimList(split(body, "\n")), ' ')

    call sj#ReplaceMotion('vit', body)
  end

  return 1
endfunction

function! s:noTagUnderCursor()
  return searchpair('<', '', '>', 'cb', '', line('.')) <= 0
        \ && searchpair('<', '', '>', 'c', '', line('.')) <= 0
endfunction
