function! sj#tex#SplitBlock()
  let arg_pattern = '[a-zA-Z*]'
  let opts_pattern = '\%(\%({.\{-}}\)\|\%(\[.\{-}]\)\)*'

  if searchpair('\s*\zs\\begin{'.arg_pattern.'\{-}}'.opts_pattern, '', '\\end{'.arg_pattern.'\{-}}', 'bc', '') != line('.')
    return 0
  endif

  let start = getpos('.')
  if searchpair('\\begin{'.arg_pattern.'\{-}}', '', '\\end{'.arg_pattern.'\{-}\zs}', '') != line('.')
    return 0
  endif
  let end = getpos('.')

  let block = sj#GetByPosition(start, end)

  let pattern = '^\(\\begin{'.arg_pattern.'\{-}}'.opts_pattern.'\)\(.\{-}\)\(\\end{'.arg_pattern.'\{-}}\)$'
  let match = matchlist(block, pattern)
  if empty(match)
    return 0
  endif

  let [_match, open, body, close; _rest] = match
  let body = sj#Trim(substitute(body, '\\\\', '\\\\'."\n", 'g'))
  let body = sj#Trim(substitute(body, '\s*\\item', "\n".'\\item', 'g'))
  let replacement = open."\n".body."\n".close

  call sj#ReplaceByPosition(start, end, replacement)
  return 1
endfunction

function! sj#tex#JoinBlock()
  let arg_pattern = '[a-zA-Z*]'
  let opts_pattern = '\%(\%({.\{-}}\)\|\%(\[.\{-}]\)\)*'

  if search('\s*\\begin{', 'bcW', line('.')) <= 0
    return 0
  endif
  call search('\\begin{', 'cW', line('.'))

  let start = getpos('.')
  if searchpair('\\begin{'.arg_pattern.'\{-}}', '', '\\end{'.arg_pattern.'\{-}\zs}') <= 0
    return 0
  endif
  let end = getpos('.')

  let block = sj#GetByPosition(start, end)

  let pattern = '^\(\\begin{'.arg_pattern.'\{-}}'.opts_pattern.'\)\_s\+\(.\{-}\)\_s\+\(\\end{'.arg_pattern.'\{-}}\)$'
  let match = matchlist(block, pattern)
  if empty(match)
    return 0
  endif

  let [_match, open, body, close; _rest] = match

  let lines = split(body, '\\\\\_s\+')
  let body = join(lines, '\\ ')

  if body =~ '\\item'
    let lines = sj#TrimList(split(body, '\\item'))
    let body = '\item '.join(lines, ' \item ')
  endif

  let replacement = open." ".body." ".close

  call sj#ReplaceByPosition(start, end, replacement)
  return 1
endfunction
