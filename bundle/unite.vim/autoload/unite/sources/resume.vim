"=============================================================================
" FILE: resume.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#resume#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'resume',
      \ 'description' : 'candidates from resume list',
      \ 'default_kind' : 'command',
      \}

function! s:source.gather_candidates(args, context) abort "{{{
  let a:context.source__unite_list = map(filter(range(1, bufnr('$')), "
        \ getbufvar(v:val, '&filetype') ==# 'unite'
        \  && getbufvar(v:val, 'unite').sources[0].name != 'resume'"),
        \ "getbufvar(v:val, 'unite')")
  let unite = unite#get_current_unite()

  let new_context = copy(unite.original_context)
  " Disable the input
  call remove(new_context, 'input')

  let max_width = max(map(copy(a:context.source__unite_list),
        \ 'len(v:val.buffer_name)'))
  let candidates = map(copy(a:context.source__unite_list), "{
        \ 'word' : v:val.buffer_name,
        \ 'abbr' : printf('%-'.max_width.'s | '
        \          . join(map(filter(copy(v:val.args),
        \           'type(v:val) == type([])'),
        \           'len(v:val[1]) == 0 ? v:val[0] :
        \            v:val[0].'':''.join(filter(copy(v:val[1]),
        \            ''type(v:val) == 1''), '':'')')),
        \            v:val.buffer_name),
        \ 'action__command' : printf('call unite#resume(%s, %s)',
        \              string(v:val.buffer_name),
        \              string(new_context)),
        \ 'source__time' : v:val.access_time,
        \}")

  return sort(candidates, 's:compare')
endfunction"}}}

" Misc.
function! s:compare(candidate_a, candidate_b) abort "{{{
  return a:candidate_b.source__time - a:candidate_a.source__time
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
