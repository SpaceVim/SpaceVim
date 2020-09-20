"=============================================================================
" FILE: file_include.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! neoinclude#file_include#get_complete_position(input) abort
  call neoinclude#initialize()

  let filetype = neoinclude#util#get_context_filetype()
  if filetype ==# 'java' || filetype ==# 'haskell'
    " Cannot complete include path.
    " You should use omnifunc plugins..
    return -1
  endif

  " Not Filename pattern.
  let pattern = neoinclude#get_pattern('%', filetype)
  if (pattern == '' || a:input !~ pattern)
        \ && a:input =~ '\*$\|\.\.\+$\|/c\%[ygdrive/]$'
    " Skip filename completion.
    return -1
  endif

  " Check include pattern.
  let pattern = neoinclude#get_pattern('%', filetype)
  if pattern =~ '\w$'
    let pattern .= '\m\s\+'
  endif
  if pattern == '' || a:input !~ pattern
    return -1
  endif

  let match_end = matchend(a:input, pattern)
  let complete_str = matchstr(a:input[match_end :], '\f\+')

  let complete_pos = len(a:input) - len(complete_str)

  let delimiter = neoinclude#get_delimiters(filetype)
  if delimiter != '' && strridx(complete_str, delimiter) >= 0
    let complete_pos += strridx(complete_str, delimiter) + 1
  endif

  return complete_pos
endfunction

function! neoinclude#file_include#get_include_files(input) abort
  call neoinclude#initialize()

  let filetype = neoinclude#util#get_context_filetype()

  call neoinclude#set_filetype_paths('%', filetype)

  let path = neoinclude#get_path('%', filetype)
  let pattern = neoinclude#get_pattern('%', filetype)
  let expr = neoinclude#get_expr('%', filetype)
  let reverse_expr = neoinclude#get_reverse_expr(filetype)
  let exts = neoinclude#get_exts(filetype)

  let line = a:input

  let match_end = matchend(line, pattern)
  let complete_str = matchstr(line[match_end :], '\f\+')
  if expr != ''
    let complete_str =
          \ substitute(eval(substitute(expr,
          \ 'v:fname', string(complete_str), 'g')), '\.\w*$', '', '')
  endif
  let delimiter = neoinclude#get_delimiters(filetype)

  if (line =~ '^\s*\<require_relative\>' && filetype =~# 'ruby')
        \ || stridx(complete_str, '.') == 0
    " For include relative.
    let path = '.'
  endif

  " Path search.
  let glob = (complete_str !~ '\*$')?
        \ complete_str . '*' : complete_str
  let bufdirectory = neoinclude#util#substitute_path_separator(
        \ fnamemodify(expand('%'), ':p:h'))
  let candidates = s:get_default_include_files(filetype)
  let path = join(map(split(path, ',\+'),
        \ "v:val == '.' ? bufdirectory : v:val"), ',')
  for word in filter(split(
        \ neoinclude#util#substitute_path_separator(
        \   globpath(path, glob, 1)), '\n'),"
        \  isdirectory(v:val) || empty(exts) ||
        \  index(exts, fnamemodify(v:val, ':e')) >= 0")

    let dict = {
          \ 'word' : word,
          \ 'action__is_directory' : isdirectory(word),
          \ 'kind' : (isdirectory(word) ? 'dir' : 'file'),
          \ }

    if reverse_expr != ''
      " Convert filename.
      let dict.word = eval(substitute(reverse_expr,
            \ 'v:fname', string(dict.word), 'g'))
    endif

    if !dict.action__is_directory && delimiter != '/'
      " Remove extension.
      let dict.word = fnamemodify(dict.word, ':r')
    endif

    " Remove before delimiter.
    if delimiter != '' && strridx(dict.word, delimiter) >= 0
      let dict.word = dict.word[strridx(dict.word, delimiter)+strlen(delimiter): ]
    endif

    " Remove bufdirectory.
    if stridx(dict.word, bufdirectory . '/') == 0
      let dict.word = dict.word[len(bufdirectory)+1 : ]
    endif

    let dict.abbr = dict.word
    if dict.action__is_directory
      let dict.abbr .= delimiter
    endif

    call add(candidates, dict)
  endfor

  return candidates
endfunction

function! s:get_default_include_files(filetype) abort
  let files = []

  if a:filetype ==# 'python' || a:filetype ==# 'python3'
    let files = ['sys']
  endif

  return map(files, "{
        \ 'word' : v:val,
        \ 'action__is_directory' : isdirectory(v:val),
        \ 'kind' : (isdirectory(v:val) ? 'dir' : 'file'),
        \}")
endfunction
