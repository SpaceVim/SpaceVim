let s:skip_syntax = sj#SkipSyntax(['String', 'Comment'])
let s:eol_pattern = '\s*\%(//.*\)\=$'

" TODO (2023-02-25) running substitute() on semicolons won't work well for
" strings. Need a generic solution, sj#DelimiterOffsets(

function! sj#rust#SplitMatchExpression()
  if !sj#SearchUnderCursor('\<match .* {')
    return 0
  endif

  call sj#JumpBracketsTill('{', {'opening': '([<"''', 'closing': ')]>"'''})
  let [from, to] = sj#LocateBracesAroundCursor('{', '}')
  if from < 0 && to < 0
    return 0
  endif

  let parser = sj#argparser#rust_struct#Construct(from + 1, to - 1, getline('.'))
  call parser.Process()
  let args = parser.args
  if len(args) <= 0
    return 0
  endif

  let items = map(args, 'v:val.argument')
  let body = join(items, ",\n")
  if sj#settings#Read('trailing_comma')
    let body .= ','
  endif
  let body = "{\n" . body . "\n}"

  call sj#ReplaceCols(from, to, body)
  return 1
endfunction

function! sj#rust#SplitMatchClause()
  if !sj#SearchUnderCursor('^.*\s*=>\s*.*$')
    return 0
  endif

  if !search('=>\s*\zs.', 'W', line('.'))
    return 0
  endif

  let start_col = col('.')
  if !search(',\='.s:eol_pattern, 'W', line('.'))
    return 0
  endif

  " handle trailing comma if there is one
  if getline('.')[col('.') - 1] == ','
    let content_end_col = col('.')
    let body_end_col = content_end_col - 1
  else
    let content_end_col = col('.')
    let body_end_col = content_end_col
  endif

  let body = sj#Trim(sj#GetCols(start_col, body_end_col))
  if body =~ '[({[.,*/%+-]$'
    " ends in an opening bracket or operator of some sorts, so it's
    " incomplete, don't touch it
    return 0
  endif

  let body = substitute(body, '^{\s*\(.\{-}\)\s*}$', '\1', '')
  call sj#ReplaceCols(start_col, content_end_col, "{\n".body."\n},")
  return 1
endfunction

function! sj#rust#JoinMatchClause()
  if !sj#SearchUnderCursor('^.*\s*=>\s*{\s*$')
    return 0
  endif

  call search('=>\s*\zs{', 'W', line('.'))

  let body = sj#Trim(sj#GetMotion('Vi{'))
  if stridx(body, "\n") >= 0
    return 0
  endif

  if len(body) == 0
    call sj#ReplaceMotion('va{', '{}')
    return 1
  endif

  " Remove semicolons when joining, they don't work in non-block form
  if body[len(body) - 1] == ';'
    let body = body[0 : len(body) - 2]
  endif

  call sj#ReplaceMotion('Va{', body)
  return 1
endfunction

function! sj#rust#SplitQuestionMark()
  if sj#SearchSkip('.?', s:skip_syntax, 'Wc', line('.')) <= 0
    return 0
  endif

  let current_line = line('.')
  let end_col = col('.')
  let question_mark_col = col('.') + 1
  let char = getline('.')[end_col - 1]

  let previous_start_col = -2
  let start_col = -1

  while previous_start_col != start_col
    let previous_start_col = start_col

    if char =~ '\k'
      call search('\k\+?;', 'bWc', line('.'))
      let start_col = col('.')
    elseif char == '}'
      " go to opening bracket
      normal! %
      let start_col = col('.')
    elseif char == ')'
      " go to opening bracket
      normal! %
      " find first method-call char
      call search('\%(\k\|\.\|::\)\+!\?(', 'bWc')

      if line('.') != current_line
        " multiline expression, let's just ignore it
        return 0
      endif

      let start_col = col('.')
    else
      break
    endif

    if start_col <= 1
      " first character, no previous one
      break
    endif

    " move backwards one step from the start
    let pos = getpos('.')
    let pos[2] = start_col - 1
    call setpos('.', pos)
    let char = getline('.')[col('.') - 1]
  endwhile

  " is it a Result, or an Option?
  let expr_type = s:FunctionReturnType()
  " default to a Result, if we can't find anything
  if expr_type == ''
    let expr_type = 'Result'
  endif
  let expr = sj#GetCols(start_col, end_col)

  if expr_type == 'Result'
    let replacement = join([
          \   "match ".expr." {",
          \   "  Ok(value) => value,",
          \   "  Err(e) => return Err(e.into()),",
          \   "}"
          \ ], "\n")
  elseif expr_type == 'Option'
    let replacement = join([
          \   "match ".expr." {",
          \   "  None => return None,",
          \   "  Some(value) => value,",
          \   "}"
          \ ], "\n")
  else
    echoerr "Unknown expr_type: ".expr_type
    return 0
  endif

  call sj#ReplaceCols(start_col, question_mark_col, replacement)
  return 1
endfunction

function! sj#rust#JoinMatchStatement()
  let match_pattern = '\<match .* {$'

  if sj#SearchSkip(match_pattern, s:skip_syntax, 'Wc', line('.')) <= 0
        \ && sj#SearchSkip(match_pattern, s:skip_syntax, 'Wbc', line('.')) <= 0
    return 0
  endif

  " is it a Result, or an Option?
  let return_type = s:FunctionReturnType()

  let match_position = getpos('.')
  let match_line = match_position[1]
  let match_col = match_position[2]

  let remainder_of_line = strpart(getline('.'), match_col - 1)
  let expr = substitute(remainder_of_line, '^match \(.*\) {$', '\1', '')

  let first_line   = match_line + 1
  let second_line  = match_line + 2
  let closing_line = match_line + 3

  let ok_pattern   = '^\s*Ok(\(\k\+\))\s*=>\s*\1'
  let err_pattern  = '^\s*Err(\k\+)\s*=>\s*return\s\+Err('
  let some_pattern = '^\s*Some(\(\k\+\))\s*=>\s*\1'
  let none_pattern = '^\s*None\s*=>\s*return\s\+None\>'

  if getline(first_line) =~# ok_pattern || getline(second_line) =~# ok_pattern
    let expr_type = 'Result'
  elseif getline(first_line) =~# none_pattern || getline(second_line) =~# none_pattern
    let expr_type = 'Option'
  else
    return 0
  endif

  if getline(second_line) =~# err_pattern || getline(first_line) =~# err_pattern
    let expr_type = 'Result'
  elseif getline(second_line) =~# some_pattern || getline(first_line) =~# some_pattern
    let expr_type = 'Option'
  else
    return 0
  endif

  if search('^\s*}\ze', 'We', closing_line) <= 0
    return 0
  endif

  let end_position = getpos('.')

  if expr_type == return_type
    call sj#ReplaceByPosition(match_position, end_position, expr.'?')
  else
    call sj#ReplaceByPosition(match_position, end_position, expr.'.unwrap()')
  endif

  return 1
endfunction

function! sj#rust#SplitBlockClosure()
  if sj#SearchUnderCursor('|.\{-}|\s*\zs{', 'Wc', s:skip_syntax, line('.')) <= 0
    return 0
  endif

  let closure_contents = sj#GetMotion('vi{')
  let closure_contents = substitute(closure_contents, ';\ze.', ";\n", 'g')
  call sj#ReplaceMotion('va{', "{\n".sj#Trim(closure_contents)."\n}")
  return 1
endfunction

function! sj#rust#SplitExprClosure()
  if !sj#SearchUnderCursor('|.\{-}| [^{]')
    return 0
  endif
  if search('|.\{-}| \zs.', 'W', line('.')) <= 0
    return 0
  endif

  let start_col = col('.')
  let end_col = sj#JumpBracketsTill('\%([,;]\|$\)', {'opening': '([<{"''', 'closing': ')]>}"'''})
  if end_col == col('$')
    " found end-of-line, one character past the actual end
    let end_col -= 1
  endif

  let closure_contents = sj#GetCols(start_col, end_col)
  if closure_contents =~ '[({[.,*/%+-]$'
    " ends in an opening bracket or operator of some sorts, so it's
    " incomplete, don't touch it
    return 0
  endif

  call sj#ReplaceCols(start_col, end_col, "{\n".closure_contents."\n}")
  return 1
endfunction

function! sj#rust#JoinClosure()
  if !sj#SearchUnderCursor('|.\{-}| {\s*$')
    return 0
  endif
  if search('|.\{-}| \zs{\s*$', 'W', line('.')) <= 0
    return 0
  endif

  " check if we've got an empty block:
  if sj#GetMotion('va{') =~ '^{\_s*}$'
    return 0
  endif

  let closure_contents = sj#Trim(sj#GetMotion('vi{'))
  let lines = sj#TrimList(split(closure_contents, "\n"))

  if len(lines) > 1
    let replacement = '{ '.join(lines, ' ').' }'
  elseif len(lines) == 1
    let replacement = lines[0]
  else
    " No contents, leave nothing inside
    let replacement = ' '
  endif

  call sj#ReplaceMotion('va{', replacement)
  return 1
endfunction

function! sj#rust#SplitCurlyBrackets()
  " in case we're on a struct name, go to the bracket:
  call sj#SearchUnderCursor('\k\+\s*{', 'e')
  " in case we're in an if-clause, go to the bracket:
  call sj#SearchUnderCursor('\<if .\{-}{', 'e')

  let [from, to] = sj#LocateBracesAroundCursor('{', '}')
  if from < 0 && to < 0
    return 0
  endif

  if (to - from) < 2
    call sj#ReplaceMotion('va{', "{\n\n}")
    return 1
  endif

  let body = sj#Trim(sj#GetCols(from + 1, to - 1))
  if len(body) == 0
    call sj#ReplaceMotion('va{', "{\n\n}")
    return 1
  endif

  let prefix = sj#GetCols(0, from - 1)
  let indent = indent(line('.')) + (exists('*shiftwidth') ? shiftwidth() : &sw)

  let parser = sj#argparser#rust_struct#Construct(from + 1, to - 1, getline('.'))
  call parser.Process()
  let args = parser.args
  if len(args) <= 0
    return 0
  endif

  if prefix =~ '^\s*use\s\+\%(\k\+::\)\+\s*$'
    " then it's a module import:
    "   use my_mod::{Alpha, Beta as _, Gamma};
    let imports = map(args, 'v:val.argument')
    let body = join(imports, ",\n")
    if sj#settings#Read('trailing_comma')
      let body .= ','
    endif

    call sj#ReplaceCols(from, to, "{\n".body."\n}")
  elseif parser.IsValidStruct()
    let is_only_pairs = parser.IsOnlyStructPairs()

    let items = []
    let last_arg = ''
    for arg in args
      let last_arg = arg.argument

      " attributes are not indented, so let's give them appropriate whitespace
      let whitespace = repeat(' ', indent)
      let components = map(copy(arg.attributes), 'whitespace.v:val')

      call add(components, arg.argument)
      call add(items, join(components, "\n"))
    endfor

    let body = join(items, ",\n")
    if sj#settings#Read('trailing_comma')
      if last_arg =~ '^\.\.'
        " interpolated struct, a trailing comma would be invalid
      else
        let body .= ','
      endif
    endif

    call sj#ReplaceCols(from, to, "{\n".body."\n}")

    if is_only_pairs && sj#settings#Read('align')
      let body_start = line('.') + 1
      let body_end   = body_start + len(items) - 1

      if items[-1] =~ '^\.\.'
        " interpolated struct, don't align that one
        let body_end -= 1
      endif

      if body_end - body_start > 0
        call sj#Align(body_start, body_end, 'json_object')
      endif
    endif
  else
    " it's just a normal block, ignore the parsed content
    let body = substitute(body, ';\ze.', ";\n", 'g')
    call sj#ReplaceCols(from, to, "{\n".body."\n}")
  endif

  return 1
endfunction

function! sj#rust#JoinCurlyBrackets()
  let line = getline('.')
  if line !~ '{\s*$'
    return 0
  endif
  call search('{', 'c', line('.'))

  if eval(s:skip_syntax)
    return 0
  endif

  " check if we've got an empty block:
  if sj#GetMotion('va{') =~ '^{\_s*}$'
    call sj#ReplaceMotion('va{', '{}')
    return 1
  endif

  let body = sj#GetMotion('Vi{')
  let lines = split(body, "\n")
  let lines = sj#TrimList(lines)

  let body = join(lines, ' ')
  " just in case we're joining a StructName { key: value, }:
  let body = substitute(body, ',$', '', '')

  let in_import = 0
  if line =~ '^\s*use\s\+\%(\k\+::\)\+\s*{$'
    let in_import = 1
  endif
  if !in_import
    let pos = getpos('.')

    " we might still be in a nested import, let's see if we can find it
    while searchpair('{', '', '}', 'Wb', s:skip_syntax, 0, 100) > 0
      if getline('.') =~ '^\s*use\s\+\%(\k\+::\)\+\s*{$'
        let in_import = 1
        break
      endif
    endwhile

    call setpos('.', pos)
  endif

  if in_import
    let body = '{'.body.'}'
  elseif sj#settings#Read('curly_brace_padding')
    let body = '{ '.body.' }'
  else
    let body = '{'.body.'}'
  endif

  if sj#settings#Read('normalize_whitespace')
    let body = substitute(body, '\s\+\k\+\zs:\s\+', ': ', 'g')
  endif

  call sj#ReplaceMotion('Va{', body)
  return 1
endfunction

function! sj#rust#SplitUnwrapIntoEmptyMatch()
  let unwrap_pattern = '\S\.\%(unwrap\|expect\)('
  if sj#SearchUnderCursor(unwrap_pattern, 'e', s:skip_syntax) <= 0
    return 0
  endif

  normal! %
  let unwrap_end_col = col('.')
  normal! %
  call search(unwrap_pattern, 'Wb', line('.'))
  let end_col = col('.')

  let start_col = col('.')
  while start_col > 0
    let current_expr = strpart(getline('.'), start_col - 1, end_col)
    if current_expr =~ '^)'
      normal! %
    elseif current_expr =~ '^\%(::\|\.\)'
      normal! h
    else
      if sj#SearchSkip('\%(::\|\.\)\=\k\+\%#', s:skip_syntax, 'Wb', line('.')) <= 0
        break
      endif
    endif

    if start_col == col('.')
      " then nothing has changed this loop, break out
      break
    else
      let start_col = col('.')
    endif
  endwhile

  let expr = sj#GetCols(start_col, end_col)
  if expr == ''
    return 0
  endif

  if start_col >= end_col
    " the expression is probably split into several lines, let's ignore it
    return 0
  endif

  call sj#ReplaceCols(start_col, unwrap_end_col, join([
        \ "match ".expr." {",
        \ "",
        \ "}",
        \ ], "\n"))
  return 1
endfunction

function! sj#rust#SplitIfLetIntoMatch()
  let if_let_pattern =  'if\s\+let\s\+\(.*\)\s\+=\s\+\(.\{-}\)\s*{'
  let else_pattern = '}\s\+else\s\+{'

  if search(if_let_pattern, 'We', line('.')) <= 0
    return 0
  endif

  let match_line = substitute(getline('.'), if_let_pattern, "match \\2 {\n\\1 => {", '')
  let body = sj#Trim(sj#GetMotion('vi{'))

  " multiple lines or ends with `;` -> wrap it in a block
  if len(split(body, "\n")) > 1 || body =~ ';'.s:eol_pattern
    let body = "{\n".body."\n}"
  endif

  " Is there an else clause?
  call sj#PushCursor()
  let else_body = '()'
  normal! %
  if search(else_pattern, 'We', line('.')) > 0
    let else_body = sj#Trim(sj#GetMotion('vi{'))

    " multiple lines or ends with `;` -> wrap it in a block
    if len(split(else_body, "\n")) > 1 || else_body =~ ';'.s:eol_pattern
      let else_body = "{\n".else_body."\n}"
    endif

    " Delete block, delete rest of line:
    normal! "_da{T}"_D
  endif

  " Back to the if-let line:
  call sj#PopCursor()
  call sj#ReplaceMotion('V', match_line)
  normal! j$
  call sj#ReplaceMotion('Va{', body.",\n_ => ".else_body.",\n}")

  return 1
endfunction

function! sj#rust#SplitArgs()
  return s:SplitList(['(', ')'], 'cursor_on_line')
endfunction

function! sj#rust#SplitArray()
  return s:SplitList(['[', ']'], 'cursor_inside')
endfunction

function! sj#rust#JoinEmptyMatchIntoIfLet()
  let match_pattern = '\<match\s\+\zs.\{-}\ze\s\+{$'
  let pattern_pattern = '^\s*\zs.\{-}\ze\s\+=>'

  if search(match_pattern, 'Wc', line('.')) <= 0
    return 0
  endif

  let outer_start_lineno = line('.')
  let [_, match_start_col] = searchpos('\<match\s\+', 'nbW', line('.'))

  " find end point
  normal! f{%
  let outer_end_lineno = line('.')

  let inner_start_lineno = search(pattern_pattern, 'Wb', outer_start_lineno)
  if inner_start_lineno <= 0
    return 0
  endif

  let inner_start_lineno = line('.')
  if getline(inner_start_lineno) =~ '^\s*_\s*=>'
    " it's a default match, ignore this one for now
    let inner_start_lineno = search(pattern_pattern, 'Wb', outer_start_lineno)
    if inner_start_lineno <= 0
      return 0
    endif

    if getline(inner_start_lineno) =~ '^\s*_\s*=>'
      " more than one _ => clause?
      return 0
    endif
  endif

  if getline(inner_start_lineno) =~ '{,\=\s*$'
    " it's a block, mark its area:
    exe inner_start_lineno
    normal! 0f{%
    let inner_end_lineno = line('.')
  else
    " not a }, so just one line
    let inner_end_lineno = inner_start_lineno
  endif

  if prevnonblank(inner_start_lineno - 1) != outer_start_lineno
    " the inner start is not immediately after the outer start
    return 0
  endif

  let match_value   = sj#Trim(matchstr(getline(outer_start_lineno), match_pattern))
  let match_pattern = sj#Trim(matchstr(getline(inner_start_lineno), pattern_pattern))

  " currently on inner start, so let's take its contents:
  if inner_start_lineno == inner_end_lineno
    " one-line body, take everything up to the comma
    exe inner_start_lineno
    let body = substitute(getline('.'), '^\s*.\{-}\s\+=>\s*\(.\{-}\),\=\s*$', '\1', '')
  else
    " block body, take everything inside
    let body = sj#Trim(sj#GetMotion('vi{'))
  endif

  " look for an else clause
  call sj#PushCursor()
  exe outer_start_lineno
  let else_body = ''
  if search('^\s*_\s*=>\s*\zs\S', 'W', outer_end_lineno) > 0
    let fallback_value = strpart(getline('.'), col('.') - 1)

    if fallback_value =~ '^(\s*)\|^{\s*}'
      " ignore it
    elseif fallback_value =~ '^{'
      " the else-clause is going to be in a block
      let else_body = sj#Trim(sj#GetMotion('vi{'))
    else
      " one-line value, remove its trailing comma and any comments
      let else_body = substitute(fallback_value, ','.s:eol_pattern, '', '')
    endif
  endif

  call sj#PopCursor()

  " jump on outer start
  exe outer_start_lineno
  call sj#ReplaceCols(match_start_col, col('$'), 'if let '.match_pattern.' = '.match_value." {\n")
  normal! $
  call sj#ReplaceMotion('va{', "{\n".body."\n}")

  if else_body != ''
    normal! 0f{%
    call sj#ReplaceMotion('V', "} else {\n".else_body."\n}")
  endif

  return 1
endfunction

function! sj#rust#SplitImportList()
  if sj#SearchUnderCursor('^\s*use\s\+\%(\k\+::\)\+{', 'e') <= 0
    return 0
  endif

  let prefix = sj#Trim(strpart(getline('.'), 0, col('.') - 1))
  let body   = sj#GetMotion('vi{')
  let parser = sj#argparser#rust_struct#Construct(1, len(body), body)

  call parser.Process()

  let expanded_imports = []
  for arg in parser.args
    let import = arg.argument

    if import == 'self'
      let expanded_import = substitute(prefix, '::$', ';', '')
    else
      let expanded_import = prefix . import . ';'
    end

    call add(expanded_imports, expanded_import)
  endfor

  if len(expanded_imports) <= 0
    return 0
  endif

  let attributes = s:GetLineAttributes(line('.'))

  if len(attributes) > 0
    let attribute_block = join(attributes, "\n")
    let expanded_imports = [expanded_imports[0]] + map(expanded_imports[1:-1], 'attribute_block . "\n" . v:val')
  endif

  let replacement = join(expanded_imports, "\n")
  if body =~ '\n'
    " Select a multiline area
    call sj#ReplaceMotion('va{$o0', replacement . "\n")
  else
    call sj#ReplaceMotion('V', replacement)
  endif

  return 1
endfunction

function! sj#rust#JoinImportList()
  let import_pattern = '^\s*use\s\+\%(\k\+::\)\+'
  let attribute_pattern = '^\s*#['

  if sj#SearchUnderCursor(import_pattern) <= 0
    return 0
  endif

  let first_import = getline('.')
  let first_import = substitute(first_import, ';'.s:eol_pattern, '', '')
  let imports = [sj#Trim(first_import)]

  let start_line = line('.')
  let last_line = line('.')
  let attributes = s:GetLineAttributes(start_line)

  " If there's no attributes, get the next line, otherwise skip the attribute
  " lines
  exe 'normal! ' . (len(attributes) + 1) . 'j'

  while sj#SearchUnderCursor(import_pattern) > 0
    if line('.') == last_line
      " we haven't moved, stop here
      break
    endif

    let local_attributes = s:GetLineAttributes(line('.'))
    if local_attributes != attributes
      " This import is not compatible, stop here
      break
    endif

    let last_line = line('.')

    let import_line = getline('.')
    let import_line = substitute(import_line, ';'.s:eol_pattern, '', '')

    call add(imports, sj#Trim(import_line))
    exe 'normal! ' . (len(attributes) + 1) . 'j'
  endwhile

  if len(imports) <= 1
    return 0
  endif

  " find common prefix based on first two imports
  let first_prefix_parts  = split(imports[0], '::')
  let second_prefix_parts = split(imports[1], '::')

  if first_prefix_parts[0] != second_prefix_parts[0]
    " no match at all, nothing we can do
    return 0
  endif

  " find only the next ones that match the common prefix
  let common_prefix = ''
  for i in range(1, min([len(first_prefix_parts), len(second_prefix_parts)]) - 1)
    if first_prefix_parts[i] != second_prefix_parts[i]
      let common_prefix = join(first_prefix_parts[:(i - 1)], '::')
      break
    endif
  endfor

  if common_prefix == ''
    if len(imports[0]) > len(imports[1])
      let longer_import  = imports[0]
      let shorter_import = imports[1]
    else
      let longer_import  = imports[1]
      let shorter_import = imports[0]
    endif

    " it hasn't been changed, meaning we completely matched the shorter import
    " within the longer.
    if longer_import == shorter_import
      " they're perfectly identical, just delete the first line and move on
      exe start_line . 'delete'
      return 1
    elseif stridx(longer_import, shorter_import) == 0
      " the shorter is included, consider it a prefix, and we'll puts `self`
      " in there later
      let common_prefix = shorter_import
    else
      " something unexpected went wrong, let's give up
      return 0
    endif
  endif

  let compatible_imports = imports[:1]
  for import in imports[2:]
    if stridx(import, common_prefix) == 0
      call add(compatible_imports, import)
    else
      break
    endif
  endfor

  " Get the differences between the imports
  let differences = []
  for import in compatible_imports
    let difference = strpart(import, len(common_prefix))
    let difference = substitute(difference, '^::', '', '')

    if difference =~ '^{.*}$'
      " there's a list of imports, merge them together
      let parser = sj#argparser#rust_struct#Construct(2, len(difference) - 1, difference)
      call parser.Process()
      for part in map(parser.args, 'v:val.argument')
        call add(differences, part)
      endfor
    elseif len(difference) == 0
      " this is the parent module
      call add(differences, 'self')
    else
      call add(differences, difference)
    endif
  endfor

  if exists('*uniq')
    " remove successive duplicates
    call uniq(differences)
  endif

  let replacement = common_prefix . '::{' . join(differences, ', ') . '};'

  let attribute_line_count = (len(compatible_imports) - 1) * len(attributes)
  let end_line = start_line + len(compatible_imports) + attribute_line_count - 1

  call sj#ReplaceLines(start_line, end_line, replacement)
  return 1
endfunction

function! sj#rust#JoinArgs()
  return s:JoinList(['(', ')'])
endfunction

function! sj#rust#JoinArray()
  return s:JoinList(['[', ']'])
endfunction

function! s:FunctionReturnType()
  let found_result = search(')\_s\+->\_s\+\%(\k\|::\)*Result\>', 'Wbn')
  let found_option = search(')\_s\+->\_s\+\%(\k\|::\)*Option\>', 'Wbn')

  if found_result <= 0 && found_option <= 0
    return ''
  elseif found_result > found_option
    return 'Result'
  elseif found_option > found_result
    return 'Option'
  else
    return ''
  endif
endfunction

function s:GetLineAttributes(line)
  let end_line = prevnonblank(a:line - 1)

  if getline(end_line) !~ '^\s*#['
    return []
  endif

  let start_line = end_line
  let tested_line = start_line

  while getline(tested_line) =~ '^\s*#['
    let start_line = tested_line
    let tested_line = prevnonblank(tested_line - 1)
  endwhile

  return getline(start_line, end_line)
endfunction

function! s:SplitList(delimiter, cursor_position)
  let start = a:delimiter[0]
  let end   = a:delimiter[1]

  let lineno = line('.')
  let indent = indent('.')

  if a:cursor_position == 'cursor_inside'
    let [from, to] = sj#LocateBracesAroundCursor(start, end)
  elseif a:cursor_position == 'cursor_on_line'
    let [from, to] = sj#LocateBracesOnLine(start, end)
  else
    echoerr "Invalid value for a:cursor_position: ".a:cursor_position
    return
  endif

  if from < 0 && to < 0
    return 0
  endif

  let line = getline('.')

  if start == '(' && from > 1 && strpart(line, 0, from - 1) =~ '\<fn \k\+\%(<.*>\)$'
    let parser_type = 'fn'
  else
    let parser_type = 'list'
  endif

  let parser = sj#argparser#rust_list#Construct(parser_type, from + 1, to - 1, line)
  call parser.Process()
  let items = parser.args
  if empty(items)
    return 0
  endif

  if sj#settings#Read('trailing_comma')
    let body = start."\n".join(items, ",\n").",\n".end
  else
    let body = start."\n".join(items, ",\n")."\n".end
  endif

  call sj#ReplaceMotion('Va'.start, body)

  return 1
endfunction

function! s:JoinList(delimiter)
  let start = a:delimiter[0]
  let end   = a:delimiter[1]

  let line = getline('.')

  if line !~ start . '\s*$'
    return 0
  endif

  call search(start, 'c', line('.'))
  let body = sj#GetMotion('Vi'.start)

  let lines = split(body, "\n")
  let lines = sj#TrimList(lines)
  let body  = sj#Trim(join(lines, ' '))
  let body  = substitute(body, ',\s*$', '', '')

  call sj#ReplaceMotion('Va'.start, start.body.end)

  return 1
endfunction
