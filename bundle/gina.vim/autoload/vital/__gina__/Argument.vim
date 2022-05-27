let s:t_number = type(0)
let s:t_string = type('')

function! s:_vital_loaded(V) abort
  let s:Guard = a:V.import('Vim.Guard')
  let s:List = a:V.import('Data.List')
  let s:String = a:V.import('Data.String')
endfunction

function! s:_vital_depends() abort
  return ['Vim.Guard', 'Data.List', 'Data.String']
endfunction

function! s:_vital_created(module) abort
  " build pattern for parsing arguments
  let single_quote = '''\zs[^'']\+\ze'''
  let double_quote = '"\zs[^"]\+\ze"'
  let bare_strings = '\%(\\\s\|[^ ''"]\)\+'
  let s:PARSE_PATTERN = printf(
        \ '\%%(%s\)*\zs\%%(\s\+\|$\)\ze',
        \ join([single_quote, double_quote, bare_strings], '\|')
        \)
  let s:NORM_PATTERN = '^\%("\zs.*\ze"\|''\zs.*\ze''\|.*\)$'
endfunction

function! s:parse(cmdline) abort
  return s:norm(split(a:cmdline, s:PARSE_PATTERN))
endfunction

function! s:norm(terms) abort
  return map(copy(a:terms), 's:_norm_term(v:val)')
endfunction

function! s:new(...) abort
  if a:0 > 0
    let init = type(a:1) == s:t_string ? s:parse(a:1) : s:norm(a:1)
  else
    let init = []
  endif
  let args = copy(s:args)
  let args.raw = init
  return args
endfunction


" Private --------------------------------------------------------------------
function! s:_norm_term(term) abort
  let m = matchlist(a:term, '^\(-\w\|--\S\+=\)\(.\+\)')
  if empty(m)
    return matchstr(a:term, s:NORM_PATTERN)
  endif
  return m[1] . matchstr(m[2], s:NORM_PATTERN)
endfunction

function! s:_parse_term(term) abort
  let m = matchlist(a:term, '^\(-\w\|--\S\+=\)\(.\+\)')
  if empty(m)
    return a:term =~# '^--\?\S\+' ? [a:term, 1] : ['', a:term]
  else
    return [substitute(m[1], '=$', '', ''), m[2]]
  endif
endfunction

function! s:_build_term(key, value) abort
  if type(a:value) == s:t_number
    return a:value == 0 ? '' : a:key
  elseif empty(a:key) || a:key =~# '^-\w$'
    return a:key . a:value
  else
    return a:key . '=' . a:value
  endif
endfunction

function! s:_build_pattern(query) abort
  let patterns = split(a:query, '|')
  call map(patterns, 's:String.escape_pattern(v:val)')
  call map(patterns, 'v:val =~# ''^--\S\+'' ? v:val . ''\%(=\|$\)'' : v:val')
  return printf('^\%%(%s\)', join(patterns, '\|'))
endfunction

function! s:_is_query(query) abort
  return a:query =~# '^--\?\S\+\%(|--\?\S\+\)*$'
endfunction


" Instance -------------------------------------------------------------------
let s:args = {}

function! s:_index(pattern) abort dict
  let guard = s:Guard.store(['&l:iskeyword'])
  try
    setlocal iskeyword&
    let indices = range(0, len(self.raw)-1)
    for index in indices
      let term = self.raw[index]
      if term ==# '--'
        return -1
      elseif term =~# a:pattern
        return index
      endif
    endfor
    return -1
  finally
    call guard.restore()
  endtry
endfunction

function! s:_has(pattern) abort dict
  return call('s:_index', [a:pattern], self) != -1
endfunction

function! s:_get(pattern, default) abort dict
  let index = call('s:_index', [a:pattern], self)
  if index == -1
    return a:default
  endif
  return self.raw[index]
endfunction

function! s:_pop(pattern, default) abort dict
  let index = call('s:_index', [a:pattern], self)
  if index == -1
    return a:default
  endif
  return remove(self.raw, index)
endfunction

function! s:_set(pattern, term) abort dict
  let index = call('s:_index', [a:pattern], self)
  if index == -1
    let tail = index(self.raw, '--')
    let tail = tail == -1 ? len(self.raw) : tail
    call insert(self.raw, a:term, tail)
  else
    let self.raw[index] = a:term
  endif
  return self
endfunction

function! s:_index_o(query) abort dict
  return call('s:_index', [s:_build_pattern(a:query)], self)
endfunction

function! s:_has_o(query) abort dict
  return call('s:_has', [s:_build_pattern(a:query)], self)
endfunction

function! s:_get_o(query, default) abort dict
  let index = call('s:_index_o', [a:query], self)
  if index == -1
    return a:default
  endif
  return s:_parse_term(self.raw[index])[1]
endfunction

function! s:_pop_o(query, default) abort dict
  let index = call('s:_index_o', [a:query], self)
  if index == -1
    return a:default
  endif
  return s:_parse_term(remove(self.raw, index))[1]
endfunction

function! s:_set_o(query, value) abort dict
  let index = call('s:_index_o', [a:query], self)
  if index == -1
    let tail = index(self.raw, '--')
    let tail = tail == -1 ? len(self.raw) : tail
    let term = s:_build_term(split(a:query, '|')[-1], a:value)
    call insert(self.raw, term, tail)
  else
    let term = s:_build_term(s:_parse_term(self.raw[index])[0], a:value)
    let self.raw[index] = term
  endif
  return self
endfunction

function! s:_index_p(query) abort dict
  if a:query < 0
    throw 'vital: Argument: {query} (n-th) requires to be positive.'
  endif
  let indices = range(0, len(self.raw)-1)
  let pattern = '^--\?\w\+'
  let counter = 0
  for index in indices
    let term = self.raw[index]
    if term ==# '--'
      return -1
    elseif term !~# pattern
      let counter += 1
      if counter == a:query + 1
        return index
      endif
    endif
  endfor
  return -1
endfunction

function! s:_has_p(query) abort dict
  return call('s:_index_p', [a:query], self) != -1
endfunction

function! s:_get_p(query, ...) abort dict
  let default = get(a:000, 0, '')
  let index = call('s:_index_p', [a:query], self)
  if index == -1
    return default
  endif
  return self.raw[index]
endfunction

function! s:_pop_p(query, ...) abort dict
  let default = get(a:000, 0, '')
  let index = call('s:_index_p', [a:query], self)
  if index == -1
    return default
  endif
  return remove(self.raw, index)
endfunction

function! s:_set_p(query, value) abort dict
  let index = call('s:_index_p', [a:query], self)
  if index == -1
    let tail = index(self.raw, '--')
    let tail = tail == -1 ? len(self.raw) : tail
    let n = (a:query + 1) - len(filter(
          \ self.raw[:tail-1],
          \ 'v:val !~# ''^--\?\w\+'''
          \))
    call extend(self.raw, repeat([''], n), tail)
    let self.raw[tail - 1 + n] = a:value
  else
    let self.raw[index] = a:value
  endif
  let self.raw = s:List.flatten(self.raw)
  return self
endfunction

function! s:args.hash() abort
  return sha256(string(self.raw))
endfunction

function! s:args.lock() abort
  lockvar self
  return self
endfunction

function! s:args.clone() abort
  let args = deepcopy(self)
  lockvar 1 args
  return args
endfunction

function! s:args.index(query) abort
  return type(a:query) == s:t_string
        \ ? s:_is_query(a:query)
        \   ? call('s:_index_o', [a:query], self)
        \   : call('s:_index', [a:query], self)
        \ : call('s:_index_p', [a:query], self)
endfunction

function! s:args.has(query, ...) abort
  return type(a:query) == s:t_string
        \ ? s:_is_query(a:query)
        \   ? call('s:_has_o', [a:query], self)
        \   : call('s:_has', [a:query], self)
        \ : call('s:_has_p', [a:query], self)
endfunction

function! s:args.get(query, ...) abort
  return type(a:query) == s:t_string
        \ ? s:_is_query(a:query)
        \   ? call('s:_get_o', [a:query, get(a:000, 0, 0)], self)
        \   : call('s:_get', [a:query, get(a:000, 0, '')], self)
        \ : call('s:_get_p', [a:query, get(a:000, 0, '')], self)
endfunction

function! s:args.pop(query, ...) abort
  return type(a:query) == s:t_string
        \ ? s:_is_query(a:query)
        \   ? call('s:_pop_o', [a:query, get(a:000, 0, 0)], self)
        \   : call('s:_pop', [a:query, get(a:000, 0, '')], self)
        \ : call('s:_pop_p', [a:query, get(a:000, 0, '')], self)
endfunction

function! s:args.set(query, value) abort
  return type(a:query) == s:t_string
        \ ? s:_is_query(a:query)
        \   ? call('s:_set_o', [a:query, a:value], self)
        \   : call('s:_set', [a:query, a:value], self)
        \ : call('s:_set_p', [a:query, a:value], self)
endfunction

function! s:args.split() abort
  let tail = index(self.raw, '--')
  if tail == -1
    return [copy(self.raw), []]
  elseif tail == 0
    return [[], self.raw[1:]]
  else
    return [self.raw[:tail-1], self.raw[tail+1:]]
  endif
endfunction

function! s:args.effective(...) abort
  if a:0 == 0
    return self.split()[0]
  else
    let residual = self.residual()
    let self.raw = empty(residual) ? a:1 : a:1 + ['--'] + residual
    return self
  endif
endfunction

function! s:args.residual(...) abort
  if a:0 == 0
    return self.split()[1]
  else
    let effective = self.effective()
    let self.raw = effective + ['--'] + a:1
    return self
  endif
endfunction
