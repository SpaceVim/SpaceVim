" Only real syntax that's interesting is cParen and cConditional
let s:skip = sj#SkipSyntax(['cComment', 'cCommentL', 'cString', 'cCppString', 'cBlock'])

function! sj#c#SplitFuncall()
  if sj#SearchUnderCursor('(.\{-})', '', s:skip) <= 0
    return 0
  endif

  call sj#PushCursor()

  normal! l
  let start = col('.')
  normal! h%h
  let end = col('.')

  let items = sj#ParseJsonObjectBody(start, end)

  let body = "("
  if sj#settings#Read('c_argument_split_first_newline')
    let body = "(\n"
  endif

  let body .= join(items, ",\n")

  if sj#settings#Read('c_argument_split_last_newline')
    let body .= "\n)"
  else
    let body .= ")"
  endif

  call sj#PopCursor()

  call sj#ReplaceMotion('va(', body)
  return 1
endfunction

function! sj#c#SplitIfClause()
  if sj#SearchUnderCursor('if\s*(.\{-})', '', s:skip) <= 0
    return 0
  endif

  let items = sj#TrimList(split(getline('.'), '\ze\(&&\|||\)'))
  let body  = join(items, "\n")

  call sj#ReplaceMotion('V', body)
  return 1
endfunction

function! sj#c#JoinFuncall()
  if sj#SearchUnderCursor('([^)]*\s*$', '', s:skip) <= 0
    return 0
  endif

  normal! va(J
  return 1
endfunction

function! sj#c#JoinIfClause()
  if sj#SearchUnderCursor('if\s*([^)]*\s*$', '', s:skip) <=  0
    return 0
  endif

  call sj#PushCursor()
  normal! f(
  normal! va(J
  call sj#PopCursor()
  return 1
endfunction
