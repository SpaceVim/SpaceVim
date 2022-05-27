"=============================================================================
" FILE: history_yank.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

function! unite#sources#history_yank#define() abort
  return s:source
endfunction

let s:source = {
      \ 'name' : 'history/yank',
      \ 'description' : 'candidates from yank history',
      \ 'action_table' : {},
      \ 'default_kind' : 'word',
      \}

function! s:source.gather_candidates(args, context) abort
  let registers = split(get(a:args, 0,
        \ neoyank#default_register_from_clipboard()), '\zs')

  call neoyank#update()

  let candidates = []
  for register in registers
    let candidates += map(copy(get(
          \ neoyank#_get_yank_histories(), register, [])), "{
          \   'word' : v:val[0],
          \   'abbr' : printf('%-2d - %s', v:key,
          \                   substitute(v:val[0], '\n', '&     ', 'g')),
          \   'is_multiline' : 1,
          \   'action__regtype' : v:val[1],
          \   }")
  endfor

  return candidates
endfunction

" Actions
let s:source.action_table.delete = {
      \ 'description' : 'delete from yank history',
      \ 'is_invalidate_cache' : 1,
      \ 'is_quit' : 0,
      \ 'is_selectable' : 1,
      \ }
function! s:source.action_table.delete.func(candidates) abort
  for candidate in a:candidates
    call filter(neoyank#_get_yank_histories(),
          \ 'v:val[0] !=# candidate.word')
  endfor

  call neoyank#update()
endfunction
