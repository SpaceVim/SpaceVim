let s:skip_syntax = sj#SkipSyntax(['String', 'Comment'])

function! sj#clojure#SplitList()
  if sj#SearchSkip('[([{]', s:skip_syntax, 'bW', line('.'), ) <= 0
    return 0
  endif

  call sj#PushCursor()
  let start_col = col('.')
  let bracket = getline('.')[start_col - 1]

  if bracket == '('
    let closing_bracket = ')'
  elseif bracket == '['
    let closing_bracket = '\]'
  elseif bracket == '{'
    let closing_bracket = '}'
  else
    throw "Unknown bracket: " . bracket
  endif

  if searchpair(bracket, '', closing_bracket, 'W', s:skip_syntax, line('.')) <= 0
    call sj#PopCursor()
    return 0
  endif

  let end_col = col('.')

  let parser = sj#argparser#clojure#Construct(start_col + 1, end_col - 1, getline('.'))
  call parser.Process()
  if len(parser.args) <= 0
    call sj#PopCursor()
    return 0
  endif

  call sj#PopCursor()
  call sj#ReplaceMotion('vi' . bracket, join(parser.args, "\n"))
  return 1
endfunction

function! sj#clojure#JoinList()
  if sj#SearchSkip('[([{]', s:skip_syntax, 'bW') <= 0
    return 0
  endif

  let bracket = getline('.')[col('.') - 1]
  exe 'normal! va'.bracket.'J'
  return 1
endfunction
