function! zvim#tab() abort
  if getline('.')[col('.')-2] ==# '{'&& pumvisible()
    return "\<C-n>"
  endif
  if neosnippet#expandable() && getline('.')[col('.')-2] ==# '(' && !pumvisible()
    return "\<Plug>(neosnippet_expand)"
  elseif neosnippet#jumpable() && getline('.')[col('.')-2] ==# '(' && !pumvisible() && !neosnippet#expandable()
    return "\<plug>(neosnippet_jump)"
  elseif neosnippet#expandable_or_jumpable() && getline('.')[col('.')-2] !=#'('
    return "\<plug>(neosnippet_expand_or_jump)"
  elseif pumvisible()
    return "\<C-n>"
  else
    return "\<tab>"
  endif
endfunction

function! zvim#enter() abort
  if pumvisible()
    if getline('.')[col('.') - 2]==# '{'
      return "\<Enter>"
    elseif g:spacevim_autocomplete_method ==# 'neocomplete'||g:spacevim_autocomplete_method ==# 'deoplete'
      return "\<C-y>"
    else
      return "\<esc>a"
    endif
  elseif getline('.')[col('.') - 2]==#'{'&&getline('.')[col('.')-1]==#'}'
    return "\<Enter>\<esc>ko"
  else
    return "\<Enter>"
  endif
endfunction

function! zvim#format() abort
  let save_cursor = getpos('.')
  normal! gg=G
  call setpos('.', save_cursor)
endfunction

function! zvim#gf() abort
  if &filetype isnot# 'vim'
    return 0
  endif
  let isk = &l:iskeyword
  setlocal iskeyword+=:,<,>,#
  try
    let line = getline('.')
    let start = s:find_start(line, col('.'))
    if line[start :] =~? '\%(s:\|<SNR>\|<SID>\)'
      let line = substitute(line, '<\%(SNR\|SID\)>', 's:', '')
      let path = expand('%')
    else
      for base_dir in [getcwd()] + split(finddir('autoload', expand('%:p:h') . ';')) + [&runtimepath]
        let path = s:autoload_path(base_dir, line[start : ])
        if !empty(path)
          break
        endif
      endfor
    endif
    if !empty(path)
      let line = s:search_line(path, matchstr(line[start :], '\k\+'))
      let col = start
      exe 'e ' . path
      call cursor(line, col)
    endif
  finally
    let &l:iskeyword = isk
  endtry
endfunction


if has('patch-7.4.279')
  function! s:globpath(path, expr) abort "{{{
    return globpath(a:path, a:expr, 1, 1)
  endfunction "}}}
else
  function! s:globpath(path, expr) abort "{{{
    return split(globpath(a:path, a:expr), '\n')
  endfunction "}}}
endif


function! s:autoload_path(base_dir, function_name) abort "{{{
  let match = matchstr(a:function_name, '\k\+\ze#')
  let fname = expand('autoload/' . substitute(match, '#', '/', 'g') . '.vim')
  let paths = s:globpath(a:base_dir, fname)
  return len(paths) > 0 ? paths[0] : ''
endfunction "}}}


function! s:find_start(line, cursor_index) abort "{{{
  for i in range(a:cursor_index, 0, -1)
    if a:line[i] !~# '\k'
      return i+1
    endif
  endfor
  return 0
endfunction "}}}


function! s:search_line(path, term) abort "{{{
  let line = match(readfile(a:path), '\s*fu\%[nction]!\?\s*' . a:term . '\>')
  if line >= 0
    return line+1
  endif
  return 0
endfunction "}}}

" vim:set et sw=2:
