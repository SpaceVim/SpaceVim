"=============================================================================
" FILE: matcher_regexp.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#matcher_regexp#define() abort "{{{
  return s:matcher
endfunction"}}}

let s:matcher = {
      \ 'name' : 'matcher_regexp',
      \ 'description' : 'regular expression matcher',
      \}

function! s:matcher.pattern(input) abort "{{{
  return a:input
endfunction"}}}

function! s:matcher.filter(candidates, context) abort "{{{
  if a:context.input == ''
    return unite#filters#filter_matcher(
          \ a:candidates, '', a:context)
  endif

  let candidates = a:candidates
  for input in a:context.input_list
    if input == '!' || input == ''
      continue
    endif
    let a:context.input = input
    let candidates = unite#filters#matcher_regexp#regexp_matcher(
          \ candidates, input, a:context)
  endfor

  return candidates
endfunction"}}}

function! unite#filters#matcher_regexp#regexp_matcher(candidates, input, context) abort "{{{
  let expr = unite#filters#matcher_regexp#get_expr(a:input, a:context)

  try
    return unite#filters#filter_matcher(a:candidates, expr, a:context)
  catch
    return []
  endtry
endfunction"}}}
function! unite#filters#matcher_regexp#get_expr(input, context) abort "{{{
  let input = a:input

  if input =~ '^!'
    if input == '!'
      return '1'
    endif

    " Exclusion match.
    let expr = 'v:val.word !~ '.string(input[1:])
  elseif input =~ '^:'
    " Executes command.
    let a:context.execute_command = input[1:]
    return '1'
  elseif input !~ '[~\\.^$\[\]*]'
    if unite#util#has_lua()
      let expr = 'if_lua'
      let a:context.input_lua = input
    else
      " Optimized filter.
      let input = substitute(input, '\\\(.\)', '\1', 'g')
      let expr = &ignorecase ?
            \ printf('stridx(tolower(v:val.word), %s) != -1',
            \    string(tolower(input))) :
            \ printf('stridx(v:val.word, %s) != -1',
            \    string(input))
    endif
  else
    let expr = 'v:val.word =~ '.string(input)
  endif

  return expr
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
