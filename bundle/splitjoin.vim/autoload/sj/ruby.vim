let s:invalid_function_names = [
      \   'and', 'case', 'class', 'def', 'else',
      \   'elseif', 'for', 'if', 'in', 'module',
      \   'not', 'or', 'rescue', 'return', 'then',
      \   'unless', 'until', 'when', 'while', 'yield'
      \ ]

function! sj#ruby#SplitIfClause()
  let pattern = '\v(.*\S.*) \zs(if|unless|while|until) (.*)'
  let skip = sj#SkipSyntax(['rubyString', 'rubyComment'])

  normal! 0

  if sj#SearchSkip(pattern, skip, 'W', line('.')) <= 0
    return 0
  endif

  let line = getline('.')
  let body = trim(strpart(line, 0, col('.') - 1))
  let if_clause = trim(strpart(line, col('.') - 1))

  let replacement = if_clause . "\n" . body . "\nend"
  call sj#ReplaceMotion('V', replacement)

  return 1
endfunction

function! sj#ruby#JoinIfClause()
  let line    = getline('.')
  let pattern = '\v^\s*(if|unless|while|until)'

  if line !~ pattern
    return 0
  endif

  let if_line_no = line('.')
  let else_line_pattern = '^'.repeat(' ', indent(if_line_no)).'else\s*\%(#.*\)\=$'
  let end_line_pattern = '^'.repeat(' ', indent(if_line_no)).'end\s*\%(#.*\)\=$'

  let else_line_no = search(else_line_pattern, 'W')
  call cursor(if_line_no, 1)
  let end_line_no = search(end_line_pattern, 'W')

  if end_line_no <= 0
    return 0
  endif

  if end_line_no - if_line_no != 2
    return 0
  endif

  if else_line_no && else_line_no < end_line_no
    return 0
  endif

  let [result, offset] = s:HandleComments(if_line_no, end_line_no)
  if !result
    return 1
  endif
  let if_line_no += offset
  let end_line_no += offset

  let lines = sj#GetLines(if_line_no, end_line_no)

  let if_line  = lines[0]
  let end_line = lines[-1]
  let body     = join(lines[1:-2], "\n")

  let if_line = sj#Trim(if_line)
  let body    = sj#Trim(body)

  let replacement = body.' '.if_line

  call sj#ReplaceLines(if_line_no, end_line_no, replacement)
  return 1
endfunction

function! sj#ruby#SplitTernaryClause()
  let line               = getline('.')
  let ternary_pattern    = '\v(\@{0,2}\w.*) \? (.*) : (.*)'
  let assignment_pattern = '\v^\s*\w* \= '

  if line =~ ternary_pattern
    let assignment = matchstr(line, assignment_pattern)

    if assignment != ''
      let line = substitute(line, assignment_pattern, '', '')
      let line = substitute(line, '(\(.*\))', '\1', '')

      call sj#ReplaceMotion('V', substitute(line, ternary_pattern,
            \ assignment.'if \1\n\2\nelse\n\3\nend', ''))
    else
      call sj#ReplaceMotion('V', substitute(line, ternary_pattern,
            \'if \1\n\2\nelse\n\3\nend', ''))
    endif

    return 1
  else
    return 0
  endif
endfunction

function! sj#ruby#JoinTernaryClause()
  let line    = getline('.')
  let pattern = '\v(if|unless) '

  if line =~ pattern
    let if_line_no = line('.')

    let else_line_no = if_line_no + 2
    let end_line_no  = if_line_no + 4

    let else_line = getline(else_line_no)
    let end_line  = getline(end_line_no)

    let clause_is_valid = 0

    " Three formats are allowed, all ifs can be replaced with unless
    "
    " if condition
    "   true
    " else
    "   false
    " end
    "
    " x = if condition    "     x = if condition
    "       true          "       true
    "     else            "     else
    "       false         "       false
    "     end             "     end
    "
    if else_line =~ '^\s*else\s*$' && end_line =~ '^\s*end\s*$'
      let if_column = match(line, pattern)
      let else_column = match(else_line, 'else')
      let end_column = match(end_line, 'end')
      let if_line_indent = indent(if_line_no)

      if else_column == end_column
        if (else_column == if_column) || (else_column == if_line_indent)
          let clause_is_valid = 1
        endif
      endif
    end

    if clause_is_valid
      let [result, offset] = s:HandleComments(if_line_no, end_line_no)
      if !result
        return 1
      endif
      let if_line_no   += offset
      let else_line_no += offset
      let end_line_no  += offset

      let upper_body = getline(if_line_no + 1)
      let lower_body = getline(else_line_no + 1)
      let upper_body = sj#Trim(upper_body)
      let lower_body = sj#Trim(lower_body)

      let assignment = matchstr(upper_body, '\v^.{-} \= ')

      if assignment != '' && lower_body =~ '^'.assignment
        let upper_body = substitute(upper_body, '^'.assignment, '', '')
        let lower_body = substitute(lower_body, '^'.assignment, '', '')
      else
        " clean the assignment var if it's invalid, so we don't have
        " to care about it later on
        let assignment = ''
      endif

      if line =~ 'if'
        let body = [upper_body, lower_body]
      else
        let body = [lower_body, upper_body]
      endif

      let body_str = join(body, " : ")
      let condition = substitute(line, pattern, '', '')
      let condition = substitute(condition, '\v^(\s*)', '\1'.assignment, '')

      let replacement = condition.' ? '.body_str

      if line =~ '\v\= (if|unless)' || assignment != ''
        let replacement = substitute(replacement, '\v(\= )(.*)', '\1(\2)', '')
      endif

      call sj#ReplaceLines(if_line_no, end_line_no, replacement)

      return 1
    endif
  endif

  return 0
endfunction

function! sj#ruby#JoinCase()
  let line_no = line('.')
  let line = getline('.')
  if line =~ '.*case'
    let end_line_pattern = '^'.repeat(' ', indent(line_no)).'end\s*$'
    let end_line_no = search(end_line_pattern, 'W')
    let lines = sj#GetLines(line_no + 1, end_line_no - 1)
    let counter = 1
    for body_line in lines
      call cursor(line_no + counter, 1)
      if ! call('sj#ruby#JoinWhenThen', [])
        let counter = counter + 1
      endif
    endfor

    " try to join else for extremely well formed cases and use
    " an alignment tool (optional)
    call cursor(line_no, 1)
    let new_end_line_no = search(end_line_pattern, 'W')
    let else_line_no = new_end_line_no - 2
    let else_line = getline(else_line_no)
    if else_line =~ '^'.repeat(' ', indent(line_no)).'else\s*$'
      let lines = sj#GetLines(line_no + 1, else_line_no - 1)
      if s:AllLinesStartWithWhen(lines)
        let next_line = getline(else_line_no + 1)
        let next_line = sj#Trim(next_line)
        let replacement = else_line.' '.next_line
        call sj#ReplaceLines(else_line_no, else_line_no + 1, replacement)
        if sj#settings#Read('align')
          call sj#Align(line_no + 1, else_line_no - 1, 'when_then')
        endif
      endif
    else
      " no else line
      if sj#settings#Read('align')
        call sj#Align(line_no + 1, new_end_line_no - 1, 'when_then')
      endif
    endif

    " and check the new endline again for changes
    call cursor(line_no, 1)
    let new_end_line_no = search(end_line_pattern, 'W')

    if end_line_no > new_end_line_no
      return 1
    endif
  endif

  return 0
endfunction

function! s:AllLinesStartWithWhen(lines)
  for line in a:lines
    if line !~ '\s*when'
      return 0
    end
  endfor
  return 1
endfunction

function! sj#ruby#SplitCase()
  let line_no = line('.')
  let line = getline('.')
  if line =~ '.*case'
    let end_line_pattern = '^'.repeat(' ', indent(line_no)).'end\s*$'
    let end_line_no = search(end_line_pattern, 'W')
    let lines = sj#GetLines(line_no + 1, end_line_no - 1)
    let counter = 1
    for body_line in lines
      call cursor(line_no + counter, 1)
      if call('sj#ruby#SplitWhenThen', [])
        let counter = counter + 2
      else
        let counter = counter + 1
      endif
    endfor

    call cursor(line_no, 1)
    let new_end_line_no = search(end_line_pattern, 'W')
    let else_line_no = new_end_line_no - 1
    let else_line = getline(else_line_no)
    if else_line =~ '^'.repeat(' ', indent(line_no)).'else.*'
      call cursor(else_line_no, 1)
      call sj#ReplaceMotion('V', substitute(else_line, '\v^(\s*else) (.*)', '\1\n\2', ''))
      call cursor(else_line_no, 1)
      let new_end_line_no = search(end_line_pattern, 'W')
    endif

    if end_line_no > new_end_line_no
      return 1
    endif
  endif

  return 0
endfunction

function! sj#ruby#SplitWhenThen()
  let line = getline('.')
  let pattern = '\v(s*when.*) then (.*)'

  if line =~ pattern
    call sj#ReplaceMotion('V', substitute(line, pattern, '\1\n\2', ''))
    return 1
  else
    return 0
  endif
endfunction

function! sj#ruby#JoinWhenThen()
  let line = getline('.')

  if line =~ '^\s*when'
    let line_no = line('.')
    let one_down = getline(line_no + 1)
    let two_down = getline(line_no + 2)
    let pattern = '\v^\s*(when|else|end)>'

    if one_down !~ pattern && two_down =~ pattern
      let one_down = sj#Trim(one_down)
      let replacement = line.' then '.one_down
      call sj#ReplaceLines(line_no, line_no + 1, replacement)
      return 1
    end
  end

  return 0
endfunction

function! sj#ruby#SplitProcShorthand()
  let pattern = '(&:\k\+[!?]\=)'

  if sj#SearchUnderCursor(pattern) <= 0
    return 0
  endif

  if search('(&:\zs\k\+[!?]\=)', '', line('.')) <= 0
    return 0
  endif

  let method_name = matchstr(sj#GetMotion('Vi('), '\k\+[!?]\=')
  let body = " do |i|\ni.".method_name."\nend"

  call sj#ReplaceMotion('Va(', body)
  return 1
endfunction

function! sj#ruby#SplitBlock()
  let pattern = '\v\{\s*(\|.{-}\|)?\s*(.*)\s*\}'

  if sj#SearchUnderCursor('\v%(\k|!|\-\>|\?|\))\s*\zs'.pattern) <= 0
    return 0
  endif

  let start = col('.')
  normal! %
  let end = col('.')

  if start == end
    " the cursor hasn't moved, bail out
    return 0
  endif

  let body = sj#GetMotion('Va{')

  if sj#settings#Read('ruby_do_block_split')
    let multiline_block = 'do \1\n\2\nend'
  else
    let multiline_block = '{ \1\n\2\n}'
  endif

  normal! %
  if search('\S\%#', 'Wbn')
    let multiline_block = ' '.multiline_block
  endif

  let replacement = substitute(body, '^'.pattern.'$', multiline_block, '')

  " remove leftover whitespace
  let replacement = substitute(replacement, '\s*\n', '\n', 'g')

  call sj#ReplaceMotion('Va{', replacement)

  normal! j0
  while sj#SearchSkip(';', sj#SkipSyntax(['rubyString']), 'W', line('.')) > 0
    call execute("normal! r\<cr>")
  endwhile

  return 1
endfunction

function! sj#ruby#JoinBlock()
  let do_pattern = '\<do\>\(\s*|.*|\s*\)\?$'
  let end_pattern = '\%(^\|[^.:@$]\)\@<=\<end:\@!\>'

  let do_line_no = search(do_pattern, 'cW', line('.'))
  if do_line_no <= 0
    let do_line_no = search(do_pattern, 'bcW', line('.'))
  endif

  if do_line_no <= 0
    return 0
  endif

  let end_line_no = searchpair(do_pattern, '', end_pattern, 'W')

  let [result, offset] = s:HandleComments(do_line_no, end_line_no)
  if !result
    return 1
  endif
  let do_line_no += offset
  let end_line_no += offset

  let lines = sj#GetLines(do_line_no, end_line_no)
  let lines = sj#TrimList(lines)
  let lines = sj#RemoveBlanks(lines)

  let do_line  = substitute(lines[0], do_pattern, '{\1', '')
  let body     = s:JoinBlockBody(lines[1:-2])
  let body     = sj#Trim(body)
  let end_line = substitute(lines[-1], 'end', '}', '')

  let replacement = do_line.' '.body.' '.end_line

  " shorthand to_proc if possible
  let replacement = substitute(replacement, '\s*{ |\(\k\+\)| \1\.\(\k\+[!?]\=\) }$', '(\&:\2)', '')

  call sj#ReplaceLines(do_line_no, end_line_no, replacement)

  return 1
endfunction

function! s:JoinBlockBody(lines)
  let lines = a:lines

  if len(lines) < 1
    return ''
  endif

  let body = lines[0]
  " horrible regex taken from vim-ruby
  let continuation_regex =
        \ '\%(%\@<![({[\\.,:*/%+]\|\<and\|\<or\|\%(<%\)\@<![=-]\|:\@<![^[:alnum:]:][|&?]\|||\|&&\)\s*\%(#.*\)\=$'

  for line in lines[1:]
    if body =~ continuation_regex
      let body .= ' '.line
    else
      let body .= '; '.line
    endif
  endfor

  return body
endfunction

function! sj#ruby#SplitCachingConstruct()
  let line = getline('.')

  if line =~ '||=' && line !~ '||=\s\+begin\>'
    let replacement = substitute(line, '||=\s\+\(.*\)$', '||= begin\n\1\nend', '')
    call sj#ReplaceMotion('V', replacement)

    return 1
  else
    return 0
  endif
endfunction

function! sj#ruby#JoinCachingConstruct()
  let begin_line = getline('.')
  let body_line  = getline(line('.') + 1)
  let end_line   = getline(line('.') + 2)

  if begin_line =~ '||=\s\+begin' && end_line =~ '^\s*end'
    let lvalue      = substitute(begin_line, '\s\+||=\s\+begin.*$', '', '')
    let body        = sj#Trim(body_line)
    let replacement = lvalue.' ||= '.body

    call sj#ReplaceLines(line('.'), line('.') + 2, replacement)

    return 1
  else
    return 0
  endif
endfunction

function! sj#ruby#JoinHash()
  let line = getline('.')

  if line =~ '{\s*$'
    return s:JoinHashWithCurlyBraces()
  elseif line =~ '(\s*$'
    return s:JoinHashWithRoundBraces()
  elseif line =~ ',\s*$'
    " also ends up being called for `(foo, bar,` situations
    return s:JoinHashWithoutBraces()
  else
    return 0
  endif
endfunction

function! sj#ruby#SplitOptions()
  " Variables:
  "
  " option_type:   ['option', 'hash']
  " function_type: ['none', 'with_spaces', 'with_round_braces']
  "

  call sj#PushCursor()
  let [function_name, function_from, function_to, function_type] = sj#argparser#ruby#LocateFunction()
  call sj#PopCursor()

  if index(s:invalid_function_names, function_name) >= 0
    return 0
  endif

  call sj#PushCursor()
  let [hash_from, hash_to] = sj#argparser#ruby#LocateHash()
  call sj#PopCursor()

  if hash_from >= 0 && function_from < 0
    let option_type = 'hash'
  else
    let option_type = 'option'
  endif

  if function_from >= 0
    let from = function_from
    let to = function_to
  else
    let from = hash_from
    let to = hash_to
  endif

  if from < 0
    return 0
  endif

  let start_lineno = line('.')
  let [from, to, args, opts, hash_type, cursor_arg] =
        \ sj#argparser#ruby#ParseArguments(from, to, getline('.'), { 'expand_options': 1 })

  if !(from <= col('.') && col('.') <= to)
    " then this is not around the cursor, bail out
    return 0
  endif

  let no_options = len(opts) < 1 && len(args) > 0 && option_type == 'option'
  let both_args_and_opts = sj#settings#Read('ruby_options_as_arguments') && cursor_arg < len(args)

  if no_options || both_args_and_opts
    " which case is it?
    if no_options
      " no options found, but there are arguments, split those
      let replacement = join(args, ",\n")
    elseif both_args_and_opts
      " the cursor is on an argument, split both args and opts
      let all_args = []
      call extend(all_args, args)
      call extend(all_args, opts)
      let replacement = join(all_args, ",\n")
    endif

    if !sj#settings#Read('ruby_hanging_args')
      " add trailing comma
      if sj#settings#Read('ruby_trailing_comma') || sj#settings#Read('trailing_comma')
        let replacement .= ','
      endif

      let replacement = "\n".replacement."\n"
    elseif len(args) == 1
      " if there's only one argument, there's nothing to do in the "hanging"
      " case
      return 0
    endif

    if function_type == 'with_spaces'
      let replacement = "(".replacement.")"
      let from -= 1 " Also replace the space before the argument list
    endif

    call sj#ReplaceCols(from, to, replacement)
    return 1
  endif

  let replacement = ''

  " first, prepare the already-existing arguments
  if len(args) > 0
    let replacement .= join(args, ', ') . ','
  endif

  " add opening brace
  if sj#settings#Read('ruby_curly_braces')

    if option_type == 'hash'
      " Example: one = {:two => 'three'}
      "
      let replacement .= "{\n"
    elseif function_type == 'with_round_braces' && len(args) > 0
      " Example: create(:inquiry, :state => state)
      "
      let replacement .= " {\n"
    elseif function_type == 'with_round_braces' && len(args) == 0
      " Example: create(one: 'two', three: 'four')
      "
      let replacement .= "{\n"
    else
      " add braces in all other cases
      let replacement .= " {\n"
    endif

  else " !sj#settings#Read('ruby_curly_braces')

    if option_type == 'option' && function_type == 'with_round_braces' && len(args) > 0
      " Example: User.new(:one, :two => 'three')
      "
      let replacement .= "\n"
    elseif option_type == 'option' && function_type == 'with_spaces' && len(args) > 0
      " Example: User.new :one, :two => 'three'
      "
      let replacement .= "\n"
    elseif option_type == 'hash' && function_type == 'none'
      " Not a function call, but a hash
      " Example: one = {:two => "three"}
      "
      let replacement .= "{\n"
    endif

  endif

  " add options
  let replacement .= join(opts, ",\n")

  " add trailing comma
  if sj#settings#Read('ruby_trailing_comma') || sj#settings#Read('trailing_comma')
    let replacement .= ','
  endif

  " add closing brace
  if !sj#settings#Read('ruby_curly_braces') && option_type == 'option' && function_type == 'with_round_braces'
    if sj#settings#Read('ruby_hanging_args')
      " no need to do anything
    else
      let replacement = "\n".replacement."\n"
    endif
  elseif sj#settings#Read('ruby_curly_braces') || option_type == 'hash' || len(args) == 0
    let replacement .= "\n}"
  endif

  call sj#ReplaceCols(from, to, replacement)

  if sj#settings#Read('align') && hash_type != 'mixed'
    " find index of first option
    let first_keyword_index = 0
    for line in split(replacement, "\n", 1)
      let line = substitute(sj#Trim(line), ',$', '', '')
      if index(opts, line) >= 0
        break
      endif

      let first_keyword_index += 1
    endfor

    let alignment_start = start_lineno + first_keyword_index
    let alignment_end = alignment_start + len(opts) - 1

    if hash_type == 'classic'
      call sj#Align(alignment_start, alignment_end, 'hashrocket')
    elseif hash_type == 'new'
      call sj#Align(alignment_start, alignment_end, 'json_object')
    endif
  endif

  return 1
endfunction

function! sj#ruby#SplitArray()
  let [from, to] = sj#LocateBracesAroundCursor('[', ']', [
        \ 'rubyInterpolationDelimiter',
        \ 'rubyString',
        \ 'rubyStringDelimiter',
        \ 'rubySymbolDelimiter',
        \ 'rubyPercentStringDelimiter',
        \ 'rubyPercentSymbolDelimiter',
        \ ])

  if from < 0
    return 0
  endif

  let [from, to, args, opts; _rest] = sj#argparser#ruby#ParseArguments(from + 1, to - 1, getline('.'), {
        \ 'expand_options': sj#settings#Read('ruby_expand_options_in_arrays')
        \ })

  if from < 0
    return 0
  endif
  let items = extend(args, opts)

  let replacement = join(items, ",\n")

  if sj#settings#Read('ruby_trailing_comma') || sj#settings#Read('trailing_comma')
    let replacement .= ','
  endif

  let replacement = "\n".replacement."\n"
  call sj#ReplaceCols(from, to, replacement)
  return 1
endfunction

function! sj#ruby#JoinArray()
  normal! $

  if getline('.')[col('.') - 1] != '['
    return 0
  endif

  let syntax_group = synIDattr(synID(line('.'), col('.'), 1), "name")
  if syntax_group =~ 'ruby\%(Percent\)\=\(String\|Symbol\)\%(Delimiter\)\='
    return 0
  endif

  let body = sj#Trim(sj#GetMotion('Vi['))
  " remove trailing comma
  let body = substitute(body, ',\ze\_s*$', '', '')
  let body = join(sj#TrimList(split(body, ",\s*\n")), ', ')
  call sj#ReplaceMotion('Va[', '['.body.']')

  return 1
endfunction

function! sj#ruby#JoinContinuedMethodCall()
  if getline('.') !~ '\.$' && getline(nextnonblank(line('.') + 1)) !~ '^\s*\.'
    return 0
  endif

  let start_lineno = line('.')
  silent! normal! zO
  normal! j

  while line('.') < line('$') &&
        \ (getline('.') =~ '\.$' || getline(nextnonblank(line('.') + 1)) =~ '^\s*\.')
    normal! j
  endwhile

  let end_lineno = line('.') - 1

  call sj#Keeppatterns(start_lineno.','.end_lineno.'s/\n\_s*//')
  return 1
endfunction

function! sj#ruby#JoinHeredoc()
  let heredoc_pattern = '<<[-~]\?\([^ \t,)]\+\)'

  if sj#SearchUnderCursor(heredoc_pattern) <= 0
    return 0
  endif

  let start_lineno      = line('.')
  let remainder_of_line = sj#GetCols(col('.'), col('$'))
  let delimiter         = sj#ExtractRx(remainder_of_line, heredoc_pattern, '\1')

  " we won't be needing the rest of the line
  normal! "_D

  if search('^\s*'.delimiter.'\s*$', 'W') <= 0
    return 0
  endif

  let end_lineno = line('.')

  if end_lineno - start_lineno > 1
    let lines = sj#GetLines(start_lineno + 1, end_lineno - 1)
    let lines = sj#TrimList(lines)
    let body  = join(lines, " ")
  else
    let body = ''
  endif

  if body =~ '\%(#{\|''\)'
    let quoted_body = '"'.escape(escape(body, '"'), '\').'"'
  else
    let quoted_body = "'".body."'"
  endif

  let replacement = getline(start_lineno).substitute(remainder_of_line, heredoc_pattern, quoted_body, '')
  call sj#ReplaceLines(start_lineno, end_lineno, replacement)
  undojoin " with the 'normal! D'

  return 1
endfunction

function! sj#ruby#SplitString()
  let string_pattern       = '\(\%(^\|[^\\]\)\zs\([''"]\)\).\{-}[^\\]\+\2'
  let empty_string_pattern = '\%(''''\|""\)'

  let [match_start, match_end] = sj#SearchColsUnderCursor(string_pattern)
  if match_start <= 0
    let [match_start, match_end] = sj#SearchColsUnderCursor(empty_string_pattern)
    if match_start <= 0
      return 0
    endif
  endif

  let string    = sj#GetCols(match_start, match_end - 1)
  let delimiter = string[0]

  if match_end - match_start > 2
    let string_body = sj#GetCols(match_start + 1, match_end - 2)."\n"
  else
    let string_body = ''
  endif

  if delimiter == '"'
    let string_body = substitute(string_body, '\\"', '"', 'g')
  elseif delimiter == "'"
    let string_body = substitute(string_body, "\\''", "'", 'g')
  endif

  if sj#settings#Read('ruby_heredoc_type') == '<<-'
    call sj#ReplaceCols(match_start, match_end - 1, '<<-EOF')
    let replacement = getline('.')."\n".string_body."EOF"
    call sj#ReplaceMotion('V', replacement)
  elseif sj#settings#Read('ruby_heredoc_type') == '<<~'
    call sj#ReplaceCols(match_start, match_end - 1, '<<~EOF')
    let replacement = getline('.')."\n".string_body."EOF"
    call sj#ReplaceMotion('V', replacement)
    if string_body != ''
      exe (line('.') + 1).'>'
    endif
  elseif sj#settings#Read('ruby_heredoc_type') == '<<'
    call sj#ReplaceCols(match_start, match_end - 1, '<<EOF')
    let replacement = getline('.')."\n".string_body."EOF"
    call sj#ReplaceMotion('V', replacement)
    exe (line('.') + 1).','.(line('.') + 2).'s/^\s*//'
  else
    throw 'Unknown value for option "ruby_heredoc_type", "'.g:splitjoin_ruby_heredoc_type.'"'
  endif

  return 1
endfunction

function! sj#ruby#SplitArrayLiteral()
  let syntax_group = synIDattr(synID(line('.'), col('.'), 1), "name")
  if syntax_group !~ 'ruby\%(Percent\)\=\(String\|Symbol\)\%(Delimiter\)\='
    return 0
  endif

  let lineno = line('.')
  let indent = indent('.')

  if search('%[wiWI]', 'Wbce', line('.')) <= 0 &&
        \ search('%[wiWI]', 'Wce', line('.')) <= 0
    return 0
  endif

  if col('.') == col('$')
    " we're at the end of the line, bail out
    return 0
  endif

  normal! l
  let opening_bracket = getline('.')[col('.') - 1]

  if col('.') == col('$')
    " we're at the end of the line, bail out
    return 0
  endif
  normal! l

  let closing_bracket = s:ArrayLiteralClosingBracket(opening_bracket)

  let array_pattern = '\V'.opening_bracket.'\m\zs.*\ze\V'.closing_bracket
  let [start_col, end_col] = sj#SearchColsUnderCursor(array_pattern)
  if start_col <= 0
    return 0
  endif

  if start_col == end_col - 1
    " just insert a newline, nothing inside the list
    exe "normal! i\<cr>"
    call sj#SetIndent(end_col, indent)
    return 1
  endif

  let array_body = sj#GetCols(start_col, end_col - 1)
  let array_items = split(array_body, '\s\+')
  call sj#ReplaceCols(start_col, end_col - 1, "\n".join(array_items, "\n")."\n")

  call sj#SetIndent(lineno + 1, lineno + len(array_items), indent + &sw)
  call sj#SetIndent(lineno + len(array_items) + 1, indent)

  return 1
endfunction

function! sj#ruby#JoinArrayLiteral()
  let syntax_group = synIDattr(synID(line('.'), col('.'), 1), "name")
  if syntax_group !~ 'ruby\%(Percent\)\=\(String\|Symbol\)\%(Delimiter\)\='
    return 0
  endif

  if search('%[wiWI].$', 'Wce', line('.')) <= 0
    return 0
  endif

  let opening_bracket = getline('.')[col('.') - 1]
  let closing_bracket = s:ArrayLiteralClosingBracket(opening_bracket)

  let start_lineno = line('.')
  let end_lineno   = start_lineno + 1
  let end_pattern  = '^\s*\V'.closing_bracket.'\m\s*$'
  let word_pattern =  '^\%(\k\|\s\)*$'

  while end_lineno <= line('$') && getline(end_lineno) !~ end_pattern
    if getline(end_lineno) !~ word_pattern
      return 0
    endif
    let end_lineno += 1
  endwhile

  if getline(end_lineno) !~ end_pattern
    return 0
  endif

  if end_lineno - start_lineno < 1
    " nothing to join, bail out
    return 0
  endif

  if end_lineno - start_lineno == 1
    call sj#Keeppatterns('s/\n\_s*//')
    return 1
  endif

  let words = sj#TrimList(sj#GetLines(start_lineno + 1, end_lineno - 1))
  call sj#ReplaceLines(start_lineno + 1, end_lineno, join(words, ' ').closing_bracket)
  exe start_lineno
  call sj#Keeppatterns('s/\n\_s*//')

  return 1
endfunction

function! sj#ruby#JoinModuleNamespace()
  " Initialize matchit, a requirement
  if !exists('g:loaded_matchit')
    if has(':packadd')
      packadd matchit
    else
      runtime macros/matchit.vim
    endif
  endif
  if !exists('g:loaded_matchit')
    " then loading it somehow failed, we can't continue
    return 0
  endif

  let namespace_pattern = '^\s*module\s\+\zs[A-Z]\(\k\|::\)*\s*$'
  let class_pattern = '^\s*class\s\+\zs[A-Z]\k*\s*\(\k\|::\)\+\s*\%(<\s\+\S\+\)\=$'
  let describe_pattern = '^\s*\%(RSpec\.\)\=describe\s\+\zs[A-Z]\(\k\|::\)*\s*do'

  if search(namespace_pattern, 'Wbc', line('.')) <= 0
    return 0
  endif

  " Pin the starting point
  let module_start_line = line('.')
  let start_indent = indent('.')
  let modules = [expand('<cWORD>')]
  let keyword = 'module'
  normal! j0

  " Find the end point
  let module_end_line = module_start_line
  while search(namespace_pattern, 'Wc', line('.')) > 0
    let module_end_line = line('.')
    call add(modules, expand('<cWORD>'))
    normal! j0

    " That way, modules get joined piecewise. This might be guarded with an
    " option at a later time:
    break
  endwhile

  " most of these cases don't end in "do"
  let do_suffix = ''

  if search(class_pattern, 'Wc', line('.')) > 0
    " then the end is a class line
    let module_end_line = line('.')
    call add(modules, sj#GetMotion('vg_'))
    let keyword = 'class'
  elseif search(describe_pattern, 'Wc', line('.')) > 0
    " then the end is an RSpec describe line
    let module_end_line = line('.')
    let start_col = col('.')
    let [_, end_col] = searchpos('\k\s*do$', 'n')
    if start_col >= end_col
      return 0
    endif
    call add(modules, sj#GetCols(start_col, end_col))
    if getline('.') =~ 'RSpec\.describe'
      let keyword = 'RSpec.describe'
    else
      let keyword = 'describe'
    endif
    let do_suffix = ' do'
  else
    " go back one line, to the last module
    normal! k
  endif

  if len(modules) < 2
    " nothing to join
    return 0
  endif

  " go to the end of the deepest-nested module/class/do:
  call search('^\s*\zs\%(module\|class\|\<do$\)', 'Wbc', line('.'))
  normal %
  let content_end_line = line('.') - 1
  " delete the right amount of ends and go back
  let range = (content_end_line + 1).','.(content_end_line + (len(modules) - 1))
  silent exe range.'delete _'
  exe module_end_line

  if module_end_line + 1 <= content_end_line
    " there's content in the class/module, so shift its indentation
    let range = (module_end_line + 1).','.content_end_line
    silent exe range.repeat('<', len(modules) - 1)
  endif

  " replace the module line
  call sj#ReplaceLines(module_start_line, module_end_line, keyword.' '.join(modules, '::').do_suffix)
  return 1
endfunction

function! sj#ruby#SplitModuleNamespace()
  let namespace_pattern = '^\s*\%(module\|class\|\%\(RSpec\.\)\=describe\)\s\+[A-Z]\k*::'

  if search(namespace_pattern, 'Wbc', line('.')) <= 0
    return 0
  endif

  let start_line = line('.')

  " is it a class, module, or RSpec/describe?
  let keyword = expand('<cword>')
  if keyword == 'RSpec'
    let keyword = 'RSpec.describe'
  endif
  let do_suffix = ''
  if keyword =~ 'describe$'
    let do_suffix = ' do'
  endif

  " get the module path
  if search('\V'.keyword.'\m\s\+\zs[A-Z]\k*', 'W', line('.')) <= 0
    return 0
  endif
  let module_path = expand('<cWORD>')
  if search('\s\+<\s\+\S\+$', 'W', line('.')) > 0
    let parent = sj#GetMotion('vg_')
  else
    let parent = ''
  endif
  let modules = split(module_path, '::')

  if len(modules) < 2
    " nothing to split
    return 0
  endif

  " build up new lines
  let lines = []
  for module in modules[:-2]
    call add(lines, 'module '.module)
  endfor
  call add(lines, keyword.' '.modules[-1].parent.do_suffix)

  " shift contents of the class/module
  if search('^\s*\zs\%(module\|class\|\%(RSpec\.\)\=describe.*do$\)', 'Wbc', line('.')) <= 0
    return 0
  endif
  normal %
  let end_line = line('.') - 1
  if end_line - start_line > 0
    let range = start_line.','.end_line
    silent exe range.repeat('>', len(modules) - 1)
  endif

  " replace the module line
  exe start_line
  call sj#ReplaceMotion('V', join(lines, "\n"))

  " add the necessary amount of "end"s
  exe (end_line + len(lines))
  let ends = split(repeat("end\n", len(modules)), "\n")
  call sj#ReplaceMotion('V', join(ends, "\n"))

  return 1
endfunction

function! sj#ruby#SplitEndlessDef()
  " taken from vim-ruby
  let endless_def_pattern = '\<def\s\+\%(\k\+\.\)\=\k\+[!?]\=\%((.*)\|\s\)\zs\s*\zs='
  if search(endless_def_pattern, 'Wce', line('.')) <= 0
        \ && search(endless_def_pattern, 'Wcbe', line('.')) <= 0
    return 0
  endif

  let line             = getline('.')
  let equal_sign_index = col('.') - 1
  let definition       = sj#Rtrim(strpart(line, 0, equal_sign_index))
  let body             = sj#Ltrim(strpart(line, equal_sign_index + 1))

  call sj#ReplaceLines(line('.'), line('.'), definition."\n".body."\nend")
  return 1
endfunction

function! sj#ruby#JoinOnelineDef()
  " adapted from vim-ruby
  if search('\<def\s\+\%(\k\+\.\)\=\k\+[!?]\=\%((.*)\)\s*\%(#.*\)\=$', 'Wbc', line('.')) <= 0
    return 0
  endif

  let def_line_no = line('.')
  normal %
  let end_line_no = line('.')

  if def_line_no == end_line_no
        \ || getline(end_line_no) !~ '\<end\>'
    " then the cursor hasn't moved
    return 0
  endif

  if end_line_no - def_line_no != 2
    " then it's not a one-line method
    return 0
  endif

  let [result, offset] = s:HandleComments(def_line_no, end_line_no)
  if !result
    return 1
  endif
  let def_line_no += offset
  let end_line_no += offset

  let lines = sj#GetLines(def_line_no, end_line_no)

  let def_line = lines[0]
  let end_line = lines[-1]
  let body     = join(lines[1:-2], "\n")

  let def_line = sj#Trim(def_line)
  let body     = sj#Trim(body)

  let replacement = def_line.' = '.body

  call sj#ReplaceLines(def_line_no, end_line_no, replacement)
  return 1
endfunction

" Helper functions

function! s:JoinHashWithCurlyBraces()
  normal! $

  let original_body = sj#GetMotion('Vi{')
  let body = original_body

  if sj#settings#Read('normalize_whitespace')
    let body = substitute(body, '\s\+=>\s\+', ' => ', 'g')
    let body = substitute(body, '\s\+\k\+\zs:\s\+', ': ', 'g')
  endif

  " remove trailing comma
  let body = substitute(body, ',\ze\_s*$', '', '')

  let body = join(sj#TrimList(split(body, "\n")), ' ')
  if sj#settings#Read('curly_brace_padding')
    let body = '{ '.body.' }'
  else
    let body = '{'.body.'}'
  endif

  call sj#ReplaceMotion('va{', body)
  return 1
endfunction

function! s:JoinHashWithRoundBraces()
  normal! $

  let body = sj#GetMotion('Vi(',)
  if sj#settings#Read('normalize_whitespace')
    let body = substitute(body, '\s*=>\s*', ' => ', 'g')
    let body = substitute(body, '\s\+\k\+\zs:\s\+', ': ', 'g')
  endif

  " remove trailing comma
  let body = substitute(body, ',\ze\_s*$', '', '')

  let body = join(sj#TrimList(split(body, "\n")), ' ')
  call sj#ReplaceMotion('Va(', '('.body.')')

  return 1
endfunction

function! s:JoinHashWithoutBraces()
  let start_lineno = line('.')
  let end_lineno   = start_lineno
  let lineno       = nextnonblank(start_lineno + 1)
  let line         = getline(lineno)
  let indent       = repeat(' ', indent(lineno))

  while lineno <= line('$') &&
        \ ((line =~ '^'.indent && (line =~ '=>' || line =~ '^\s*\k\+:')) || line =~ '^\s*)')
    let end_lineno = lineno
    let lineno     = nextnonblank(lineno + 1)
    let line       = getline(lineno)
  endwhile

  call cursor(start_lineno, 0)
  exe "normal! V".(end_lineno - start_lineno)."jJ"
  return 1
endfunction

function! s:HandleComments(start_line_no, end_line_no)
  let start_line_no = a:start_line_no
  let end_line_no   = a:end_line_no

  let [success, failure] = [1, 0]
  let offset = 0

  let comments = s:FindComments(start_line_no, end_line_no)

  if len(comments) > 1
    echomsg "Splitjoin: Can't join this due to the inline comments. Please remove them first."
    return [failure, 0]
  endif

  if len(comments) == 1
    let [start_line_no, end_line_no] = s:MigrateComments(comments, a:start_line_no, a:end_line_no)
    let offset = start_line_no - a:start_line_no
  else
    let offset = 0
  endif

  return [success, offset]
endfunction

function! s:FindComments(start_line_no, end_line_no)
  call sj#PushCursor()

  let comments = []

  for lineno in range(a:start_line_no, a:end_line_no)
    exe lineno
    normal! 0

    while search('#', 'Wc', lineno) > 0
      let col = col('.')

      if synIDattr(synID(lineno, col, 1), "name") == 'rubyComment'
        let comment = sj#GetCols(col, col('$'))
        call add(comments, [lineno, col, comment])
        break
      else
        normal! l
      endif
    endwhile
  endfor

  call sj#PopCursor()

  return comments
endfunction

function! s:MigrateComments(comments, start_line_no, end_line_no)
  call sj#PushCursor()

  let start_line_no = a:start_line_no
  let end_line_no   = a:end_line_no

  for [line, col, _c] in a:comments
    call cursor(line, col)
    normal! "_D
  endfor

  for [_l, _c, comment] in a:comments
    call append(start_line_no - 1, comment)

    exe start_line_no
    normal! ==

    let start_line_no = start_line_no + 1
    let end_line_no   = end_line_no + 1
  endfor

  call sj#PopCursor()

  return [start_line_no, end_line_no]
endfunction

function! s:ArrayLiteralClosingBracket(opening_bracket)
  let opening_bracket = a:opening_bracket

  if opening_bracket == '{'
    let closing_bracket = '}'
  elseif opening_bracket == '('
    let closing_bracket = ')'
  elseif opening_bracket == '<'
    let closing_bracket = '>'
  elseif opening_bracket == '['
    let closing_bracket = ']'
  else
    let closing_bracket = opening_bracket
  endif

  return closing_bracket
endfunction
