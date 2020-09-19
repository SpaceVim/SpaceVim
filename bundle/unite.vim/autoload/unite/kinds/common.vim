"=============================================================================
" FILE: common.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#common#define() abort "{{{
  return s:kind
endfunction"}}}

let s:kind = {
      \ 'name' : 'common',
      \ 'default_action' : 'nop',
      \ 'action_table': {},
      \ 'parents': [],
      \}

" Actions "{{{
let s:kind.action_table.nop = {
      \ 'description' : 'no operation',
      \ }
function! s:kind.action_table.nop.func(candidate) abort "{{{
endfunction"}}}

let s:kind.action_table.yank = {
      \ 'description' : 'yank word or text',
      \ 'is_selectable' : 1,
      \ 'is_quit' : 0,
      \ }
function! s:kind.action_table.yank.func(candidates) abort "{{{
  let text = join(map(copy(a:candidates),
        \ 's:get_candidate_text(v:val)'), "\n")
  let @" = text

  echohl Question | echo 'Yanked:' | echohl Normal
  echo text

  if has('clipboard')
    call setreg(v:register, text)
  endif
endfunction"}}}

let s:kind.action_table.yank_escape = {
      \ 'description' : 'yank escaped word or text',
      \ }
function! s:kind.action_table.yank_escape.func(candidate) abort "{{{
  let @" = escape(s:get_candidate_text(a:candidate), " *?[{`$\\%#\"|!<>")
endfunction"}}}

let s:kind.action_table.ex = {
      \ 'description' : 'insert candidates into command line',
      \ 'is_selectable' : 1,
      \ }
function! s:kind.action_table.ex.func(candidates) abort "{{{
  " Result is ':| {candidate}', here '|' means the cursor position.
  call feedkeys(printf(": %s\<C-b>",
        \ join(map(map(copy(a:candidates),
        \ "has_key(v:val, 'action__path') ? v:val.action__path : v:val.word"),
        \ 'escape(v:val, " *?[{`$\\%#\"|!<>")'))), 'n')
endfunction"}}}

let s:kind.action_table.insert = {
      \ 'description' : 'insert word or text',
      \ }
function! s:kind.action_table.insert.func(candidate) abort "{{{
  call s:paste(s:get_candidate_text(a:candidate), 'P',
        \ { 'regtype' : get(a:candidate, 'action__regtype', 'v')})
endfunction"}}}

let s:kind.action_table.append = {
      \ 'description' : 'append word or text',
      \ }
function! s:kind.action_table.append.func(candidate) abort "{{{
  call s:paste(s:get_candidate_text(a:candidate), 'p',
        \ { 'regtype' : get(a:candidate, 'action__regtype', 'v')})
endfunction"}}}

let s:kind.action_table.insert_directory = {
      \ 'description' : 'insert directory',
      \ }
function! s:kind.action_table.insert_directory.func(candidate) abort "{{{
  if has_key(a:candidate,'action__directory')
      let directory = a:candidate.action__directory
  elseif has_key(a:candidate, 'action__path')
      let directory = unite#util#path2directory(a:candidate.action__path)
  elseif has_key(a:candidate, 'word') && isdirectory(a:candidate.word)
      let directory = a:candidate.word
  else
      return
  endif

  call s:paste(directory, 'P', {})
endfunction"}}}

let s:kind.action_table.preview = {
      \ 'description' : 'preview word',
      \ 'is_quit' : 0,
      \ }
function! s:kind.action_table.preview.func(candidate) abort "{{{
  redraw
  echo s:get_candidate_text(a:candidate)
endfunction"}}}

let s:kind.action_table.echo = {
      \ 'description' : 'echo candidates for debug',
      \ 'is_selectable' : 1,
      \ }
function! s:kind.action_table.echo.func(candidates) abort "{{{
  echomsg string(a:candidates)
endfunction"}}}
"}}}

function! unite#kinds#common#insert_word(word, ...) abort "{{{
  let unite = unite#get_current_unite()
  let context = unite.context
  let opt = get(a:000, 0, {})
  let col = get(opt, 'col', context.col)

  let cur_text = col < 0 ? '' :
        \ matchstr(getline('.'), '^.*\%' . col . 'c.')

  let next_line = getline('.')[context.col-1 :]
  call setline(line('.'),
        \ split(cur_text . a:word . next_line,
        \            '\n\|\r\n'))
  let next_col = len(cur_text)+len(a:word)+1
  call cursor('', next_col)

  if next_col < col('$')
    startinsert
  else
    startinsert!
  endif
endfunction"}}}
function! s:paste(word, command, opt) abort "{{{
  let regtype = get(a:opt, 'regtype', 'v')

  " Paste.
  let old_reg = [getreg('"'), getregtype('"')]

  call setreg('"', a:word, regtype)
  try
    execute 'normal! ""' . a:command
  finally
    call setreg('"', old_reg[0], old_reg[1])
  endtry

  " Open folds.
  normal! zv
endfunction"}}}
function! s:get_candidate_text(candidate) abort "{{{
  return get(a:candidate, 'action__text', a:candidate.word)
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
