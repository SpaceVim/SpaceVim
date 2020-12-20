"=============================================================================
" FILE: matcher_fuzzy.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#matcher_fuzzy#define() abort "{{{
  return s:matcher
endfunction"}}}

call unite#util#set_default('g:unite_matcher_fuzzy_max_input_length', 20)

let s:matcher = {
      \ 'name' : 'matcher_fuzzy',
      \ 'description' : 'fuzzy matcher',
      \}

function! s:matcher.pattern(input) abort "{{{
  let chars = map(split(a:input, '\zs'), "escape(v:val, '\\[]^$.*')")
  if empty(chars)
    return ''
  endif

  let pattern =
        \   substitute(join(map(chars[:-2], "
        \       printf('%s[^%s]\\{-}', v:val, v:val)
        \   "), '') . chars[-1], '\*\*', '*', 'g')
  return pattern
endfunction"}}}

function! s:matcher.filter(candidates, context) abort "{{{
  if a:context.input == ''
    return unite#filters#filter_matcher(
          \ a:candidates, '', a:context)
  endif

  if len(a:context.input) == 1
    " Fallback to glob matcher.
    return unite#filters#matcher_glob#define().filter(
          \ a:candidates, a:context)
  endif

  " Fix for numeric problem.
  let $LC_NUMERIC = 'en_US.utf8'

  let candidates = a:candidates
  for input in a:context.input_list
    if input == '!' || input == ''
      continue
    elseif input =~ '^:'
      " Executes command.
      let a:context.execute_command = input[1:]
      continue
    endif

    let pattern = s:matcher.pattern(input)

    let expr = (pattern =~ '^!') ?
          \ 'v:val.word !~ ' . string(pattern[1:]) :
          \ 'v:val.word =~ ' . string(pattern)
    if input !~ '^!' && unite#util#has_lua()
      let expr = 'if_lua_fuzzy'
      let a:context.input_lua = input
    endif

    let candidates = unite#filters#filter_matcher(
          \ a:candidates, expr, a:context)
  endfor

  return candidates
endfunction"}}}

function! unite#filters#matcher_fuzzy#get_fuzzy_input(input) abort "{{{
  let input = a:input
  let head = ''
  if len(input) > g:unite_matcher_fuzzy_max_input_length
    let pos = strridx(input, '/')
    if pos > 0
      let head = input[: pos-1]
      let input = input[pos :]
    endif
    if len(input) > g:unite_matcher_fuzzy_max_input_length
      let head = input
      let input = ''
    endif
  endif

  return [head, input]
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
