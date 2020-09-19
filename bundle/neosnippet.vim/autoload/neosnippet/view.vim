"=============================================================================
" FILE: view.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! neosnippet#view#_expand(cur_text, col, trigger_name) abort
  let snippets = neosnippet#helpers#get_snippets()

  if a:trigger_name ==# '' || !has_key(snippets, a:trigger_name)
    let pos = getpos('.')
    let pos[2] = len(a:cur_text)+1
    call setpos('.', pos)

    if pos[2] < col('$')
      startinsert
    else
      startinsert!
    endif

    return
  endif

  let snippet = snippets[a:trigger_name]
  let cur_text = a:cur_text[: -1-len(a:trigger_name)]

  call neosnippet#view#_insert(snippet.snip, snippet.options, cur_text, a:col)
endfunction
function! neosnippet#view#_insert(snippet, options, cur_text, col) abort
  let options = extend(
        \ neosnippet#parser#_initialize_snippet_options(),
        \ a:options)

  let snip_word = a:snippet
  if snip_word =~# '\\\@<!`.*\\\@<!`'
    let snip_word = s:eval_snippet(snip_word)
  endif

  " Substitute markers.
  if snip_word =~# neosnippet#get_placeholder_marker_substitute_pattern()
    let snip_word = substitute(snip_word,
          \ neosnippet#get_placeholder_marker_substitute_pattern(),
          \ '<`\1`>', 'g')
    let snip_word = substitute(snip_word,
          \ neosnippet#get_mirror_placeholder_marker_substitute_pattern(),
          \ '<|\1|>', 'g')
  else
    let snip_word = substitute(snip_word,
          \ neosnippet#get_mirror_placeholder_marker_substitute_pattern(),
          \ '<`\1`>', 'g')
  endif
  let snip_word = substitute(snip_word,
        \ neosnippet#get_placeholder_marker_substitute_zero_pattern(),
        \ '<`\1`>', 'g')

  " Substitute escaped characters.
  let snip_word = substitute(snip_word, '\\\(\\\|`\|\$\)', '\1', 'g')

  " Insert snippets.
  let next_line = getline('.')[a:col-1 :]
  let snippet_lines = split(snip_word, '\n', 1)
  if empty(snippet_lines)
    return
  endif

  let begin_line = line('.')
  let end_line = line('.') + len(snippet_lines) - 1

  let expanded_word = snippet_lines[0]

  let snippet_lines[0] = a:cur_text . snippet_lines[0]
  let snippet_lines[-1] = snippet_lines[-1] . next_line

  let foldmethod_save = ''
  if has('folding')
    " Note: Change foldmethod to "manual". Because, if you use foldmethod is
    " expr, whole snippet is visually selected.
    let foldmethod_save = &l:foldmethod
    let &l:foldmethod = 'manual'
  endif

  let expand_stack = neosnippet#variables#expand_stack()

  try
    let base_indent = matchstr(getline(begin_line), '^\s\+')
    if len(snippet_lines) > 1
      call append('.', snippet_lines[1:])
    endif
    call setline('.', snippet_lines[0])

    let next_col = len(a:cur_text) + len(expanded_word) + 1
    call cursor([begin_line, next_col])
    if next_col >= col('$')
      startinsert!
    else
      startinsert
    endif

    if begin_line != end_line || options.indent
      call s:indent_snippet(begin_line, end_line, base_indent, options)
    endif

    let begin_patterns = (begin_line > 1) ?
          \ [getline(begin_line - 1)] : []
    let end_patterns =  (end_line < line('$')) ?
          \ [getline(end_line + 1)] : []
    call add(expand_stack, {
          \ 'snippet' : a:snippet,
          \ 'begin_line' : begin_line,
          \ 'begin_patterns' : begin_patterns,
          \ 'end_line' : end_line,
          \ 'end_patterns' : end_patterns,
          \ 'holder_cnt' : 1,
          \ })

    if snip_word =~ neosnippet#get_placeholder_marker_pattern()
      call neosnippet#view#_jump('', a:col)
    endif
  finally
    if has('folding')
      if foldmethod_save !=# &l:foldmethod
        let &l:foldmethod = foldmethod_save
      endif

      silent! execute begin_line . ',' . end_line . 'foldopen!'
    endif
  endtry
endfunction
function! neosnippet#view#_jump(_, col) abort
  try
    let expand_stack = neosnippet#variables#expand_stack()

    " Get patterns and count.
    if empty(expand_stack)
      return neosnippet#view#_search_outof_range(a:col)
    endif

    let expand_info = expand_stack[-1]
    " Search patterns.
    let [begin, end] = neosnippet#view#_get_snippet_range(
          \ expand_info.begin_line,
          \ expand_info.begin_patterns,
          \ expand_info.end_line,
          \ expand_info.end_patterns)

    let begin_cnt = expand_info.holder_cnt
    if expand_info.snippet =~
          \ neosnippet#get_placeholder_marker_substitute_nonzero_pattern()
      while (expand_info.holder_cnt - begin_cnt) < 5
        " Next count.
        let expand_info.holder_cnt += 1
        if neosnippet#view#_search_snippet_range(
              \ begin, end, expand_info.holder_cnt - 1)
          return 1
        endif
      endwhile
    endif

    " Search placeholder 0.
    if neosnippet#view#_search_snippet_range(begin, end, 0)
      return 1
    endif

    " Not found.
    call neosnippet#variables#pop_expand_stack()

    return neosnippet#view#_jump(a:_, a:col)
  finally
    call s:skip_next_auto_completion()
  endtry
endfunction

function! s:indent_snippet(begin, end, base_indent, options) abort
  if a:begin > a:end
    return
  endif

  let pos = getpos('.')

  let equalprg = &l:equalprg
  try
    setlocal equalprg=

    let neosnippet = neosnippet#variables#current_neosnippet()
    for line_nr in range((neosnippet.target !=# '' ?
          \ a:begin : a:begin + 1), a:end)
      call cursor(line_nr, 0)

      if getline('.') =~# '^\t\+'
        let current_line = getline('.')
        if line_nr != a:begin && !a:options.lspitem
          " Delete head tab character.
          let current_line = substitute(current_line, '^\t', '', '')
        endif

        if &l:expandtab && current_line =~# '^\t\+'
          " Expand tab.
          cal setline('.', substitute(current_line,
                \ '^\t\+', a:base_indent . repeat(' ', shiftwidth() *
                \    len(matchstr(current_line, '^\t\+'))), ''))
        elseif line_nr != a:begin
          call setline('.', a:base_indent . current_line)
        endif
      else
        silent normal! ==
      endif
    endfor
  finally
    let &l:equalprg = equalprg
    call setpos('.', pos)
  endtry
endfunction

function! neosnippet#view#_get_snippet_range(begin_line, begin_patterns, end_line, end_patterns) abort
  let pos = getpos('.')

  call cursor(a:begin_line, 0)
  if empty(a:begin_patterns)
    let begin = line('.') - 50
  else
    let begin = searchpos('^' . neosnippet#util#escape_pattern(
          \ a:begin_patterns[0]) . '$', 'bnW')[0]
    if begin > 0 && a:begin_line == a:end_line
      call setpos('.', pos)
      return [begin + 1, begin + 1]
    endif

    if begin <= 0
      let begin = line('.') - 50
    endif
  endif
  if begin <= 0
    let begin = 1
  endif

  call cursor(a:end_line, 0)
  if empty(a:end_patterns)
    let end = line('.') + 50
  else
    let end = searchpos('^' . neosnippet#util#escape_pattern(
          \ a:end_patterns[0]) . '$', 'nW')[0]
    if end <= 0
      let end = line('.') + 50
    endif
  endif
  if end > line('$')
    let end = line('$')
  endif

  call setpos('.', pos)
  return [begin, end]
endfunction
function! neosnippet#view#_search_snippet_range(start, end, cnt, ...) abort
  let is_select = get(a:000, 0, 1)
  call s:substitute_placeholder_marker(a:start, a:end, a:cnt)

  " Search marker pattern.
  let pattern = substitute(neosnippet#get_placeholder_marker_pattern(),
        \ '\\d\\+', a:cnt, '')

  for line in filter(range(a:start, a:end),
        \ 'getline(v:val) =~ pattern')
    call s:expand_placeholder(a:start, a:end, a:cnt, line, is_select)
    return 1
  endfor

  for linenum in range(a:start, a:end)
    let tmp_line = getline(linenum)
    let tmp_line = substitute(tmp_line, '%uc(\([^)]\+\))', '\U\1\E', 'g')
    let tmp_line = substitute(tmp_line, '%ucfirst(\([^)]\+\))', '\u\1', 'g')
    call setline(linenum, tmp_line)
  endfor

  return 0
endfunction
function! neosnippet#view#_search_outof_range(col) abort
  call s:substitute_placeholder_marker(1, 0, 0)

  let pattern = neosnippet#get_placeholder_marker_pattern()
  if search(pattern, 'w') > 0
    call s:expand_placeholder(line('.'), 0, '\\d\\+', line('.'))
    return 1
  endif

  let pos = getpos('.')
  if a:col == 1
    let pos[2] = 1
    call setpos('.', pos)
    startinsert
  elseif a:col >= col('$')
    startinsert!
  else
    let pos[2] = a:col+1
    call setpos('.', pos)
    startinsert
  endif

  " Not found.
  return 0
endfunction
function! neosnippet#view#_clear_markers(expand_info) abort
  " Search patterns.
  let [begin, end] = neosnippet#view#_get_snippet_range(
        \ a:expand_info.begin_line,
        \ a:expand_info.begin_patterns,
        \ a:expand_info.end_line,
        \ a:expand_info.end_patterns)

  let mode = mode()
  let pos = getpos('.')

  " Found snippet.
  let found = 0
  try
    while neosnippet#view#_search_snippet_range(
          \ begin, end, a:expand_info.holder_cnt, 0)

      " Next count.
      let a:expand_info.holder_cnt += 1
      let found = 1
    endwhile

    " Search placeholder 0.
    if neosnippet#view#_search_snippet_range(begin, end, 0)
      let found = 1
    endif
  finally
    if found && mode !=# 'i'
      stopinsert
    endif

    call setpos('.', pos)

    call neosnippet#variables#pop_expand_stack()
  endtry
endfunction
function! s:expand_placeholder(start, end, holder_cnt, line, ...) abort
  let is_select = get(a:000, 0, 1)

  let pattern = substitute(neosnippet#get_placeholder_marker_pattern(),
        \ '\\d\\+', a:holder_cnt, '')
  let current_line = getline(a:line)
  let match = match(current_line, pattern)
  let neosnippet = neosnippet#variables#current_neosnippet()

  let default_pattern = substitute(
        \ neosnippet#get_placeholder_marker_default_pattern(),
        \ '\\d\\+', a:holder_cnt, '')
  let default = substitute(
        \ matchstr(current_line, default_pattern),
        \ '\\\ze[^$\\]', '', 'g')
  let neosnippet.optional_tabstop = (default =~# '^#:')
  if !is_select && default =~# '^#:'
    " Delete comments.
    let default = ''
  endif

  " Remove optional marker
  let default = substitute(default, '^#:', '', '')

  let default = substitute(default, '\${VISUAL\(:.\{-}\)\?}', 'TARGET\1', '')
  let is_target = (default =~# '^TARGET\>' && neosnippet.target !=# '')
  let default = substitute(default, '^TARGET:\?', neosnippet.target, '')

  let neosnippet.selected_text = default

  " Substitute marker.
  let default = substitute(default,
        \ neosnippet#get_placeholder_marker_substitute_pattern(),
        \ '<`\1`>', 'g')
  let default = substitute(default,
        \ neosnippet#get_mirror_placeholder_marker_substitute_pattern(),
        \ '<|\1|>', 'g')
  let default = substitute(default, '\\\$', '$', 'g')

  " len() cannot use for multibyte.
  let default_len = len(substitute(default, '.', 'x', 'g'))

  let pos = getpos('.')
  let pos[1] = a:line
  let pos[2] = match+1

  let cnt = s:search_sync_placeholder(a:start, a:end, a:holder_cnt)
  if cnt >= 0
    let pattern = substitute(neosnippet#get_placeholder_marker_pattern(),
          \ '\\d\\+', cnt, '')
    call setline(a:line, substitute(current_line, pattern,
          \ '<{'.cnt.':'.escape(default, '\').'}>', ''))
    let pos[2] += len('<{'.cnt.':')
  else
    if is_target
      let default = ''
    endif

    " Substitute holder.
    call setline(a:line,
          \ substitute(current_line, pattern, escape(default, '&\'), ''))
  endif

  call setpos('.', pos)

  if is_target && cnt < 0
    " Expand target
    return s:expand_target_placeholder(a:line, match+1)
  endif

  if default_len > 0 && is_select
    " Select default value.
    let len = default_len-1
    if &l:selection ==# 'exclusive'
      let len += 1
    endif

    let mode = mode()

    stopinsert

    normal! v
    call cursor(0, col('.') + (mode ==# 'i' ? len+1 : len))
    execute 'normal! ' "\<C-g>"
  elseif pos[2] < col('$')
    startinsert
  else
    startinsert!
  endif
endfunction
function! s:expand_target_placeholder(line, col) abort
  " Expand target
  let neosnippet = neosnippet#variables#current_neosnippet()
  let next_line = getline(a:line)[a:col-1 :]
  let target_lines = split(neosnippet.target, '\n', 1)

  let cur_text = getline(a:line)[: a:col-2]
  if match(cur_text, '^\s\+$') < 0
    let target_lines[0] = cur_text . target_lines[0]
  endif
  let target_lines[-1] = target_lines[-1] . next_line

  let begin_line = a:line
  let end_line = a:line + len(target_lines) - 1

  let col = col('.')
  try
    let base_indent = matchstr(cur_text, '^\s\+')
    let target_base_indent = -1
    for target_line in target_lines
      if match(target_line, '^\s\+$') < 0
        let target_current_indent = max([matchend(target_line, '^ *'),
              \ matchend(target_line, '^\t*') * &tabstop])
        if target_base_indent < 0
              \ || target_current_indent < target_base_indent
          let target_base_indent = target_current_indent
        endif
      endif
    endfor
    if target_base_indent < 0
      let target_base_indent = 0
    end
    let target_strip_indent_regex = '^\s\+$\|^' .
        \ repeat(' ', target_base_indent) . '\|^' .
        \ repeat('\t', target_base_indent / &tabstop)
    call map(target_lines,
          \ 'substitute(v:val, target_strip_indent_regex, "", "")')
    call map(target_lines,
          \ 'v:val ==# "" ? "" : base_indent . v:val')

    call setline(a:line, target_lines[0])
    if len(target_lines) > 1
      call append(a:line, target_lines[1:])
    endif

    call cursor(end_line, 0)

    if next_line !=# ''
      startinsert
      let col = col('.')
    else
      startinsert!
      let col = col('$')
    endif
  finally
    if has('folding')
      silent! execute begin_line . ',' . end_line . 'foldopen!'
    endif
  endtry

  let neosnippet.target = ''

  call neosnippet#view#_jump('', col)
endfunction
function! s:search_sync_placeholder(start, end, number) abort
  if a:end == 0
    " Search in current buffer.
    let cnt = matchstr(getline('.'),
          \ substitute(neosnippet#get_placeholder_marker_pattern(),
          \ '\\d\\+', '\\zs\\d\\+\\ze', ''))
    return search(substitute(
          \ neosnippet#get_mirror_placeholder_marker_pattern(),
          \ '\\d\\+', cnt, ''), 'nw') > 0 ? cnt : -1
  endif

  let pattern = substitute(
          \ neosnippet#get_mirror_placeholder_marker_pattern(),
          \ '\\d\\+', a:number, '')
  if !empty(filter(range(a:start, a:end),
        \ 'getline(v:val) =~ pattern'))
    return a:number
  endif

  return -1
endfunction
function! s:substitute_placeholder_marker(start, end, snippet_holder_cnt) abort
  if a:snippet_holder_cnt > 0
    let cnt = a:snippet_holder_cnt-1
    let sync_marker = substitute(neosnippet#get_sync_placeholder_marker_pattern(),
        \ '\\d\\+', cnt, '')
    let mirror_marker = substitute(
          \ neosnippet#get_mirror_placeholder_marker_pattern(),
          \ '\\d\\+', cnt, '')
    let line = a:start

    for line in range(a:start, a:end)
      if getline(line) =~ sync_marker
        let sub = escape(matchstr(getline(line),
              \ substitute(neosnippet#get_sync_placeholder_marker_default_pattern(),
              \ '\\d\\+', cnt, '')), '/\&')
        silent execute printf('%d,%ds/\m' . mirror_marker . '/%s/'
          \ . (&gdefault ? '' : 'g'), a:start, a:end, sub)
        call setline(line, substitute(getline(line), sync_marker, sub, ''))
      endif
    endfor
  elseif search(neosnippet#get_sync_placeholder_marker_pattern(), 'wb') > 0
    let sub = escape(matchstr(getline('.'),
          \ neosnippet#get_sync_placeholder_marker_default_pattern()), '/\')
    let cnt = matchstr(getline('.'),
          \ substitute(neosnippet#get_sync_placeholder_marker_pattern(),
          \ '\\d\\+', '\\zs\\d\\+\\ze', ''))
    let mirror_marker = substitute(
          \ neosnippet#get_mirror_placeholder_marker_pattern(),
          \ '\\d\\+', cnt, '')
    silent! execute printf('%%s/\m' . mirror_marker . '/%s/'
          \ . (&gdefault ? 'g' : ''), sub)
    let sync_marker = substitute(neosnippet#get_sync_placeholder_marker_pattern(),
        \ '\\d\\+', cnt, '')
    call setline('.', substitute(getline('.'), sync_marker, sub, ''))
  endif
endfunction
function! s:eval_snippet(snippet_text) abort
  let snip_word = ''
  let prev_match = 0
  let match = match(a:snippet_text, '\\\@<!`.\{-}\\\@<!`')

  while match >= 0
    if match - prev_match > 0
      let snip_word .= a:snippet_text[prev_match : match - 1]
    endif
    let prev_match = matchend(a:snippet_text,
          \ '\\\@<!`.\{-}\\\@<!`', match)
    let expr = a:snippet_text[match+1 : prev_match - 2]
    let snip_word .= (expr ==# '' ? '`' : eval(expr))

    let match = match(a:snippet_text, '\\\@<!`.\{-}\\\@<!`', prev_match)
  endwhile
  if prev_match >= 0
    let snip_word .= a:snippet_text[prev_match :]
  endif

  return snip_word
endfunction
function! s:skip_next_auto_completion() abort
  " Skip next auto completion.
  let neosnippet = neosnippet#variables#current_neosnippet()
  let neosnippet.trigger = 0

  if exists('#neocomplete#CompleteDone')
    doautocmd neocomplete CompleteDone
  endif
  if exists('#deoplete#CompleteDone')
    doautocmd deoplete CompleteDone
  endif
endfunction
