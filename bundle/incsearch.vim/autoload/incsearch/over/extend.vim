"=============================================================================
" FILE: autoload/incsearch/over/extend.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:TRUE = !0
let s:FALSE = 0
let s:non_escaped_backslash = '\m\%(\%(^\|[^\\]\)\%(\\\\\)*\)\@<=\\'

let s:U = incsearch#util#import()

function! incsearch#over#extend#enrich(cli) abort
  return extend(a:cli, s:cli)
endfunction

let s:cli = {
\   '_does_exit_from_incsearch': s:FALSE,
\   '_return_cmd': '',
\   '_converter_cache': {}
\ }

function! s:cli._generate_command(input) abort
  let is_cancel = self.exit_code()
  if is_cancel
    return s:U.is_visual(self._mode) ? '\<ESC>gv' : "\<ESC>"
  else
    call self._call_execute_event()
    let [pattern, offset] = incsearch#parse_pattern(a:input, self._base_key)
    " TODO: implement convert input method
    let p = self._combine_pattern(self._convert(pattern), offset)
    return self._build_search_cmd(p)
  endif
endfunction

" @return search cmd
function! s:cli._build_search_cmd(pattern, ...) abort
  let mode = get(a:, 1, self._mode)
  let op = (mode ==# 'no')      ? v:operator
  \      : s:U.is_visual(mode) ? 'gv'
  \      : ''
  let zv = (&foldopen =~# '\vsearch|all' && mode !=# 'no' ? 'zv' : '')
  " NOTE:
  "   Should I consider o_v, o_V, and o_CTRL-V cases and do not
  "   <Esc>? <Esc> exists for flexible v:count with using s:cli._vcount1,
  "   but, if you do not move the cursor while incremental searching,
  "   there are no need to use <Esc>.
  let esc = self._has_count ? "\<Esc>" : ''
  let register = esc is# '' ? '' : '"' . v:register
  let cnt = self._vcount1 is# 1 ? '' : self._vcount1
  let prefix = esc .  register . (esc is# '' ? '' : op) . cnt
  return printf("%s%s%s\<CR>%s", prefix, self._base_key, a:pattern, zv)
endfunction

"" Call on_execute_pre and on_execute event
" assume current position is the destination and a:cli._w is the position to
" start search
function! s:cli._call_execute_event(...) abort
  let view = get(a:, 1, winsaveview())
  try
    call winrestview(self._w)
    call self.callevent('on_execute_pre')
  finally
    call winrestview(view)
  endtry
  call self.callevent('on_execute')
endfunction

function! s:cli._parse_pattern() abort
  if v:version == 704 && !has('patch421')
    " Ignore \ze* which clash vim 7.4 without 421 patch
    " Assume `\m`
    let [p, o] = incsearch#parse_pattern(self.getline(), self._base_key)
    let p = (p =~# s:non_escaped_backslash . 'z[se]\%(\*\|\\+\)' ? '' : p)
    return [p, o]
  else
    return incsearch#parse_pattern(self.getline(), self._base_key)
  endif
endfunction

function! s:cli._combine_pattern(pattern, offset) abort
  return empty(a:offset) ? a:pattern : a:pattern . self._base_key . a:offset
endfunction

function! s:cli._convert(pattern) abort
  if a:pattern is# ''
    return a:pattern
  elseif empty(self._converters)
    return incsearch#magic() . a:pattern
  elseif has_key(self._converter_cache, a:pattern)
    return self._converter_cache[a:pattern]
  else
    let ps = [incsearch#magic() . a:pattern]
    for l:Converter in self._converters
      let l:Convert = type(l:Converter) is type(function('function'))
      \ ? l:Converter : l:Converter.convert
      let ps += [l:Convert(a:pattern)]
      unlet l:Converter
    endfor
    " Converters may return upper case even if a:pattern doesn't contain upper
    " case letter, so prepend case flag explicitly
    " let case = incsearch#detect_case(a:pattern)
    let case = incsearch#detect_case(a:pattern)
    let self._converter_cache[a:pattern] =  case . s:U.regexp_join(ps)
    return self._converter_cache[a:pattern]
  endif
endfunction

function! s:cli._exit_incsearch(...) abort
  let cmd = get(a:, 1, '')
  let self._return_cmd = cmd
  let self._does_exit_from_incsearch = s:TRUE
  call self.exit()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
