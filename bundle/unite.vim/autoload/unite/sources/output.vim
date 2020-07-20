"=============================================================================
" FILE: output.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Variables  "{{{
"}}}

function! unite#sources#output#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'output',
      \ 'description' : 'candidates from Vim command output',
      \ 'default_action' : 'yank',
      \ 'default_kind' : 'word',
      \ 'syntax' : 'uniteSource__Output',
      \ 'hooks' : {},
      \ }

function! s:source.hooks.on_init(args, context) abort "{{{
  if type(get(a:args, 0, '')) == type([])
    " Use args directly.
    let a:context.source__is_dummy = 0
    return
  endif

  let command = join(filter(copy(a:args), "v:val !=# '!'"), ' ')
  if command == ''
    let command = unite#util#input(
          \ 'Please input Vim command: ', '', 'command')
    redraw
  endif
  let a:context.source__command = command
  let a:context.source__is_dummy =
        \ (get(a:args, -1, '') ==# '!')

  if !a:context.source__is_dummy
    call unite#print_source_message('command: ' . command, s:source.name)
  endif
endfunction"}}}
function! s:source.hooks.on_syntax(args, context) abort "{{{
  let save_current_syntax = get(b:, 'current_syntax', '')
  unlet! b:current_syntax

  try
    silent! syntax include @Vim syntax/vim.vim
    syntax region uniteSource__OutputVim
          \ start=' ' end='$' contains=@Vim containedin=uniteSource__Output
  finally
    let b:current_syntax = save_current_syntax
  endtry
endfunction"}}}
function! s:source.gather_candidates(args, context) abort "{{{
  if type(get(a:args, 0, '')) == type([])
    " Use args directly.
    let result = a:args[0]
  else
    let output = unite#util#redir(a:context.source__command)

    let result = split(output, '\r\n\|\n')
  endif

  return map(result, "{
        \ 'word' : v:val,
        \ 'is_multiline' : 1,
        \ 'is_dummy' : a:context.source__is_dummy,
        \ }")
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
