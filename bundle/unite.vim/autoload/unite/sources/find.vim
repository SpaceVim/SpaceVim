"=============================================================================
" FILE: find.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

" Variables  "{{{
call unite#util#set_default('g:unite_source_find_command', 'find')
call unite#util#set_default('g:unite_source_find_default_opts', '')
call unite#util#set_default('g:unite_source_find_default_expr', '-name ')
"}}}

function! unite#sources#find#define() abort "{{{
  return executable(g:unite_source_find_command) && unite#util#has_vimproc() ?
        \ s:source : []
endfunction "}}}

let s:source = {
      \ 'name': 'find',
      \ 'max_candidates': 1000,
      \ 'hooks' : {},
      \ 'matchers' : ['matcher_regexp'],
      \ 'ignore_globs' : [
      \         '*~', '*.o', '*.exe', '*.bak',
      \         'DS_Store', '*.pyc', '*.sw[po]', '*.class',
      \         '.hg/**', '.git/**', '.bzr/**', '.svn/**',
      \ ],
      \ }

function! s:source.hooks.on_init(args, context) abort "{{{
  let target = get(a:args, 0, '')
  if target == ''
    let target = isdirectory(a:context.path) ?
      \ a:context.path :
      \ unite#helper#parse_source_path(
        \ unite#util#input('Target: ', '.', 'dir'))
  endif

  let target = unite#util#expand(target)

  let a:context.source__targets = split(target, "\n")
  let a:context.source__input = get(a:args, 1, a:context.input)
  if a:context.source__input == ''
    redraw
    echo "Please input command-line(quote is needed) Ex: -name '*.vim'"
    let a:context.source__input = unite#util#input(
          \ printf('"%s" %s %s ',
          \   g:unite_source_find_command,
          \   g:unite_source_find_default_opts,
          \   unite#helper#join_targets(a:context.source__targets)),
          \   g:unite_source_find_default_expr)
  endif
endfunction"}}}
function! s:source.hooks.on_close(args, context) abort "{{{
  if has_key(a:context, 'source__proc')
    call a:context.source__proc.waitpid()
  endif
endfunction "}}}

function! s:source.gather_candidates(args, context) abort "{{{
  if empty(a:context.source__targets)
        \ || a:context.source__input == ''
    let a:context.is_async = 0
    return []
  endif

  if unite#util#is_windows() &&
        \ vimproc#get_command_name(g:unite_source_find_command)
        \     =~? '/Windows/system.*/find\.exe$'
    call unite#print_source_message(
          \ 'Detected windows find command.', s:source.name)
    let a:context.is_async = 0
    return []
  endif

  if a:context.is_redraw
    let a:context.is_async = 1
  endif

  let cmdline = printf('"%s" %s %s %s',
        \ g:unite_source_find_command, g:unite_source_find_default_opts,
        \ unite#helper#join_targets(a:context.source__targets),
        \ a:context.source__input)
  call unite#print_source_message('Command-line: ' . cmdline, s:source.name)
  let a:context.source__proc = vimproc#popen3(
        \ vimproc#util#iconv(cmdline, &encoding, 'char'))

  " Close handles.
  call a:context.source__proc.stdin.close()
  call a:context.source__proc.stderr.close()

  return []
endfunction "}}}

function! s:source.async_gather_candidates(args, context) abort "{{{
  let stdout = a:context.source__proc.stdout
  if stdout.eof
    " Disable async.
    let a:context.is_async = 0
  endif

  let candidates = map(filter(
        \ stdout.read_lines(-1, 1000), "v:val !~ '^\\s*$'"),
        \ "fnamemodify(unite#util#iconv(v:val, 'char', &encoding), ':p')")

  let cwd = getcwd()
  call unite#util#lcd(a:context.source__targets[0])

  call map(candidates, "{
    \   'word' : unite#util#substitute_path_separator(v:val),
    \   'kind' : (isdirectory(v:val) ? 'directory' : 'file'),
    \   'action__path' : unite#util#substitute_path_separator(v:val),
    \ }")

  call unite#util#lcd(cwd)

  return candidates
endfunction "}}}

function! s:source.complete(args, context, arglead, cmdline, cursorpos) abort "{{{
  return unite#sources#file#complete_directory(
        \ a:args, a:context, a:arglead, a:cmdline, a:cursorpos)
endfunction"}}}

" vim: foldmethod=marker
