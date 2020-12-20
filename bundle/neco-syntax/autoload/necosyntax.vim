"=============================================================================
" FILE: necosyntax.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

let g:necosyntax#min_keyword_length =
 \ get(g:, 'necosyntax#min_keyword_length', 4)
let g:necosyntax#max_syntax_lines =
 \ get(g:, 'necosyntax#max_syntax_lines', 300)

function! necosyntax#initialize() abort
  let s:syntax_list = {}

  augroup necosyntax
    autocmd!
    autocmd Syntax * call s:make_cache()
  augroup END

  " Initialize check.
  call s:make_cache()
endfunction

function! necosyntax#gather_candidates() abort
  let filetype = &filetype
  if filetype == ''
    return []
  endif

  if !has_key(s:syntax_list, filetype)
    call s:make_cache()
  endif

  let list = []
  for ft in s:get_context_filetypes(filetype)
    let list += get(s:syntax_list, ft, [])
  endfor
  return list
endfunction

function! s:make_cache() abort
  let ft = &filetype
  if ft == '' || ft ==# 'vim' || has_key(s:syntax_list, ft)
    return
  endif

  " Make cache from syntax list.
  let s:syntax_list[ft] = s:make_cache_from_syntax(ft)
endfunction

function! s:make_cache_from_syntax(filetype) abort
  " Get current syntax list.
  let syntax_list = s:redir('syntax list')
  if syntax_list =~ '^E\d\+' || syntax_list =~ '^No Syntax items'
    return []
  endif

  let lines = split(syntax_list, '\n')
  if len(lines) > g:necosyntax#max_syntax_lines
    " Too long.
    return []
  endif

  let group_name = ''
  let keyword_pattern = '\h\w*'

  let keyword_list = []
  for line in lines
    if line =~ '^\h\w\+'
      " Change syntax group name.
      let group_name = matchstr(line, '^\S\+')
      let line = substitute(line, '^\S\+\s*xxx', '', '')
    endif

    if line =~ 'Syntax items' || line =~ '^\s*links to' ||
          \ line =~ '^\s*nextgroup='
      " Next line.
      continue
    endif

    let line = substitute(line,
          \ 'contained\|skipwhite\|skipnl\|oneline', '', 'g')
    let line = substitute(line,
          \ '^\s*nextgroup=.*\ze\s', '', '')

    if line =~ '^\s*match'
      let line = s:substitute_candidate(
            \ matchstr(line, '/\zs[^/]\+\ze/'))
    elseif line =~ '^\s*start='
      let line =
            \s:substitute_candidate(
            \   matchstr(line, 'start=/\zs[^/]\+\ze/')) . ' ' .
            \s:substitute_candidate(
            \   matchstr(line, 'end=/zs[^/]\+\ze/'))
    endif

    " Add keywords.
    let match_num = 0
    let match_str = matchstr(line, keyword_pattern, match_num)

    while match_str != ''
      " Ignore too short keyword.
      if len(match_str) >= g:necosyntax#min_keyword_length
            \&& match_str =~ '^[[:print:]]\+$'
        call add(keyword_list, match_str)
      endif

      let match_num += len(match_str)

      let match_str = matchstr(line, keyword_pattern, match_num)
    endwhile
  endfor

  let keyword_list = s:uniq(keyword_list)

  return keyword_list
endfunction

function! s:substitute_candidate(candidate) abort
  let candidate = a:candidate

  " Collection.
  let candidate = substitute(candidate,
        \'\\\@<!\[[^\]]*\]', ' ', 'g')

  " Delete.
  let candidate = substitute(candidate,
        \'\\\@<!\%(\\[=?+]\|\\%[\|\\s\*\)', '', 'g')
  " Space.
  let candidate = substitute(candidate,
        \'\\\@<!\%(\\[<>{}]\|[$^]\|\\z\?\a\)', ' ', 'g')

  if candidate =~ '\\%\?('
    let candidate = join(necosyntax#_split_pattern(
          \ candidate, ''))
  endif

  " \
  let candidate = substitute(candidate, '\\\\', '\\', 'g')
  " *
  let candidate = substitute(candidate, '\\\*', '*', 'g')
  return candidate
endfunction

function! necosyntax#_split_pattern(keyword_pattern, prefix) abort
  let original_pattern = a:keyword_pattern
  let result_patterns = []
  let analyzing_patterns = [ '' ]

  let i = 0
  let max = len(original_pattern)
  while i < max
    if match(original_pattern, '^\\%\?(', i) >= 0
      " Grouping.
      let end = s:match_pair(original_pattern, '\\%\?(', '\\)', i)
      if end < 0
        break
      endif

      let save_patterns = analyzing_patterns
      let analyzing_patterns = []
      for pattern in filter(save_patterns, "v:val !~ '.*\\s\\+.*\\s'")
        let analyzing_patterns += necosyntax#_split_pattern(
              \ original_pattern[matchend(original_pattern,
              \                 '^\\%\?(', i) : end-1],
              \ pattern)
      endfor

      let i = end + 2
    elseif match(original_pattern, '^\\|', i) >= 0
      " Select.
      let result_patterns += analyzing_patterns
      let analyzing_patterns = [ '' ]
      let original_pattern = original_pattern[i+2 :]
      let max = len(original_pattern)

      let i = 0
    elseif original_pattern[i] == '\' && i+1 < max
      call map(analyzing_patterns, 'v:val . original_pattern[i+1]')

      " Escape.
      let i += 2
    else
      call map(analyzing_patterns, 'v:val . original_pattern[i]')

      let i += 1
    endif
  endwhile

  let result_patterns += analyzing_patterns
  return map(result_patterns, 'a:prefix . v:val')
endfunction

function! s:match_pair(string, start_pattern, end_pattern, start_cnt) abort
  let end = -1
  let start_pattern = '\%(' . a:start_pattern . '\)'
  let end_pattern = '\%(' . a:end_pattern . '\)'

  let i = a:start_cnt
  let max = len(a:string)
  let nest_level = 0
  while i < max
    let start = match(a:string, start_pattern, i)
    let end = match(a:string, end_pattern, i)

    if start >= 0 && (end < 0 || start < end)
      let i = matchend(a:string, start_pattern, i)
      let nest_level += 1
    elseif end >= 0 && (start < 0 || end < start)
      let nest_level -= 1

      if nest_level == 0
        return end
      endif

      let i = matchend(a:string, end_pattern, i)
    else
      break
    endif
  endwhile

  if nest_level != 0
    return -1
  else
    return end
  endif
endfunction

function! s:uniq(list) abort
  let dict = {}
  for item in a:list
    if !has_key(dict, item)
      let dict[item] = item
    endif
  endfor

  return values(dict)
endfunction

function! s:get_context_filetypes(filetype) abort
  if !exists('s:exists_context_filetype')
    try
      call context_filetype#version()
      let s:exists_context_filetype = 1
    catch
      let s:exists_context_filetype = 0
    endtry
  endif

  return s:exists_context_filetype
        \ && exists('*context_filetype#get_filetypes') ?
        \ context_filetype#get_filetypes(a:filetype) : [a:filetype]
endfunction

function! s:redir(command) abort
  if exists('*execute')
    return execute(a:command)
  endif

  redir => r
  execute 'silent!' a:command
  redir END

  return r
endfunction
