function! sj#scss#SplitNestedDefinition()
  if search('{\s*$', 'Wn', line('.')) <= 0
    return 0
  endif

  if search('\s\zs\S\+', 'Wbc', line('.')) <= 0
    return 0
  endif

  let prefix = sj#Trim(strpart(getline('.'), 0, col('.') - 2))
  let suffix = sj#Trim(strpart(getline('.'), col('.') - 2, col('$')))
  let suffix = substitute(suffix, '\s*{$', '', '')

  if prefix == '' || suffix == ''
    return 0
  endif

  call sj#ReplaceMotion('V', prefix.' {')
  normal! f{
  let body = sj#GetMotion('vi{')
  call sj#ReplaceMotion('vi{', suffix." {\n".body."}\n")

  return 1
endfunction

function! sj#scss#JoinNestedDefinition()
  if search('{\s*$', 'We', line('.')) <= 0
    return 0
  endif

  let outer_start_lineno = line('.')

  " find end point
  normal! %
  let outer_end_lineno = line('.')
  let inner_end_lineno = prevnonblank(outer_end_lineno - 1)
  if inner_end_lineno == 0
    " No inner end } found
    return 0
  endif
  if getline(inner_end_lineno) !~ '^\s*}\s*$'
    " not a } character
    return 0
  endif

  exe inner_end_lineno
  normal! 0f}%
  let inner_start_lineno = line('.')

  if prevnonblank(inner_start_lineno - 1) != outer_start_lineno
    " the inner start is not immediately after the outer start
    return 0
  endif

  let outer_definition = sj#Trim(substitute(getline(outer_start_lineno), '{\s*$', '', ''))
  let inner_definition = sj#Trim(substitute(getline(inner_start_lineno), '{\s*$', '', ''))

  " currently on inner start, so let's take its contents:
  let body = sj#Trim(sj#GetMotion('vi{'))

  " jump on outer start
  exe outer_start_lineno
  call sj#ReplaceMotion('V', outer_definition.' '.inner_definition. ' {')
  normal! 0f{
  call sj#ReplaceMotion('va{', "{\n".body."\n}")

  return 1
endfunction
