"=============================================================================
" FILE: jump_list.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Variables  "{{{
if !exists('g:unite_kind_jump_list_after_jump_scroll')
  let g:unite_kind_jump_list_after_jump_scroll = 25
else
  let g:unite_kind_jump_list_after_jump_scroll =
        \ min([max([0, g:unite_kind_jump_list_after_jump_scroll]), 100])
endif
"}}}

function! unite#kinds#jump_list#define() abort "{{{
  let kind = {
        \ 'name' : 'jump_list',
        \ 'default_action' : 'open',
        \ 'action_table': {},
        \ 'alias_table' : { 'rename' : 'replace' },
        \ 'parents': ['common', 'openable'],
        \}

  " Actions "{{{
  let kind.action_table.open = {
        \ 'description' : 'jump to this position',
        \ 'is_selectable' : 1,
        \ }
  function! kind.action_table.open.func(candidates) abort "{{{
    for candidate in a:candidates
      " Save current line in jump_list
      execute 'normal!' line('.').'G'

      if s:convert_path(bufname('%')) !=#
            \ s:convert_path(s:get_filename(candidate))
        let bufnr = s:open(candidate)
        call unite#remove_previewed_buffer_list(bufnr)
      endif

      call s:jump(candidate, 0)

      " Open folds.
      normal! zv
      call s:adjust_scroll(s:best_winline())
      call unite#view#_clear_match_highlight()
    endfor

    " Add search history
    let context = unite#get_context()
    if has_key(context, 'input_list')
          \ && len(context.input_list) == 1
          \ && context.input != ''
      call histadd("search", context.input)
    endif
  endfunction"}}}

  let kind.action_table.preview = {
        \ 'description' : 'preview this position',
        \ 'is_quit' : 0,
        \ }
  function! kind.action_table.preview.func(candidate) abort "{{{
    let filename = s:get_filename(a:candidate)
    let bufwinnr = bufwinnr(filename)
    let buflisted = buflisted(filename)
    let preview_windows = filter(range(1, winnr('$')),
          \ 'getwinvar(v:val, "&previewwindow") != 0')
    if empty(preview_windows)
      call unite#view#_preview_file(filename)
    endif

    let winnr = winnr()
    wincmd P
    try
      let bufnr = s:open(a:candidate)
      if bufwinnr < 0 && !buflisted
        call unite#add_previewed_buffer_list(bufnr)
      endif
      call s:jump(a:candidate, 1)
    finally
      execute winnr.'wincmd w'
    endtry
  endfunction"}}}

  let kind.action_table.highlight = {
        \ 'description' : 'highlight this position',
        \ 'is_quit' : 0,
        \ }
  function! kind.action_table.highlight.func(candidate) abort "{{{
    let candidate_winnr = bufwinnr(s:get_bufnr(a:candidate))

    if candidate_winnr > 0
      let unite = unite#get_current_unite()
      let current_winnr = winnr()

      noautocmd execute candidate_winnr 'wincmd w'

      call s:jump(a:candidate, 1)
      let unite_winnr = bufwinnr(unite.bufnr)
      if unite_winnr < 0
        let unite_winnr = current_winnr
      endif
      if unite_winnr > 0
        noautocmd execute unite_winnr 'wincmd w'
      endif
    endif
  endfunction"}}}


  let kind.action_table.replace = {
        \ 'description' : 'replace with qfreplace',
        \ 'is_selectable' : 1,
        \ }
  function! kind.action_table.replace.func(candidates) abort "{{{
    if globpath(&runtimepath, 'autoload/qfreplace.vim') == ''
      echo 'qfreplace.vim is not installed.'
      return
    endif

    let qflist = []
    for candidate in a:candidates
      if has_key(candidate, 'action__line')
            \ && has_key(candidate, 'action__text')
        let filename = s:get_filename(candidate)
        call add(qflist, {
              \ 'filename' : filename,
              \ 'lnum' : candidate.action__line,
              \ 'text' : candidate.action__text,
              \ })
      endif
    endfor

    if !empty(qflist)
      call setqflist(qflist)
      call qfreplace#start('')
    endif
  endfunction"}}}

  return kind
endfunction"}}}

"}}}

" Misc.
function! s:jump(candidate, is_highlight) abort "{{{
  let line = get(a:candidate, 'action__line', 1)
  let pattern = get(a:candidate, 'action__pattern', '')

  if line == ''
    " Use default line number.
    let line = 1
  endif
  if line !~ '^\d\+$'
    call unite#print_error('jump_list: Invalid action__line format.')
    return
  endif

  if !has_key(a:candidate, 'action__pattern')
    " Jump to the line number.
    call cursor(line, 0)

    call s:jump_column(a:candidate)

    call s:open_current_line(a:is_highlight)
    return
  endif

  " Jump by search().
  let source = unite#get_sources(a:candidate.source)
  if !(has_key(a:candidate, 'action__signature')
        \ && has_key(source, 'calc_signature'))
    " Not found signature.
    if line != '' && getline(line) =~# pattern
      if line('.') != line
        call cursor(line, 0)
      endif
    else
      silent! call search(pattern, 'w')
    endif

    call s:jump_column(a:candidate)

    call s:open_current_line(a:is_highlight)
    return
  endif

  silent! call search(pattern, 'w')

  let lnum_prev = line('.')
  silent! call search(pattern, 'w')
  let lnum = line('.')
  if lnum != lnum_prev
    " Detected same pattern lines!!
    let start_lnum = lnum
    while source.calc_signature(lnum) !=#
          \ a:candidate.action__signature
      silent! call search(pattern, 'w')
      let lnum = line('.')
      if lnum == start_lnum
        " Not found.
        call unite#print_error(
              \ 'jump_list: Target position is not found.')
        call cursor(1, 1)
        return
      endif
    endwhile
  endif

  call s:open_current_line(a:is_highlight)
endfunction"}}}

function! s:best_winline() abort "{{{
  return max([1, winheight(0) * g:unite_kind_jump_list_after_jump_scroll / 100])
endfunction"}}}

function! s:jump_column(candidate) abort "{{{
  let col = get(a:candidate, 'action__col', 0)
  if col == 0 && has_key(a:candidate, 'action__col_pattern')
    " Search col pattern.
    let pattern = a:candidate.action__col_pattern
    if pattern == ''
      " Use context.input
      let pattern = unite#get_context().input
    endif

    let col = 0
    silent! let col = match(getline('.'), pattern) + 1
  endif

  call cursor(0, col)
endfunction"}}}

function! s:adjust_scroll(best_winline) abort "{{{
  normal! zt
  let save_cursor = getpos('.')
  let winl = 1
  " Scroll the cursor line down.
  while winl <= a:best_winline
    let winl_prev = winl
    execute "normal! \<C-y>"
    let winl = winline()
    if winl == winl_prev
      break
    end
    let winl_prev = winl
  endwhile
  if winl > a:best_winline
    execute "normal! \<C-e>"
  endif
  call setpos('.', save_cursor)
endfunction"}}}

function! s:open_current_line(is_highlight) abort "{{{
  normal! zv
  normal! zz
  if a:is_highlight
    call unite#view#_clear_match_highlight()
    call unite#view#_match_line('Search', line('.'))
  endif
endfunction"}}}

function! s:open(candidate) abort "{{{
  let bufnr = s:get_bufnr(a:candidate)
  if bufnr != bufnr('%')
    if has_key(a:candidate, 'action__buffer_nr')
      silent execute 'keepjumps buffer' bufnr
    else
      silent call unite#util#smart_execute_command(
            \ 'keepjumps edit!', unite#util#expand(
            \   fnamemodify(a:candidate.action__path, ':~:.')))
      let bufnr = bufnr('%')
    endif
  endif

  return bufnr
endfunction"}}}
function! s:get_filename(candidate) abort "{{{
  return has_key(a:candidate, 'action__path') ?
            \ a:candidate.action__path :
            \ bufname(a:candidate.action__buffer_nr)
endfunction"}}}
function! s:get_bufnr(candidate) abort "{{{
  return has_key(a:candidate, 'action__buffer_nr') ?
        \ a:candidate.action__buffer_nr :
        \ bufnr(a:candidate.action__path)
endfunction"}}}
function! s:convert_path(path) abort "{{{
  return unite#util#substitute_path_separator(fnamemodify(a:path, ':p'))
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
