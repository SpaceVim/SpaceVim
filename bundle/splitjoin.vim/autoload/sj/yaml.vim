" Array Callbacks:
" ================

function! sj#yaml#SplitArray()
  let [line, line_no, whitespace] = s:ReadCurrentLine()

  let prefix     = ''
  let array_part = ''
  let indent     = 1
  let end_offset = 0

  let nestedExp = '\v^\s*((-\s+)+)(\[.*\])$'
  let line = s:StripComment(line)

  " Split arrays which are map properties
  " E.g.
  "   prop: [1, 2]
  if line =~ ':\s*\[.*\]$'
    let [key, array_part] = s:SplitKeyValue(line)
    let prefix            = key . ":\n"

  " Split nested arrays
  " E.g.
  "   - [1, 2]
  elseif line =~ nestedExp
    let prefix     = substitute(line, nestedExp, '\1', '')
    let array_part = substitute(line, nestedExp, '\3', '')
    let indent     = len(substitute(line, '\v[^-]', '', 'g'))
    let end_offset = -1
  endif

  if array_part != ''
    let body        = substitute(array_part, '\v^\s*\[(.*)\]\s*$', '\1', '')
    let array_items = s:SplitArrayBody(body)

    call sj#ReplaceMotion('V', prefix . '- ' . join(array_items, "\n- "))
    silent! normal! zO
    call s:SetIndentWhitespace(line_no, whitespace)
    call s:IncreaseIndentWhitespace(line_no + 1, line_no + len(array_items) + end_offset, whitespace, indent)

    return 1
  endif

  return 0
endfunction

function! sj#yaml#JoinArray()
  let [line, line_no, whitespace] = s:ReadCurrentLine()

  let lines       = []
  let first_line  = s:StripComment(line)

  let nestedExp = '\v^(\s*(-\s+)+)(-\s+.*)$'
  let join_type = ''

  " Nested arrays
  " E.g.
  "   - - 'one'
  "     - 'two'
  if first_line =~ nestedExp && s:IsValidLineNo(line_no)
    let join_type = 'nested'
    let [lines, last_line_no] = s:GetChildren(line_no)
    let lines = map(lines, 's:StripComment(v:val)')
    let lines = [substitute(first_line, nestedExp, '\3', '')] + lines
    let first_line = sj#Rtrim(substitute(first_line, nestedExp, '\1', ''))

  " Normal arrays
  " E.g.
  "  list:
  "    - 'one'
  "    - 'two'
  elseif first_line =~ ':$' && s:IsValidLineNo(line_no + 1)
    let join_type = 'normal'
    let [lines, last_line_no] = s:GetChildren(line_no)
    let lines = map(lines, 's:StripComment(v:val)')
  endif

  if !empty(lines)
    if join_type == 'nested'
      let body_lines = lines[1:len(lines)]
    else
      let body_lines = lines
    endif

    for line in body_lines
      if line !~ '^\s*$' && line !~ '^\s*-'
        " one non-blank line is not part of the array, it must be a nested
        " construct, can't handle that
        return 0
      endif

      if line =~ nestedExp
        " can't handle nested subexpressions
        return 0
      endif
    endfor

    let lines       = map(lines, 'sj#Trim(substitute(v:val, "^\\s*-", "", ""))')
    let lines       = filter(lines, '!sj#BlankString(v:val)')
    let replacement = first_line . ' [' . s:JoinArrayItems(lines) . ']'

    call sj#ReplaceLines(line_no, last_line_no, replacement)
    silent! normal! zO
    call s:SetIndentWhitespace(line_no, whitespace)

    return 1
  endif

  " then there's nothing to join
  return 0
endfunction

" Map Callbacks:
" ================

function! sj#yaml#SplitMap()
  let [from, to] = sj#LocateBracesOnLine('{', '}')

  if from >= 0 && to >= 0
    let [line, line_no, whitespace] = s:ReadCurrentLine()
    let line  = s:StripComment(line)
    let pairs = sj#ParseJsonObjectBody(from + 1, to - 1)
    let body  = join(pairs, "\n")
    let body_start = line_no

    let indent_level = 0
    let end_offset   = -1

    " Increase indention if the map is inside a nested array.
    " E.g.
    "   - - { one: 1 }
    if line =~ '^\s*-\s'
      let indent_level = s:NestedArrayLevel(line)
    endif

    " Move body into next line if it is a map property.
    " E.g.
    "   prop: { one: 1 }
    "   - prop: { one: 1 }
    if line =~ '^\v\s*(-\s+)*[^{]*:\s+\{.*'
      let body          = "\n" . body
      let indent_level += 1
      let end_offset    = 0
      let body_start    = line_no + 1
    endif

    call sj#ReplaceMotion('Va{', body)
    silent! normal! zO
    call s:SetIndentWhitespace(line_no, whitespace)
    call s:IncreaseIndentWhitespace(line_no + 1, line_no + len(pairs) + end_offset, whitespace, indent_level)
    call sj#Keeppatterns(line_no . 's/\s*$//e')

    if sj#settings#Read('align')
      let body_end = body_start + len(pairs) - 1
      call sj#Align(body_start, body_end, 'json_object')
    endif

    return 1
  endif

  return 0
endfunction

function! sj#yaml#JoinMap()
  let [line, line_no, whitespace] = s:ReadCurrentLine()

  if !s:IsValidLineNo(line_no + 1)
    return 0
  endif

  let first_line   = s:StripComment(line)
  let lines        = []
  let last_line_no = 0
  let join_type    = ''

  let nestedExp     = '\v^(\s*(-\s+)+)(.*)$'
  let nestedPropExp = '\v^(\s*(-\s+)+.+:)$'

  " Nested in a map inside an array.
  " E.g.
  "  - prop:
  "     one: 1
  if first_line =~ nestedPropExp
    let join_type = 'nested_in_map_in_array'
    let [lines, last_line_no] = s:GetChildren(line_no)
    let first_line = sj#Rtrim(substitute(first_line, nestedPropExp, '\1', ''))

  " Map inside an array.
  " E.g.
  "  - one: 1
  "    two: 2
  elseif first_line =~ nestedExp
    let join_type = 'nested_in_array'
    let [lines, last_line_no] = s:GetChildren(line_no)
    let lines = [substitute(first_line, nestedExp, '\3', '')] + lines
    let first_line = sj#Rtrim(substitute(first_line, nestedExp, '\1', ''))

    if len(lines) <= 1
      " only 1 line means nothing to join in this case
      return 0
    endif

  " Normal map
  " E.g.
  "   map:
  "     one: 1
  "     two: 2
  elseif first_line =~ '\k\+:\s*$'
    let join_type = 'normal'
    let [lines, last_line_no] = s:GetChildren(line_no)
  endif

  if len(lines) > 0
    if join_type == 'nested_in_array'
      let body_lines = lines[1:len(lines)]
    else
      let body_lines = lines
    endif

    if len(body_lines) > 0
      let base_indent = len(matchstr(body_lines[0], '^\s*'))
    endif

    for line in body_lines
      if line =~ '^\s*-'
        " one of the lines is a part of an array, we can't handle nested subexpressions
        return 0
      endif

      if len(matchstr(line, '^\s*')) != base_indent
        " a nested map, can't handle that
        return 0
      endif
    endfor

    let lines = sj#TrimList(lines)
    let lines = s:NormalizeWhitespace(lines)
    let lines = map(lines, 's:StripComment(v:val)')

    if sj#settings#Read('curly_brace_padding')
      let replacement = first_line . ' { '. join(lines, ', ') . ' }'
    else
      let replacement = first_line . ' {'. join(lines, ', ') . '}'
    endif

    call sj#ReplaceLines(line_no, last_line_no, replacement)
    silent! normal! zO
    call s:SetIndentWhitespace(line_no, whitespace)

    return 1
  endif

  return 0
endfunction

" Helper Functions:
" =================

" Reads line, line number and indention
function! s:ReadCurrentLine()
  let line_no    = line('.')
  let line       = getline(line_no)
  let whitespace = s:GetIndentWhitespace(line_no)

  return [line, line_no, whitespace]
endfunction

" Strip comments from string starting with a #
function! s:StripComment(s)
  return substitute(a:s, '\v\s+#.*$', '', '')
endfunction

" Check if current buffer has the line number
function! s:IsValidLineNo(no)
  return a:no >= 0  && a:no <= line('$')
endfunction

" Normalize whitespace, if enabled
function! s:NormalizeWhitespace(lines)
  if sj#settings#Read('normalize_whitespace')
    return map(a:lines, 'substitute(v:val, ":\\s\\+", ": ", "")')
  endif
  return a:lines
endfunction

function! s:GetIndentWhitespace(line_no)
  return substitute(getline(a:line_no), '^\(\s*\).*$', '\1', '')
endfunction

function! s:SetIndentWhitespace(line_no, whitespace)
  silent call sj#Keeppatterns(a:line_no . 's/^\s*/' . a:whitespace)
endfunction

function! s:IncreaseIndentWhitespace(from, to, whitespace, level)
  if a:whitespace =~ "\t"
    let new_whitespace = a:whitespace . repeat("\t", a:level)
  else
    let new_whitespace = a:whitespace . repeat(' ', &sw * a:level)
  endif

  for line_no in range(a:from, a:to)
    call s:SetIndentWhitespace(line_no, new_whitespace)
  endfor
endfunction

" Get following lines with a greater indent than the current line
function! s:GetChildren(line_no)
  let line_no      = a:line_no
  let next_line_no = line_no + 1
  let indent       = indent(line_no)
  let next_line    = getline(next_line_no)

  " Count '- ' as indent, if an object is in an array
  " E.g. (GetChildren for prop_a)
  "   list:
  "     - prop_a:
  "         - 1
  "       prop_b
  "         - 2
  let line = getline(line_no)
  if line =~ '^\s*\(\-\s\s*\)..*:$'
    let prefix = substitute(getline(a:line_no), '^\s*\(\-\s\s*\)..*:$', '\1', '')
    let indent += len(prefix)
  end

  while s:IsValidLineNo(next_line_no) &&
        \ (sj#BlankString(next_line) || indent(next_line_no) > indent)
    let next_line_no = next_line_no + 1
    let next_line    = getline(next_line_no)
  endwhile
  let next_line_no = next_line_no - 1

  " Preserve trailing empty lines
  while sj#BlankString(getline(next_line_no)) && next_line_no > line_no
    let next_line_no = next_line_no - 1
  endwhile

  return [sj#GetLines(line_no + 1, next_line_no), next_line_no]
endfunction

" Split a string into individual array items.
" E.g.
"   'one, two'               => ['one', 'two']
"   '{ one: 1 }, { two: 2 }' => ['{ one: 1 }', '{ two: 2 }']
function! s:SplitArrayBody(body)
  let items = []

  let partial_item = ''
  let rest = sj#Ltrim(a:body)

  while !empty(rest)
    let char = rest[0]

    if char == '{'
      let [item, rest] = s:ReadMap(rest)
      let rest = s:SkipWhitespaceUntilComma(rest)

      call add(items, s:StripCurlyBrackets(item))

    elseif char == '['
      let [item, rest] = s:ReadArray(rest)
      let rest = s:SkipWhitespaceUntilComma(rest)

      call add(items, sj#Trim(item))

    elseif char == '"' || char == "'"
      let [item, rest] = s:ReadString(rest)
      let rest = s:SkipWhitespaceUntilComma(rest)

      call add(items, sj#Trim(item))

    else
      let [item, rest] = s:ReadUntil(rest, ',')
      call add(items, sj#Trim(item))
    endif

    let rest = sj#Ltrim(rest[1:])
  endwhile

  return items
endfunction

" Read string until occurence of end_char
function! s:ReadUntil(str, end_char)
  let idx = 0
  while idx < len(a:str)
    if a:str[idx] == a:end_char
      return idx == 0
        \ ? ['', a:str[1:]]
        \ : [a:str[:idx-1], a:str[idx+1:]]
    endif

    let idx += 1
  endwhile

  return [a:str, '']
endfunction

" Read the next string fenced by " or '
function! s:ReadString(str)
  if len(a:str) > 0
    let fence = a:str[0]
    if fence == '"' || fence == "'"
      let [str, rest] = s:ReadUntil(a:str[1:], fence)
      return [fence . str . fence, rest]
    endif
  endif

  return ['', a:str]
endfunction

" Read the next array, including nested arrays.
" E.q.
"  '[[1, 2]], [1]' => ['[[1, 2]], ', [1]']
function! s:ReadArray(str)
  return s:ReadContainer(a:str, '[', ']')
endfunction

" Read the next map, including nested maps.
" E.q.
"  '{ one: 1, foo: { two: 2 } }, {}' => ['{ one: 1, foo: { two: 2 } }, ', {}']
function! s:ReadMap(str)
  return s:ReadContainer(a:str, '{', '}')
endfunction

function! s:ReadContainer(str, start_char, end_char)
  let content = ''
  let rest = a:str
  let depth = 0

  while !empty(rest)
    let char = rest[0]
    let rest = rest[1:]

    let content .= char

    if char == a:start_char
      let depth += 1
    elseif char == a:end_char
      let depth -= 1

      if depth == 0 | break | endif
    endif
  endwhile

  return [content, rest]
endfunction

" skip whitespace and next comma
function! s:SkipWhitespaceUntilComma(str)
  let [space, rest] = s:ReadUntil(a:str, ',')

  if !sj#BlankString(space)
    throw '"' . space . '" is not whitespace!'
  end
  return rest
endfunction

function! s:JoinArrayItems(items)
  return join(map(a:items, 's:AddCurlyBrackets(v:val)'), ', ')
endfunction

" Add curly brackets if required for joining
" E.g.
"   'one: 1' => '{ one: 1 }'
"   'one'    => 'one'
function! s:AddCurlyBrackets(line)
  let line = sj#Trim(a:line)

  if line !~ '^\v\[.*\]$' && line !~ '^\v\{.*\}$'
    let [key, value] = s:SplitKeyValue(line)
    if key != ''
      return '{ ' . a:line . ' }'
    endif
  endif

  return a:line
endfunction

" Strip curly brackets if possible
" E.g.
"   '{ one: 1 }'         => 'one: 1'
"   '{ one: 1, two: 2 }' => '{ one: 1, two: 2 }'
function! s:StripCurlyBrackets(item)
  let item = sj#Trim(a:item)

  if item =~ '^{.*}$'
    let parser = sj#argparser#js#Construct(2, len(item) - 1, item)
    call parser.Process()

    if len(parser.args) == 1
      let item = substitute(item, '^{\s*', '', '')
      let item = substitute(item, '\s*}$', '', '')
    endif
  endif

  return item
endfunction

" Split a string into key and value
" E.g.
"   'one: 1' => ['one', '1']
"   'one'    => ['', 'one']
"   'one:'   => ['one', '']
"   'a:val'  => ['', 'a:val']
function! s:SplitKeyValue(line)
  let line = sj#Trim(a:line)
  let parts = []

  let first_char = line[0]

  let key   = ''
  let value = ''

  " Read line starts with a fenced string. E.g
  "   'one': 1
  "   'one'
  if first_char == '"' || first_char == "'"
    let [key, rest] = s:ReadString(line)
    let [_, value]  = s:ReadUntil(rest, ':')
  else
    let parts = split(line . ' ', ': ')
    let [key, value] = [parts[0], join(parts[1:], ': ')]
  endif

  if value == '' && a:line !~ '\s*:$'
    let [key, value] = ['', key]
  endif

  return [sj#Trim(key), sj#Trim(value)]
endfunction

" Calculate the nesting level of an array item
" E.g.
"   - foo    => 1
"   - - bar  => 2
function! s:NestedArrayLevel(line)
  let prefix = substitute(a:line, '\v^\s*((-\s+)+).*', '\1', '')
  let levels = substitute(prefix, '[^-]', '', 'g')
  return len(levels)
endfunction
