function! sj#go#SplitImports()
  let pattern = '^import\s\+\(\%(\k\+\s\+\)\=\%(".*"\)\)$'

  if getline('.') =~ pattern
    call sj#Keeppatterns('s/' . pattern . '/import (\r\1\r)/')
    normal! k==
    return 1
  else
    return 0
  endif
endfunction

function! sj#go#JoinImports()
  if getline('.') =~ '^import\s*($' &&
        \ getline(line('.') + 1) =~ '^\s*\%(\k\+\s\+\)\=".*"$' &&
        \ getline(line('.') + 2) =~ '^)$'
    call sj#Keeppatterns('s/^import (\_s\+\(\%(\k\+\s\+\)\=\(".*"\)\)\_s\+)$/import \1/')
    return 1
  else
    return 0
  endif
endfunction

function! sj#go#SplitVars() abort
  let pattern = '^\s*\(var\|type\|const\)\s\+[[:keyword:], ]\+=\='
  if sj#SearchUnderCursor(pattern) <= 0
    return 0
  endif

  call search(pattern, 'Wce', line('.'))
  let line = getline('.')

  if line[col('.') - 1] == '='
    " before and after =
    let lhs = sj#Trim(strpart(line, 0, col('.') - 1))
    let rhs = sj#Ltrim(strpart(line, col('.')))

    let values_parser = sj#argparser#go_vars#Construct(rhs)
    call values_parser.Process()

    let values = values_parser.args
    let comment = values_parser.comment
  else
    let [comment, comment_start, _] = matchstrpos(line, '\s*\%(\/\/.*\)\=$')
    if comment == ""
      let lhs = sj#Trim(line)
    else
      let lhs = sj#Trim(strpart(line, 0, comment_start))
    endif

    let values = []
  endif

  if len(values) > 0 && values[-1] =~ '[{([]\s*$'
    " the value is incomplete, so let's not attempt to split it
    return 0
  endif

  let [prefix, _, prefix_end] = matchstrpos(lhs, '^\s*\(var\|type\|const\)\s\+')
  let lhs = strpart(lhs, prefix_end)

  let variables = []
  let last_type = ''
  for variable in reverse(split(lhs, ',\s*'))
    let variable = sj#Trim(variable)
    let type = matchstr(variable, '^\k\+\s\+\zs\S.*$')

    if empty(type) && !empty(last_type)
      " No type, take the last one that we saw going backwards
      call add(variables, variable . ' ' . last_type)
    else
      let last_type = type
      call add(variables, variable)
    endif
  endfor
  call reverse(variables)

  let declarations = []
  for i in range(0, len(variables) - 1)
    if i < len(values)
      call add(declarations, variables[i] . ' = ' . values[i])
    else
      call add(declarations, variables[i])
    endif
  endfor

  let replacement = prefix . "(\n"
  let replacement .= join(declarations, "\n")
  let replacement .= "\n)"
  if comment != ''
    let replacement .= ' ' . sj#Ltrim(comment)
  endif

  call sj#ReplaceMotion('_vg_', replacement)
  return 0
endfunction

function! sj#go#JoinVars() abort
  let pattern = '^\s*\(var\|type\|const\)\s\+('
  if sj#SearchUnderCursor(pattern) <= 0
    return 0
  endif

  call search(pattern, 'Wce', line('.'))

  let declarations = sj#TrimList(split(sj#GetMotion('vi('), "\n"))
  if len(declarations) == 1
    " Only one line, so just join it as-is
    call sj#ReplaceMotion('va(', declarations[0])
    return 1
  endif

  let variables = []
  let values = []
  let types = []

  for line in declarations
    let [lhs, _, match_end] = matchstrpos(line, '.\{-}\s*=\s*')

    if match_end > -1
      let variable_description = matchstr(lhs, '.\{-}\ze\s*=\s*')
      let line = substitute(line, ',$', '', '')
      call add(values, strpart(line, match_end))
    else
      let line = substitute(line, ',$', '', '')
      let variable_description = line
    endif

    let [variable, _, match_end] = matchstrpos(variable_description, '^\k\+\s*')
    let type = strpart(variable_description, match_end)
    call add(variables, { 'variable': sj#Rtrim(variable), 'type': type })
    call add(types, type)
  endfor

  if len(variables) == 0
    return 0
  endif

  if len(uniq(types)) > 1
    " We have assignment to values, but we also have different types, so it
    " can't be on one line
    return 0
  endif

  " Handle var one, two string -> one should also get "string"
  let declarations = []
  let index = 0
  for entry in variables
    if empty(entry.type) || (len(variables) > index + 1 && entry.type ==# variables[index + 1].type)
      " This variable's type is the same as the next one's, so skip it
      call add(declarations, entry.variable)
    elseif empty(entry.type)
      call add(declarations, entry.variable)
    else
      call add(declarations, entry.variable . ' ' . entry.type)
    endif

    let index += 1
  endfor

  let combined_declaration = join(declarations, ', ')
  if len(values) > 0
    let combined_declaration .= ' = ' . join(values, ', ')
  endif

  call sj#ReplaceMotion('va(', combined_declaration)
  return 1
endfunction

function! sj#go#SplitStruct()
  let [start, end] = sj#LocateBracesAroundCursor('{', '}', ['goString', 'goComment'])
  if start < 0 && end < 0
    return 0
  endif

  let args = sj#ParseJsonObjectBody(start + 1, end - 1)
  if len(args) == 0
    return 0
  endif

  for arg in args
    if arg !~ '^\k\+\s*:'
      " this is not really a struct instantiation
      return 0
    end
  endfor

  call sj#ReplaceCols(start + 1, end - 1, "\n".join(args, ",\n").",\n")
  return 1
endfunction

function! sj#go#JoinStructDeclaration()
  let start_lineno = line('.')
  let pattern = '^\s*type\s\+.*\s*\zsstruct\s*{$'

  if search(pattern, 'Wc', line('.')) <= 0 &&
        \ search(pattern, 'Wcb', line('.')) <= 0
    return 0
  endif

  call sj#PushCursor()
  normal! f{%
  let end_lineno = line('.')

  if start_lineno == end_lineno
    " we haven't moved, brackets not found
    call sj#PopCursor()
    return 0
  endif

  let arguments = []
  for line in getbufline('%', start_lineno + 1, end_lineno - 1)
    let argument = substitute(line, ',$', '', '')
    let argument = sj#Trim(argument)

    if argument != ''
      call add(arguments, argument)
    endif
  endfor

  if len(arguments) == 0
    let replacement = 'struct{}'
  else
    let replacement = 'struct{ ' . join(arguments, ', ') . ' }'
  endif

  call sj#PopCursor()
  call sj#ReplaceMotion('vf{%', replacement)
  return 1
endfunction

function! sj#go#JoinStruct()
  let start_lineno = line('.')
  let pattern = '\k\+\s*{$'

  if search(pattern, 'Wc', line('.')) <= 0 &&
        \ search(pattern, 'Wcb', line('.')) <= 0
    return 0
  endif

  call search(pattern, 'Wce', line('.'))

  normal! %
  let end_lineno = line('.')

  if start_lineno == end_lineno
    " we haven't moved, brackets not found
    return 0
  endif

  let arguments = []
  for line in getbufline('%', start_lineno + 1, end_lineno - 1)
    let argument = substitute(line, ',$', '', '')
    let argument = sj#Trim(argument)

    if argument !~ '^\k\+\s*:'
      " this is not really a struct instantiation
      return 0
    end

    if sj#settings#Read('normalize_whitespace')
      let argument = substitute(argument, '^\k\+\zs:\s\+', ': ', 'g')
    endif

    call add(arguments, argument)
  endfor

  let replacement = '{' .  join(arguments, ', ') .  '}'
  call sj#ReplaceMotion('va{', replacement)
  return 1
endfunction

function! sj#go#SplitSingleLineCurlyBracketBlock()
  let [start, end] = sj#LocateBracesAroundCursor('{', '}', ['goString', 'goComment'])
  if start < 0 && end < 0
    return 0
  endif

  let body = sj#GetMotion('vi{')

  if getline('.')[0:start - 1] =~# '\<struct\s*{$'
    " struct { is enforced by gofmt
    let padding = ' '
  else
    let padding = ''
  endif

  call sj#ReplaceMotion('va{', padding."{\n".sj#Trim(body)."\n}")
  return 1
endfunction

function! sj#go#JoinSingleLineFunctionBody()
  let start_lineno = line('.')

  if search('{$', 'Wc', line('.')) <= 0
    return 0
  endif

  normal! %
  let end_lineno = line('.')

  if start_lineno == end_lineno
    " we haven't moved, brackets not found
    return 0
  endif

  if end_lineno - start_lineno > 2
    " more than one line between them, can't join
    return 0
  endif

  normal! va{J
  return 1
endfunction

function! sj#go#SplitFunc()
  let pattern = '^func\%(\s*(.\{-})\s*\)\=\s\+\k\+\zs('
  if search(pattern, 'Wcn', line('.')) <= 0 &&
        \ search(pattern, 'Wbcn', line('.')) <= 0
    return 0
  endif

  let split_type = ''

  let [start, end] = sj#LocateBracesAroundCursor('(', ')', ['goString', 'goComment'])
  if start > 0
    let split_type = 'definition_list'
  else
    let [start, end] = sj#LocateBracesAroundCursor('{', '}', ['goString', 'goComment'])

    if start > 0
      let split_type = 'function_body'
    endif
  endif

  if split_type == 'function_body'
    let contents = sj#Trim(sj#GetCols(start + 1, end - 1))
    call sj#ReplaceCols(start + 1, end - 1, "\n".contents."\n")
    return 1
  elseif split_type == 'definition_list'
    let parsed = sj#ParseJsonObjectBody(start + 1, end - 1)

    " Keep `a, b int` variable groups on the same line
    let arg_groups = []
    let typed_arg_group = ''
    for elem in parsed
      if match(elem, '\s\+') != -1
        let typed_arg_group .= elem
        call add(arg_groups, typed_arg_group)
        let typed_arg_group = ''
      else
        " not typed here, group it with later vars
        let typed_arg_group .= elem . ', '
      endif
    endfor

    call sj#ReplaceCols(start + 1, end - 1, "\n".join(arg_groups, ",\n").",\n")
    return 1
  else
    return 0
  endif
endfunction

function! sj#go#SplitFuncCall()
  let [start, end] = sj#LocateBracesAroundCursor('(', ')', ['goString', 'goComment'])
  if start < 0 && end < 0
    return 0
  endif

  let args = sj#ParseJsonObjectBody(start + 1, end - 1)
  call sj#ReplaceCols(start + 1, end - 1, "\n".join(args, ",\n").",\n")
  return 1
endfunction

function! sj#go#JoinFuncCallOrDefinition()
  let start_lineno = line('.')

  if search('($', 'Wc', line('.')) <= 0
    return 0
  endif

  if strpart(getline('.'), 0, col('.')) =~ '\(var\|type\|const\|import\)\s\+($'
    " This isn't a function call, it's a multiline var/const/type declaration
    return 0
  endif

  normal! %
  let end_lineno = line('.')

  if start_lineno == end_lineno
    " we haven't moved, brackets not found
    return 0
  endif

  let arguments = []
  for line in getbufline('%', start_lineno + 1, end_lineno - 1)
    let argument = substitute(line, ',$', '', '')
    let argument = sj#Trim(argument)
    call add(arguments, argument)
  endfor

  let replacement = '(' . join(arguments, ', ') . ')'
  call sj#ReplaceMotion('va(', replacement)
  return 1
endfunction
