" Based on @kamichidu code

"
" public api
"
function! dein#toml#parse(text) abort
  let input = {
  \   'text': a:text,
  \   'p': 0,
  \   'length': strlen(a:text),
  \}
  return s:_parse(input)
endfunction

function! dein#toml#parse_file(filename) abort
  if !filereadable(a:filename)
    throw printf("Text.TOML: No such file `%s'.", a:filename)
  endif

  let text = join(readfile(a:filename), "\n")
  " fileencoding is always utf8
  return dein#toml#parse(iconv(text, 'utf8', &encoding))
endfunction

"
" private api
"
" work around: '[^\r\n]*' doesn't work well in old-vim, but "[^\r\n]*" works well
let s:skip_pattern = '\C^\%(\_s\+\|' . "#[^\r\n]*" . '\)'
let s:table_name_pattern = '\%([^ [:tab:]#.[\]=]\+\)'
let s:table_key_pattern = s:table_name_pattern

function! s:_skip(input) abort
  while s:_match(a:input, '\%(\_s\|#\)')
    let a:input.p = matchend(a:input.text, s:skip_pattern, a:input.p)
  endwhile
endfunction

" XXX: old engine is faster than NFA engine (in this context).
if exists('+regexpengine')
  let s:regex_prefix = '\%#=1\C^'
else
  let s:regex_prefix = '\C^'
endif

function! s:_consume(input, pattern) abort
  call s:_skip(a:input)
  let end = matchend(a:input.text, s:regex_prefix . a:pattern, a:input.p)

  if end == -1
    call s:_error(a:input)
  elseif end == a:input.p
    return ''
  endif

  let matched = strpart(a:input.text, a:input.p, end - a:input.p)
  let a:input.p = end
  return matched
endfunction

function! s:_match(input, pattern) abort
  return match(a:input.text, s:regex_prefix . a:pattern, a:input.p) != -1
endfunction

function! s:_eof(input) abort
  return a:input.p >= a:input.length
endfunction

function! s:_error(input) abort
  let buf = []
  let offset = 0
  while (a:input.p + offset) < a:input.length && a:input.text[a:input.p + offset] !~# "[\r\n]"
    let buf += [a:input.text[a:input.p + offset]]
    let offset += 1
  endwhile

  throw printf("Text.TOML: Illegal toml format at L%d:`%s':%d.",
      \ len(split(a:input.text[: a:input.p], "\n", 1)),
      \ join(buf, ''), a:input.p)
endfunction

function! s:_parse(input) abort
  let data = {}

  call s:_skip(a:input)
  while !s:_eof(a:input)
    if s:_match(a:input, '[^ [:tab:]#.[\]]')
      let key = s:_key(a:input)
      call s:_equals(a:input)
      let value = s:_value(a:input)

      call s:_put_dict(data, key, value)

      unlet value
    elseif s:_match(a:input, '\[\[')
      let [key, value] = s:_array_of_tables(a:input)

      call s:_put_array(data, key, value)

      unlet value
    elseif s:_match(a:input, '\[')
      let [key, value] = s:_table(a:input)

      call s:_put_dict(data, key, value)

      unlet value
    else
      call s:_error(a:input)
    endif
    call s:_skip(a:input)
  endwhile

  return data
endfunction

function! s:_key(input) abort
  let s = s:_consume(a:input, s:table_key_pattern)
  return s
endfunction

function! s:_equals(input) abort
  call s:_consume(a:input, '=')
  return '='
endfunction

function! s:_value(input) abort
  call s:_skip(a:input)

  if s:_match(a:input, '"\{3}')
    return s:_multiline_basic_string(a:input)
  elseif s:_match(a:input, '"\{1}')
    return s:_basic_string(a:input)
  elseif s:_match(a:input, "'\\{3}")
    return s:_multiline_literal(a:input)
  elseif s:_match(a:input, "'\\{1}")
    return s:_literal(a:input)
  elseif s:_match(a:input, '\[')
    return s:_array(a:input)
  elseif s:_match(a:input, '\%(true\|false\)')
    return s:_boolean(a:input)
  elseif s:_match(a:input, '\d\{4}-')
    return s:_datetime(a:input)
  elseif s:_match(a:input, '[+-]\?\%(\d\+\.\d\|\d\+\%(\.\d\+\)\?[eE]\)')
    return s:_float(a:input)
  elseif s:_match(a:input, '{')
    return s:_inline_table(a:input)
  else
    return s:_integer(a:input)
  endif
endfunction

"
" String
"
function! s:_basic_string(input) abort
  let s = s:_consume(a:input, '"\%(\\"\|[^"]\)*"')
  let s = s[1 : -2]
  return s:_unescape(s)
endfunction

function! s:_multiline_basic_string(input) abort
  let s = s:_consume(a:input, '"\{3}\_.\{-}"\{3}')
  let s = s[3 : -4]
  let s = substitute(s, "^\n", '', '')
  let s = substitute(s, '\\' . "\n" . '\_s*', '', 'g')
  return s:_unescape(s)
endfunction

function! s:_literal(input) abort
  let s = s:_consume(a:input, "'[^']*'")
  return s[1 : -2]
endfunction

function! s:_multiline_literal(input) abort
  let s = s:_consume(a:input, "'\\{3}.\\{-}'\\{3}")
  let s = s[3 : -4]
  let s = substitute(s, "^\n", '', '')
  return s
endfunction

"
" Integer
"
function! s:_integer(input) abort
  let s = s:_consume(a:input, '[+-]\?\d\+')
  return str2nr(s)
endfunction

"
" Float
"
function! s:_float(input) abort
  if s:_match(a:input, '[+-]\?[0-9.]\+[eE][+-]\?\d\+')
    return s:_exponent(a:input)
  else
    return s:_fractional(a:input)
  endif
endfunction

function! s:_fractional(input) abort
  let s = s:_consume(a:input, '[+-]\?[0-9.]\+')
  return str2float(s)
endfunction

function! s:_exponent(input) abort
  let s = s:_consume(a:input, '[+-]\?[0-9.]\+[eE][+-]\?\d\+')
  return str2float(s)
endfunction

"
" Boolean
"
function! s:_boolean(input) abort
  let s = s:_consume(a:input, '\%(true\|false\)')
  return (s ==# 'true') ? 1 : 0
endfunction

"
" Datetime
"
function! s:_datetime(input) abort
  let s = s:_consume(a:input, '\d\{4}-\d\{2}-\d\{2}T\d\{2}:\d\{2}:\d\{2}\%(Z\|-\?\d\{2}:\d\{2}\|\.\d\+-\d\{2}:\d\{2}\)')
  return s
endfunction

"
" Array
"
function! s:_array(input) abort
  let ary = []
  let _ = s:_consume(a:input, '\[')
  call s:_skip(a:input)
  while !s:_eof(a:input) && !s:_match(a:input, '\]')
    let ary += [s:_value(a:input)]
    call s:_consume(a:input, ',\?')
    call s:_skip(a:input)
  endwhile
  let _ = s:_consume(a:input, '\]')
  return ary
endfunction

"
" Table
"
function! s:_table(input) abort
  let tbl = {}
  let name = s:_consume(a:input, '\[\s*' . s:table_name_pattern . '\%(\s*\.\s*' . s:table_name_pattern . '\)*\s*\]')
  let name = name[1 : -2]
  call s:_skip(a:input)
  " while !s:_eof(a:input) && !s:_match(a:input, '\[\{1,2}[a-zA-Z0-9.]\+\]\{1,2}')
  while !s:_eof(a:input) && !s:_match(a:input, '\[')
    let key = s:_key(a:input)
    call s:_equals(a:input)
    let value = s:_value(a:input)

    let tbl[key] = value

    unlet value
    call s:_skip(a:input)
  endwhile
  return [name, tbl]
endfunction

"
" Inline Table
"
function! s:_inline_table(input) abort
  let tbl = {}
  let _ = s:_consume(a:input, '{')
  call s:_skip(a:input)
  while !s:_eof(a:input) && !s:_match(a:input, '}')
    let key = s:_key(a:input)
    call s:_equals(a:input)
    let tbl[key] = s:_value(a:input)
    call s:_consume(a:input, ',\?')
    call s:_skip(a:input)
  endwhile
  let _ = s:_consume(a:input, '}')
  return tbl
endfunction

"
" Array of tables
"
function! s:_array_of_tables(input) abort
  let tbl = {}
  let name = s:_consume(a:input, '\[\[\s*' . s:table_name_pattern . '\%(\s*\.\s*' . s:table_name_pattern . '\)*\s*\]\]')
  let name = name[2 : -3]
  call s:_skip(a:input)
  " while !s:_eof(a:input) && !s:_match(a:input, '\[\{1,2}[a-zA-Z0-9.]\+\]\{1,2}')
  while !s:_eof(a:input) && !s:_match(a:input, '\[')
    let key = s:_key(a:input)
    call s:_equals(a:input)
    let value = s:_value(a:input)

    let tbl[key] = value

    unlet value
    call s:_skip(a:input)
  endwhile
  return [name, [tbl]]
endfunction

function! s:_unescape(text) abort
  let text = a:text
  let text = substitute(text, '\\"', '"', 'g')
  let text = substitute(text, '\\b', "\b", 'g')
  let text = substitute(text, '\\t', "\t", 'g')
  let text = substitute(text, '\\n', "\n", 'g')
  let text = substitute(text, '\\f', "\f", 'g')
  let text = substitute(text, '\\r', "\r", 'g')
  let text = substitute(text, '\\/', '/', 'g')
  let text = substitute(text, '\\\\', '\', 'g')
  let text = substitute(text, '\C\\u\(\x\{4}\)', '\=s:_nr2char("0x" . submatch(1))', 'g')
  let text = substitute(text, '\C\\U\(\x\{8}\)', '\=s:_nr2char("0x" . submatch(1))', 'g')
  return text
endfunction

function! s:_nr2char(nr) abort
  return iconv(nr2char(a:nr), &encoding, 'utf8')
endfunction

function! s:_put_dict(dict, key, value) abort
  let keys = split(a:key, '\.')

  let ref = a:dict
  for key in keys[ : -2]
    if has_key(ref, key) && type(ref[key]) == v:t_dict
      let ref = ref[key]
    elseif has_key(ref, key) && type(ref[key]) == v:t_list
      let ref = ref[key][-1]
    else
      let ref[key] = {}
      let ref = ref[key]
    endif
  endfor

  let ref[keys[-1]] = a:value
endfunction

function! s:_put_array(dict, key, value) abort
  let keys = split(a:key, '\.')

  let ref = a:dict
  for key in keys[ : -2]
    let ref[key] = get(ref, key, {})

    if type(ref[key]) == v:t_list
      let ref = ref[key][-1]
    else
      let ref = ref[key]
    endif
  endfor

  let ref[keys[-1]] = get(ref, keys[-1], []) + a:value
endfunction

" vim:set et ts=2 sts=2 sw=2 tw=0:
