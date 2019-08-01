"=============================================================================
" yaml.vim --- yaml api for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
let s:save_cpo = &cpo
set cpo&vim

let s:self = {}

function! s:self.parse(text) abort
  let input = {
  \   'text': a:text,
  \   'p': 0,
  \   'length': strlen(a:text),
  \}
  return self._parse(input)
endfunction

function! s:self.parse_file(filename) abort
  if !filereadable(a:filename)
    throw printf("yaml API: No such file `%s'.", a:filename)
  endif

  let text = join(readfile(a:filename), "\n")
  " fileencoding is always utf8
  return self.parse(iconv(text, 'utf8', &encoding))
endfunction

"
" private api
"
" work around: '[^\r\n]*' doesn't work well in old-vim, but "[^\r\n]*" works well
let s:skip_pattern = '\C^\%(\_s\+\|' . "#[^\r\n]*" . '\)'
let s:table_name_pattern = '\%([^ [:tab:]#.[\]=]\+\)'
let s:table_key_pattern = s:table_name_pattern

function! s:self._skip(input) abort
  while self._match(a:input, '\%(\_s\|#\)')
    let a:input.p = matchend(a:input.text, s:skip_pattern, a:input.p)
  endwhile
endfunction

" XXX: old engine is faster than NFA engine (in this context).
if exists('+regexpengine')
  let s:regex_prefix = '\%#=1\C^'
else
  let s:regex_prefix = '\C^'
endif

function! s:self._consume(input, pattern) abort
  call self._skip(a:input)
  let end = matchend(a:input.text, s:regex_prefix . a:pattern, a:input.p)

  if end == -1
    call self._error(a:input)
  elseif end == a:input.p
    return ''
  endif

  let matched = strpart(a:input.text, a:input.p, end - a:input.p)
  let a:input.p = end
  return matched
endfunction

function! s:self._match(input, pattern) abort
  return match(a:input.text, s:regex_prefix . a:pattern, a:input.p) != -1
endfunction

function! s:self._parser(input) abort
  let data = {}

  call self._skip(a:input)
  while !self._eof(a:input)
    if self._match(a:input, '[^ [:tab:]#.[\]]')
      let key = self._key(a:input)
      call self._equals(a:input)
      let value = self._value(a:input)

      call self._put_dict(data, key, value)

      unlet value
    elseif self._match(a:input, '\[\[')
      let [key, value] = self._array_of_tables(a:input)

      call self._put_array(data, key, value)

      unlet value
    elseif self._match(a:input, '\[')
      let [key, value] = self._table(a:input)

      call self._put_dict(data, key, value)

      unlet value
    else
      call self._error(a:input)
    endif
    call self._skip(a:input)
endfunction


function! SpaceVim#api#data#toml#get() abort
  return deepcopy(s:self)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0:
