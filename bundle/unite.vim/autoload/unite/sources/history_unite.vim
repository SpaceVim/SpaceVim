"=============================================================================
" FILE: history_unite.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Variables  "{{{
let s:unite_histories = []

" the last modified time of the unite histories file.
let s:unite_histories_file_mtime = 0

call unite#util#set_default('g:unite_source_history_unite_file',
      \ unite#get_data_directory() . '/history_unite')

call unite#util#set_default('g:unite_source_history_unite_limit', 100)
"}}}

function! unite#sources#history_unite#add(unite) abort"{{{
  let s:unite_histories = filter(s:unite_histories,
        \ 'v:val.sources !=# a:unite.sources
        \  && v:val.context.input !=# a:unite.context.input')
        \[ : g:unite_source_history_unite_limit - 1]

  if !empty(filter(copy(a:unite.sources),
        \ "v:val.name ==# 'history/unite' || !v:val.is_listed"))
    " Don't save non listed source or history/unite
    return
  endif

  let context = deepcopy(a:unite.original_context)
  let context.input = a:unite.context.input
  call insert(s:unite_histories, {
        \ 'sources' : deepcopy(a:unite.sources),
        \ 'context' : context,
        \ 'source_args' :
        \    join(map(copy(a:unite.sources),
        \     'unite#view#_get_source_name_string(v:val)')),
        \ 'time' : localtime()
        \ })
endfunction"}}}

function! unite#sources#history_unite#define() abort
  return s:source
endfunction

let s:source = {
      \ 'name' : 'history/unite',
      \ 'description' : 'candidates from unite history',
      \ 'action_table' : {},
      \ 'default_action' : 'start',
      \}

function! s:source.gather_candidates(args, context) abort "{{{
  return map(copy(s:unite_histories), "{
        \ 'word' : v:val.source_args,
        \ 'abbr' : v:val.source_args . ' -- ' . v:val.context.input,
        \ 'source__history' : v:val,
        \}")
endfunction"}}}

" Actions "{{{
let s:source.action_table.start = {
      \ 'description' : 'start sources',
      \ 'is_start' : 1,
      \ }
function! s:source.action_table.start.func(candidate) abort "{{{
  let history = a:candidate.source__history
  let history.context.split = unite#get_context().split
  let history.context.no_split = 0
  call unite#start(history.sources, history.context)
endfunction"}}}
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
