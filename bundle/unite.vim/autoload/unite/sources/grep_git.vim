"=============================================================================
" FILE: grep_git.vim
" AUTHOR:  Alisue <lambdalisue at hashnote.net>
" License: MIT license
"=============================================================================

function! unite#sources#grep_git#define() abort "{{{
  return s:source
endfunction "}}}

function! unite#sources#grep_git#is_available() abort "{{{
  if !executable('git')
    return 0
  endif
  call unite#util#system('git rev-parse')
  return (unite#util#get_last_status() == 0) ? 1 : 0
endfunction "}}}
function! unite#sources#grep_git#repository_root() abort "{{{
  if !executable('git')
    return ''
  endif
  let stdout = unite#util#system('git rev-parse --show-toplevel')
  return (unite#util#get_last_status() == 0)
        \ ? substitute(stdout, '\v\r?\n$', '', '')
        \ : ''
endfunction "}}}

" Inherit from 'grep' source
let s:origin = unite#sources#grep#define()
let s:source = deepcopy(s:origin)
let s:source['name'] = 'grep/git'
let s:source['description'] = 'candidates from git grep'

function! s:source.gather_candidates(args, context) abort "{{{
  "
  " Note:
  "   Most of code in this function was copied from unite.vim
  "
  if !executable('git')
    call unite#print_source_message(
          \ 'command "git" is not executable.', s:source.name)
    let a:context.is_async = 0
    return []
  elseif !unite#sources#grep_git#is_available()
    call unite#print_source_message(
          \ 'the current working directory is not in a git repository.', s:source.name)
    let a:context.is_async = 0
    return []
  endif

  if !unite#util#has_vimproc()
    call unite#print_source_message(
          \ 'vimproc plugin is not installed.', self.name)
    let a:context.is_async = 0
    return []
  endif

  if empty(a:context.source__targets)
        \ || a:context.source__input == ''
    call unite#print_source_message('Canceled.', s:source.name)
    let a:context.is_async = 0
    return []
  endif

  " replace ^/ into the repository root
  let root = unite#sources#grep_git#repository_root()
  call map(a:context.source__targets, 'substitute(v:val, "^/", root . "/", "")')

  if a:context.is_redraw
    let a:context.is_async = 1
  endif

  let cmdline = printf('git grep -n --no-color %s -- %s %s',
    \   a:context.source__extra_opts,
    \   string(a:context.source__input),
    \   unite#helper#join_targets(a:context.source__targets),
    \)
  call unite#print_source_message('Command-line: ' . cmdline, s:source.name)

  " Note:
  "   --no-color is specified thus $TERM='dumb' is not required (actually git
  "   will blame if the $TERM value is not properly configured thus it should
  "   not be 'dumb').
  " 
  " Note:
  "   'git grep' does not work properly with PTY
  "
  let a:context.source__proc = vimproc#plineopen3(
        \ vimproc#util#iconv(cmdline, &encoding, 'char'), 0)

  return self.async_gather_candidates(a:args, a:context)
endfunction "}}}


" vim: foldmethod=marker
