"=============================================================================
" FILE: jump.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Variables  "{{{
"}}}

function! unite#sources#jump#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'jump',
      \ 'description' : 'candidates from jumps',
      \ 'default_kind' : 'jump_list',
      \ }

let s:cached_result = []
function! s:source.gather_candidates(args, context) abort "{{{
  " Get jumps list.
  let result = []
  for jump in split(unite#util#redir('jumps'), '\n')[1:]
    let list = split(jump)
    if len(list) < 4
      continue
    endif

    let [linenr, col, file_text] = [list[1], list[2]+1, join(list[3:])]
    let lines = getbufline(file_text, linenr)
    let path = file_text
    let bufnr = bufnr(file_text)
    if empty(lines)
      if stridx(join(split(getline(linenr))), file_text) == 0
        let lines = [file_text]
        let path = bufname('%')
        let bufnr = bufnr('%')
      elseif filereadable(path)
        let bufnr = 0
        let lines = ['buffer unloaded']
      else
        " Skip.
        continue
      endif
    endif

    if getbufvar(bufnr, '&filetype') ==# 'unite'
      " Skip unite buffer.
      continue
    endif

    call add(result, [linenr, col, file_text, path, bufnr, lines])
  endfor

  let max_path = max(map(copy(result),
        \ 'len(printf("%s:%d-%d", v:val[3], v:val[0], v:val[1]))')) + 1
  let _ = []
  for [linenr, col, file_text, path, bufnr, lines] in result
    let text = substitute(get(lines, 0, ''), '^\s\+', '', '')

    let dict = {
          \ 'word' : unite#util#truncate(
          \     printf('%s:%d-%d  ', path, linenr, col), max_path) . text,
          \ 'action__path' : unite#util#substitute_path_separator(
          \     fnamemodify(unite#util#expand(path), ':p')),
          \ 'action__line' : linenr,
          \ 'action__col' : col,
          \ }

    if bufnr > 0
      let dict.action__buffer_nr = bufnr
    endif

    call add(_, dict)
  endfor

  return reverse(_)
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
