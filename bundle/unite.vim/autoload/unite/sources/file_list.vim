"=============================================================================
" FILE: file_list.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Variables  "{{{
"}}}

function! unite#sources#file_list#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'file_list',
      \ 'description' : 'candidates from filelist',
      \ 'default_kind' : 'file',
      \ }

function! s:source.complete(args, context, arglead, cmdline, cursorpos) abort "{{{
  return unite#sources#file#complete_file(
        \ a:args, a:context, a:arglead, a:cmdline, a:cursorpos)
endfunction"}}}

function! s:source.gather_candidates(args, context) abort "{{{
  let args = unite#helper#parse_source_args(a:args)

  if empty(args)
    call unite#print_source_error(
          \ 'filelist path is needed.', s:source.name)
    return []
  endif

  let file_list = args[0]

  if !filereadable(file_list)
    call unite#print_source_error(
          \ 'filelist open failed.', s:source.name)
    return []
  endif

  let cwd = getcwd()
  try
    call unite#util#lcd(fnamemodify(file_list, ':h'))

    let candidates = map(readfile(file_list), "{
        \ 'word' : v:val,
        \ 'action__path' : fnamemodify(v:val, ':p'),
        \}")
  finally
    call unite#util#lcd(cwd)
  endtry

  return candidates
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
