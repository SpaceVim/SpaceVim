"=============================================================================
" FILE: matcher_migemo.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#matcher_migemo#define() abort "{{{
  if !has('migemo') && !executable('cmigemo')
    " Not supported.
    return {}
  endif

  let s:migemodict = s:search_dict()
  if has('migemo') && (&migemodict == '' || !filereadable(&migemodict))
    let &migemodict = s:migemodict
  endif
  if s:migemodict == ''
    " Dictionary not found.
    return {}
  endif

  return s:matcher
endfunction"}}}

function! s:search_dict() abort
  let dict = s:search_dict2('cmigemo/'.&encoding.'/migemo-dict')
  if dict == ''
    let dict = s:search_dict2('migemo/'.&encoding.'/migemo-dict')
  endif
  if dict == ''
    let dict = s:search_dict2(&encoding.'/migemo-dict')
  endif
  if dict == ''
    let dict = s:search_dict2('migemo-dict')
  endif

  return dict
endfunction

function! s:search_dict2(name) abort
  let path = $VIM . ',' . &runtimepath
  let dict = globpath(path, 'dict/'.a:name)
  if dict == ''
    let dict = globpath(path, a:name)
  endif
  if dict == ''
    " Search dictionary file from system.
    for path in [
          \ '/usr/local/share/'.a:name,
          \ '/usr/share/'.a:name,
          \ ]
      if filereadable(path)
        let dict = path
      endif
    endfor
  endif

  return get(split(dict, '\n'), 0, '')
endfunction

let s:matcher = {
      \ 'name' : 'matcher_migemo',
      \ 'description' : 'migemo matcher',
      \}

function! s:matcher.filter(candidates, context) abort "{{{
  if a:context.input == ''
    return a:candidates
  endif

  let candidates = a:candidates
  for input in a:context.input_list
    if input =~ '^!'
      if input == '!'
        continue
      endif
      " Exclusion match.
      let expr = 'v:val.word !~ ' .
            \ string(s:get_migemo_pattern(input[1:]))
    elseif input =~ '^:'
      " Executes command.
      let a:context.execute_command = input[1:]
      continue
    else
      let expr = 'v:val.word =~ ' .
            \ string(s:get_migemo_pattern(input))
    endif

    try
      let candidates = unite#filters#filter_matcher(
            \ candidates, expr, a:context)
    catch
      let candidates = []
    endtry
  endfor

  return candidates
endfunction"}}}
function! s:matcher.pattern(input) abort "{{{
  return s:get_migemo_pattern(a:input)
endfunction"}}}

function! s:get_migemo_pattern(input) abort
  if has('migemo')
    " Use migemo().
    return migemo(a:input)
  else
    " Use cmigemo.
    return vimproc#system(
          \ 'cmigemo -v -w "'.a:input.'" -d "'.s:migemodict.'"')
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
