let s:save_cpo = &cpo
set cpo&vim


let s:kind = {
      \ 'name': 'vim_bookmarks',
      \ 'parents': ['jump_list'],
      \ 'default_action': 'open',
      \ 'action_table': {
      \   'delete': {
      \     'description': 'delete the selected bookmarks',
      \     'is_selectable': 1,
      \     'is_quit': 0,
      \   },
      \   'yank': {
      \     'description': 'yank path and content of the selected bookmarks',
      \     'is_selectable': 1,
      \   },
      \   'yank_path': {
      \     'description': 'yank path of the selected bookmarks',
      \     'is_selectable': 1,
      \   },
      \   'yank_content': {
      \     'description': 'yank content of the selected bookmarks',
      \     'is_selectable': 1,
      \   },
      \   'yank_annotation': {
      \     'description': 'yank annotation of the selected bookmarks',
      \     'is_selectable': 1,
      \   },
      \}}
function! s:yank(text)
  let @" = a:text
  echo 'Yanked: ' . a:text

  if has('clipboard')
    call setreg(v:register, a:text)
  endif
endfunction

function! s:kind.action_table.delete.func(candidates) " {{{
  for candidate in a:candidates
    call bm_sign#del(
          \ candidate.action__path,
          \ candidate.action__bookmark.sign_idx,
          \)
    call bm#del_bookmark_at_line(
          \ candidate.action__path,
          \ candidate.action__line,
          \)
  endfor
  call unite#force_redraw()
endfunction " }}}
function! s:kind.action_table.yank.func(candidates) " {{{
  let text = join(map(copy(a:candidates),
        \ 'v:val.word'), "\n")
  call s:yank(text)
endfunction " }}}
function! s:kind.action_table.yank_path.func(candidates) " {{{
  let text = join(map(copy(a:candidates),
        \ 'v:val.action__path'), "\n")
  call s:yank(text)
endfunction " }}}
function! s:kind.action_table.yank_content.func(candidates) " {{{
  let text = join(map(copy(a:candidates),
        \ 'v:val.action__bookmark.content'), "\n")
  call s:yank(text)
endfunction " }}}
function! s:kind.action_table.yank_annotation.func(candidates) " {{{
  let text = join(map(copy(a:candidates),
        \ 'v:val.action__bookmark.annotation'), "\n")
  call s:yank(text)
endfunction " }}}

function! unite#kinds#vim_bookmarks#define()
  return s:kind
endfunction
call unite#define_kind(s:kind)    " required for reloading

let &cpo = s:save_cpo
unlet s:save_cpo
"vim: sts=2 sw=2 smarttab et ai textwidth=0 fdm=marker
