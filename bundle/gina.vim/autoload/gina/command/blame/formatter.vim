let s:String = vital#gina#import('Data.String')
let s:Formatter = vital#gina#import('Data.String.Formatter')

let s:N_COLORS = 16
let s:FORMAT_MAP = {
      \ 'su': 'summary',
      \ 'au': 'author',
      \ 'ma': 'mark',
      \ 'in': 'index',
      \ 'ti': 'timestamp',
      \}


function! gina#command#blame#formatter#new(width, current, revisions, ...) abort
  let options = extend({
        \ 'format': v:null,
        \ 'separator': v:null,
        \ 'current_mark': v:null,
        \ 'timestamp_months': v:null,
        \ 'timestamp_format1': v:null,
        \ 'timestamp_format2': v:null,
        \}, get(a:000, 0, {})
        \)
  let formatter = deepcopy(s:formatter)
  let formatter._cache = {}
  let formatter._width = a:width
  let formatter._current = empty(a:current) ? 'X' : a:current
  let formatter._revisions = s:index_revisions(a:revisions)
  let formatter._previous = 1
  let formatter._timestamper = gina#core#timestamper#new({
        \ 'months': empty(options.timestamp_months)
        \   ? g:gina#command#blame#formatter#timestamp_months
        \   : options.timestamp_months,
        \ 'format1': empty(options.timestamp_format1)
        \   ? g:gina#command#blame#formatter#timestamp_format1
        \   : options.timestamp_format1,
        \ 'format2': empty(options.timestamp_format2)
        \   ? g:gina#command#blame#formatter#timestamp_format2
        \   : options.timestamp_format2,
        \})
  let formatter._current_mark = empty(options.current_mark)
        \ ? g:gina#command#blame#formatter#current_mark
        \ : options.current_mark
  let formatter._separator = empty(options.separator)
        \ ? g:gina#command#blame#formatter#separator
        \ : options.separator
  let formatter._format = empty(options.format)
        \ ? g:gina#command#blame#formatter#format
        \ : options.format
  return formatter
endfunction


" Private --------------------------------------------------------------------
function! s:index_revisions(revisions) abort
  let n = s:calc_nindicators(a:revisions)
  let revisions = deepcopy(a:revisions)
  let keys = keys(revisions)
  for index in range(len(revisions))
    let revisions[keys[index]].index = s:String.pad_left(
          \ s:String.nr2hex(index), n, '0'
          \)
  endfor
  return revisions
endfunction

function! s:calc_nindicators(revisions) abort
  let n = len(a:revisions)
  let x = 1
  while pow(s:N_COLORS, x) < n
    let x+= 1
  endwhile
  return x
endfunction


" Formatter ------------------------------------------------------------------
let s:formatter = {}

function! s:formatter.format(chunk) abort
  let revision = a:chunk.revision
  let revinfo = self._revisions[revision]
  let content = repeat(
        \ [self._format_line(a:chunk, revision, revinfo)],
        \ a:chunk.nlines,
        \)
  " Fill missing lines from previous
  let mlines = a:chunk.lnum - self._previous
  let self._previous = a:chunk.lnum + a:chunk.nlines
  return repeat([''], mlines) + content
endfunction

function! s:formatter._format_line(chunk, revision, revinfo) abort
  if has_key(self._cache, a:revision)
    return self._cache[a:revision]
  endif
  let precursor = s:Formatter.format(self._format, s:FORMAT_MAP, {
        \ 'summary': a:revinfo.summary,
        \ 'author': a:revinfo.author,
        \ 'index': a:revinfo.index,
        \ 'mark': a:revision =~# '^' . self._current
        \   ? self._current_mark
        \   : repeat(' ', len(self._current_mark)),
        \ 'timestamp': self._timestamper.format(
        \   a:revinfo.author_time,
        \   a:revinfo.author_tz
        \ ),
        \})
  let [head, tail] = split(precursor . '%=', '%=', 1)[0 : 1]
  let width = self._width - strwidth(tail) - 1
  let head = s:String.truncate_skipping(head, width, 3, self._separator)
  let head = s:String.pad_right(head, width)
  let self._cache[a:revision] = head . ' ' . tail
  return self._cache[a:revision]
endfunction



" Config ---------------------------------------------------------------------
call gina#config(expand('<sfile>'), {
      \ 'format': '%su%=on %ti %ma%in',
      \ 'separator': '...',
      \ 'current_mark': '|',
      \ 'timestamp_months': 3,
      \ 'timestamp_format1': '%d %b',
      \ 'timestamp_format2': '%d %b, %Y',
      \})
