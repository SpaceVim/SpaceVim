"=============================================================================
" FILE: cdable.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Variables {{{
call unite#util#set_default('g:unite_kind_cdable_cd_command',
      \ 'cd', 'g:unite_kind_openable_cd_command')
call unite#util#set_default('g:unite_kind_cdable_lcd_command',
      \ 'lcd', 'g:unite_kind_openable_lcd_command')
" }}}
function! unite#kinds#cdable#define() abort "{{{
  return s:kind
endfunction"}}}

let s:kind = {
      \ 'name' : 'cdable',
      \ 'action_table' : {},
      \ 'alias_table' : { 'edit' : 'narrow' },
      \ 'parents' : [],
      \}

" Actions "{{{
let s:kind.action_table.cd = {
      \ 'description' : 'change current directory',
      \ }
function! s:kind.action_table.cd.func(candidate) abort "{{{
  let directory = unite#helper#get_candidate_directory(a:candidate)
  if !s:check_is_directory(directory)
    return
  endif

  if &filetype ==# 'vimfiler' || &filetype ==# 'vimshell'
    call s:external_cd(a:candidate)
  else
    execute g:unite_kind_cdable_cd_command fnameescape(directory)
  endif
endfunction"}}}

let s:kind.action_table.lcd = {
      \ 'description' : 'change window local current directory',
      \ }
function! s:kind.action_table.lcd.func(candidate) abort "{{{
  let directory = unite#helper#get_candidate_directory(a:candidate)
  if !s:check_is_directory(directory)
    return
  endif

  if &filetype ==# 'vimfiler' || &filetype ==# 'vimshell'
    call s:external_cd(a:candidate)
  else
    execute g:unite_kind_cdable_lcd_command fnameescape(directory)
  endif
endfunction"}}}

let s:kind.action_table.project_cd = {
      \ 'description' : 'change current directory to project directory',
      \ }
function! s:kind.action_table.project_cd.func(candidate) abort "{{{
  let directory = unite#helper#get_candidate_directory(a:candidate)
  if !s:check_is_directory(directory)
    return
  endif

  let directory = unite#util#path2project_directory(directory)

  if isdirectory(directory)
    let candidate = copy(a:candidate)
    let candidate.action__directory = directory
    call s:kind.action_table.cd.func(candidate)
  endif
endfunction"}}}

let s:kind.action_table.tabnew_cd = {
      \ 'description' : 'open a new tab page here',
      \ 'is_tab' : 1,
      \ }
function! s:kind.action_table.tabnew_cd.func(candidate) abort "{{{
  let directory = unite#helper#get_candidate_directory(a:candidate)
  if !s:check_is_directory(directory)
    return
  endif

  if &filetype ==# 'vimfiler' || &filetype ==# 'vimshell'
    tabnew | call s:external_cd(a:candidate)
  else
    tabnew | execute g:unite_kind_cdable_cd_command fnameescape(directory)
  endif
endfunction"}}}

let s:kind.action_table.tabnew_lcd = {
      \ 'description' : 'open a new tab page here with lcd',
      \ 'is_tab' : 1,
      \ }
function! s:kind.action_table.tabnew_lcd.func(candidate) abort "{{{
  let directory = unite#helper#get_candidate_directory(a:candidate)
  if !s:check_is_directory(directory)
    return
  endif

  if &filetype ==# 'vimfiler' || &filetype ==# 'vimshell'
    tabnew | call s:external_cd(a:candidate)
  else
    tabnew | execute g:unite_kind_cdable_lcd_command fnameescape(directory)
  endif
endfunction"}}}

let s:kind.action_table.narrow = {
      \ 'description' : 'narrowing candidates by directory name',
      \ 'is_quit' : 0,
      \ 'is_start' : 1,
      \ }
function! s:kind.action_table.narrow.func(candidate) abort "{{{
  let directory = unite#helper#get_candidate_directory(a:candidate)
  if !s:check_is_directory(directory)
    return
  endif

  call unite#start_temporary([['file'], ['file/new'], ['directory/new']],
        \ {'path' : directory})
endfunction"}}}

let s:kind.action_table.vimshell = {
      \ 'description' : 'open vimshell buffer here',
      \ }
function! s:kind.action_table.vimshell.func(candidate) abort "{{{
  if !exists(':VimShell')
    echo 'vimshell is not installed.'
    return
  endif
  let directory = unite#helper#get_candidate_directory(a:candidate)
  if !s:check_is_directory(directory)
    return
  endif

  execute 'VimShell' escape(directory, '\ ')
endfunction"}}}

let s:kind.action_table.tabvimshell = {
      \ 'description' : 'tabopen vimshell buffer here',
      \ 'is_tab' : 1,
      \ }
function! s:kind.action_table.tabvimshell.func(candidate) abort "{{{
  if !exists(':VimShellTab')
    echo 'vimshell is not installed.'
    return
  endif

  let directory = unite#helper#get_candidate_directory(a:candidate)
  if !s:check_is_directory(directory)
    return
  endif

  execute 'VimShellTab' escape(directory, '\ ')
endfunction"}}}

let s:kind.action_table.vimfiler = {
      \ 'description' : 'open vimfiler buffer here',
      \ }
function! s:kind.action_table.vimfiler.func(candidate) abort "{{{
  if !exists(':VimFiler')
    echo 'vimfiler is not installed.'
    return
  endif

  let directory = unite#helper#get_candidate_directory(a:candidate)
  if !s:check_is_directory(directory)
    return
  endif

  execute 'VimFiler' escape(directory, '\ ')

  if has_key(a:candidate, 'action__path')
        \ && directory !=# a:candidate.action__path
    " Move cursor.
    call vimfiler#mappings#search_cursor(a:candidate.action__path)
    call s:move_vimfiler_cursor(a:candidate)
  endif
endfunction"}}}

let s:kind.action_table.tabvimfiler = {
      \ 'description' : 'tabopen vimfiler buffer here',
      \ 'is_tab' : 1,
      \ }
function! s:kind.action_table.tabvimfiler.func(candidate) abort "{{{
  if !exists(':VimFilerTab')
    echo 'vimfiler is not installed.'
    return
  endif

  let directory = unite#helper#get_candidate_directory(a:candidate)
  if !s:check_is_directory(directory)
    return
  endif

  execute 'VimFilerTab' escape(directory, '\ ')

  if has_key(a:candidate, 'action__path')
        \ && directory !=# a:candidate.action__path
    " Move cursor.
    call vimfiler#mappings#search_cursor(a:candidate.action__path)
    call s:move_vimfiler_cursor(a:candidate)
  endif
endfunction"}}}

" For rec. "{{{
let s:cdable_action_rec = {
      \ 'description' : 'open this directory by file_rec source',
      \ 'is_start' : 1,
      \}

function! s:cdable_action_rec.func(candidate) abort
  call unite#start_script([['file_rec',
        \ unite#helper#get_candidate_directory(a:candidate)]])
endfunction

let s:cdable_action_rec_parent = {
      \ 'description' : 'open parent directory by file_rec source',
      \ 'is_start' : 1,
      \}

function! s:cdable_action_rec_parent.func(candidate) abort
  call unite#start_script([['file_rec', unite#util#substitute_path_separator(
        \ fnamemodify(unite#helper#get_candidate_directory(a:candidate), ':h'))
        \ ]])
endfunction

let s:cdable_action_rec_project = {
      \ 'description' : 'open project directory by file_rec source',
      \ 'is_start' : 1,
      \}

function! s:cdable_action_rec_project.func(candidate) abort
  call unite#start_script([['file_rec', unite#util#substitute_path_separator(
        \ unite#util#path2project_directory(
        \   unite#helper#get_candidate_directory(a:candidate)))
        \ ]])
endfunction

let s:cdable_action_rec_async = {
      \ 'description' : 'open this directory by file_rec/async source',
      \ 'is_start' : 1,
      \}

function! s:cdable_action_rec_async.func(candidate) abort
  call unite#start_script([['file_rec/async',
        \ unite#helper#get_candidate_directory(a:candidate)]])
endfunction

let s:cdable_action_rec_parent_async = {
      \ 'description' : 'open parent directory by file_rec/async source',
      \ 'is_start' : 1,
      \}

function! s:cdable_action_rec_parent_async.func(candidate) abort
  call unite#start_script([['file_rec/async', unite#util#substitute_path_separator(
        \ fnamemodify(unite#helper#get_candidate_directory(a:candidate), ':h'))
        \ ]])
endfunction

let s:cdable_action_rec_project_async = {
      \ 'description' : 'open project directory by file_rec/async source',
      \ 'is_start' : 1,
      \}

function! s:cdable_action_rec_project_async.func(candidate) abort
  call unite#start_script([['file_rec/async', unite#util#substitute_path_separator(
        \ unite#util#path2project_directory(
        \   unite#helper#get_candidate_directory(a:candidate)))
        \ ]])
endfunction

let s:kind.action_table['rec'] =
      \ s:cdable_action_rec
let s:kind.action_table['rec_parent'] =
      \ s:cdable_action_rec_parent
let s:kind.action_table['rec_project'] =
      \ s:cdable_action_rec_project
let s:kind.action_table['rec/async'] =
      \ s:cdable_action_rec_async
let s:kind.action_table['rec_parent/async'] =
      \ s:cdable_action_rec_parent_async
let s:kind.action_table['rec_project/async'] =
      \ s:cdable_action_rec_project_async
unlet! s:cdable_action_rec
unlet! s:cdable_action_rec_async
unlet! s:cdable_action_rec_project
unlet! s:cdable_action_rec_project_async
unlet! s:cdable_action_rec_parent
unlet! s:cdable_action_rec_parent_async
"}}}


function! s:external_cd(candidate) abort "{{{
  let directory = unite#helper#get_candidate_directory(a:candidate)
  if &filetype ==# 'vimfiler'
    call vimfiler#mappings#cd(directory)
    call s:move_vimfiler_cursor(a:candidate)
  elseif &filetype ==# 'vimshell'
    execute 'VimShell' escape(directory, '\\ ')
  endif
endfunction"}}}
function! s:move_vimfiler_cursor(candidate) abort "{{{
  if &filetype !=# 'vimfiler'
    return
  endif

  if has_key(a:candidate, 'action__path')
        \ && a:candidate.action__path !=#
        \     unite#helper#get_candidate_directory(a:candidate)
    " Move cursor.
    call vimfiler#mappings#search_cursor(a:candidate.action__path)
  endif
endfunction"}}}

function! s:check_is_directory(directory) abort
  if !isdirectory(a:directory)
    if unite#util#is_sudo()
      return 0
    endif

    let yesno = input(printf(
          \ 'Directory path "%s" does not exist. Create? : ', a:directory))
    redraw
    if yesno !~ '^y\%[es]$'
      echo 'Canceled.'
      return 0
    endif

    call mkdir(a:directory, 'p')
  endif

  return 1
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
