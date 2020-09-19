" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:NONE = []
lockvar s:NONE

function! s:_vital_depends() abort
  return ['Web.URI']
endfunction

function! s:_vital_loaded(V) abort
  let s:URI = a:V.import('Web.URI')
endfunction


function! s:extract_from_text(text, ...) abort
  let options = a:0 && type(a:1) is# type({}) ? a:1 : {}
  let options = deepcopy(options)
  if !has_key(options, 'uri_pattern_set')
    let options.uri_pattern_set = s:URI.new_default_pattern_set()
  endif
  if !has_key(options, 'head_pattern')
    let options.head_pattern = 'https\?\|file\|' . options.uri_pattern_set.host()
  endif
  return s:_extract(a:text, options)
endfunction

" @return List of Dictionary.
"   Empty List means no URLs are found in a:text .
"   Here are the keys of Dictionary.
"     'obj' url
"     'startidx' start index
"     'endidx' end index ([startidex, endidx), half-open interval)
function! s:_extract(text, options) abort
  let pattern_set = a:options.uri_pattern_set
  let head_pattern = a:options.head_pattern
  let urls = []
  let start = 0
  let end = 0
  let len = strlen(a:text)
  while start <# len
    " Search scheme.
    let start = match(a:text, head_pattern, start)
    if start is# -1
      break
    endif
    let end = matchend(a:text, head_pattern, start)
    " Try to parse string as URI.
    let substr = a:text[start :]
    let results = s:URI.new_from_seq_string(substr, s:NONE, pattern_set)
    if results is# s:NONE || empty(results[0]) || results[0].scheme() is# ''
      " start is# end: matching string can be empty string.
      " e.g.: echo [match('abc', 'd*'), matchend('abc', 'd*')]
      let start = (start is# end ? end+1 : end)
      continue
    endif
    let [url, original_url] = results[0:1]
    let skip_num = len(original_url)
    let urls += [{
    \   'url': url,
    \   'startidx': start,
    \   'endidx': start + skip_num,
    \}]
    let start += skip_num
  endwhile
  return urls
endfunction


let &cpo = s:save_cpo
