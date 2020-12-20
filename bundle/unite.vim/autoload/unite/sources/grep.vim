"=============================================================================
" FILE: grep.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
"          Tomohiro Nishimura <tomohiro68 at gmail.com>
" License: MIT license
"=============================================================================

" Variables  "{{{
" Set from grepprg.
call unite#util#set_default(
      \ 'g:unite_source_grep_command', 'grep')
call unite#util#set_default(
      \ 'g:unite_source_grep_default_opts', '-inH')
call unite#util#set_default('g:unite_source_grep_recursive_opt', '-r')
call unite#util#set_default('g:unite_source_grep_search_word_highlight',
      \ 'Search')
call unite#util#set_default('g:unite_source_grep_encoding', 'char')
" Note: jvgrep does not support "--" separator
call unite#util#set_default('g:unite_source_grep_separator',
      \ (g:unite_source_grep_command !=# 'jvgrep' ? '--' : ''))
"}}}

function! unite#sources#grep#define() abort "{{{
  return s:source
endfunction "}}}

let s:source = {
      \ 'name': 'grep',
      \ 'max_candidates': 1000,
      \ 'hooks' : {},
      \ 'syntax' : 'uniteSource__Grep',
      \ 'matchers' : 'matcher_regexp',
      \ 'sorters' : 'sorter_nothing',
      \ 'ignore_globs' : [
      \         '*~', '*.o', '*.exe', '*.bak',
      \         'DS_Store', '*.pyc', '*.sw[po]', '*.class',
      \         '.hg/**', '.git/**', '.bzr/**', '.svn/**',
      \         'tags', 'tags-*'
      \ ],
      \ }

function! s:source.hooks.on_init(args, context) abort "{{{
  if !unite#util#has_vimproc()
    call unite#print_source_error(
          \ 'vimproc is not installed.', s:source.name)
    return
  endif

  let target = get(a:args, 0, '')

  if target ==# ''
    let target = isdirectory(a:context.path) ?
      \ a:context.path :
      \ unite#util#input('Target: ', '.', 'file')
  endif

  let target = unite#util#expand(target)

  if target ==# ''
    let a:context.source__targets = []
    let a:context.source__input = ''
    return
  endif

  let targets = split(target, "\n")
  if target ==# '%' || target ==# '#'
    let targets = [bufname(target)]
  elseif target ==# '$buffers'
    let targets = map(filter(range(1, bufnr('$')),
          \ 'buflisted(v:val) && filereadable(bufname(v:val))'),
          \ 'bufname(v:val)')
  elseif target ==# '**'
    " Optimized.
    let targets = ['.']
  endif

  let targets = map(targets, 'substitute(v:val, "\\*\\+$", "", "")')
  let a:context.source__targets =
        \ map(targets, 'unite#helper#parse_source_path(v:val)')

  let a:context.source__extra_opts = get(a:args, 1, '')

  let a:context.source__input = get(a:args, 2, a:context.input)
  if a:context.source__input == '' || a:context.unite__is_restart
    let a:context.source__input = unite#util#input('Pattern: ',
          \ a:context.source__input,
          \ 'customlist,unite#helper#complete_search_history')
  endif

  call unite#print_source_message('Pattern: '
        \ . a:context.source__input, s:source.name)

  let a:context.source__directory =
        \ (len(a:context.source__targets) == 1) ?
        \ unite#util#substitute_path_separator(
        \  unite#util#expand(a:context.source__targets[0])) : ''
endfunction"}}}
function! s:source.hooks.on_syntax(args, context) abort "{{{
  if !unite#util#has_vimproc()
    return
  endif

  syntax case ignore
  syntax match uniteSource__GrepHeader /[^:]*: \d\+: \(\d\+: \)\?/ contained
        \ containedin=uniteSource__Grep
  syntax match uniteSource__GrepFile /[^:]*: / contained
        \ containedin=uniteSource__GrepHeader
        \ nextgroup=uniteSource__GrepLineNR
  syntax match uniteSource__GrepLineNR /\d\+: / contained
        \ containedin=uniteSource__GrepHeader
        \ nextgroup=uniteSource__GrepPattern
  execute 'syntax match uniteSource__GrepPattern /'
        \ . substitute(a:context.source__input, '\([/\\]\)', '\\\1', 'g')
        \ . '/ contained containedin=uniteSource__Grep'
  syntax match uniteSource__GrepSeparator /:/ contained conceal
        \ containedin=uniteSource__GrepFile,uniteSource__GrepLineNR
  highlight default link uniteSource__GrepFile Comment
  highlight default link uniteSource__GrepLineNr LineNR
  execute 'highlight default link uniteSource__GrepPattern'
        \ get(a:context, 'custom_grep_search_word_highlight',
        \ g:unite_source_grep_search_word_highlight)
endfunction"}}}
function! s:source.hooks.on_close(args, context) abort "{{{
  if has_key(a:context, 'source__proc')
    call a:context.source__proc.kill()
  endif
endfunction "}}}
function! s:source.hooks.on_post_filter(args, context) abort "{{{
  for candidate in a:context.candidates
    let candidate.kind = ['file', 'jump_list']
    let candidate.action__col_pattern = a:context.source__input
    let candidate.is_multiline = 1
    let candidate.action__line = candidate.source__info[1]
    let candidate.action__text = candidate.source__info[2]
  endfor
endfunction"}}}

function! s:source.gather_candidates(args, context) abort "{{{
  let command = get(a:context, 'custom_grep_command',
        \ g:unite_source_grep_command)
  let default_opts = get(a:context, 'custom_grep_default_opts',
        \ g:unite_source_grep_default_opts)
  let recursive_opt = get(a:context, 'custom_grep_recursive_opt',
        \ g:unite_source_grep_recursive_opt)

  if !executable(command)
    call unite#print_source_message(printf(
          \ 'command "%s" is not executable.', command), s:source.name)
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

  if a:context.is_redraw
    let a:context.is_async = 1
  endif

  let cmdline = printf('"%s" %s %s %s %s %s %s',
    \   unite#util#substitute_path_separator(command),
    \   default_opts,
    \   recursive_opt,
    \   a:context.source__extra_opts,
    \   g:unite_source_grep_separator,
    \   string(a:context.source__input),
    \   unite#helper#join_targets(a:context.source__targets)
    \)

  call unite#add_source_message('Command-line: ' . cmdline, s:source.name)

  let save_term = $TERM
  try
    " Disable colors.
    let $TERM = 'dumb'

    let a:context.source__proc = vimproc#plineopen3(
          \ vimproc#util#iconv(cmdline, &encoding,
          \ g:unite_source_grep_encoding),
          \ unite#helper#is_pty(command))
  finally
    let $TERM = save_term
  endtry

  return self.async_gather_candidates(a:args, a:context)
endfunction "}}}

function! s:source.async_gather_candidates(args, context) abort "{{{
  if !has_key(a:context, 'source__proc')
    let a:context.is_async = 0
    return []
  endif

  let stderr = a:context.source__proc.stderr
  if !stderr.eof
    " Print error.
    let errors = filter(unite#util#read_lines(stderr, 200),
          \ "v:val !~ '^\\s*$'")
    if !empty(errors)
      call unite#print_source_error(errors, s:source.name)
    endif
  endif

  let stdout = a:context.source__proc.stdout
  if stdout.eof
    " Disable async.
    let a:context.is_async = 0
    call a:context.source__proc.waitpid()
  endif

  let lines = map(unite#util#read_lines(stdout, 1000),
          \ "unite#util#iconv(v:val, g:unite_source_grep_encoding, &encoding)")

  let candidates = []
  for line in lines
    let ret = unite#sources#grep#parse(line)
    if empty(ret)
      call unite#print_source_error(
            \ 'Invalid grep line: ' . line,  s:source.name)
      continue
    endif

    let [path, linenr, col, text] = ret

    call add(candidates, {
          \ 'word' : printf('%s: %s: %s', path,
          \                 linenr . (col != 0 ? ': '.col : ''), text),
          \ 'action__path' :
          \ unite#util#substitute_path_separator(
          \   fnamemodify(path, ':p')),
          \ 'action__col' : col,
          \ 'source__info' : [path, linenr, text]
          \ })
  endfor

  return candidates
endfunction "}}}

function! s:source.complete(args, context, arglead, cmdline, cursorpos) abort "{{{
  return ['%', '#', '$buffers'] + unite#sources#file#complete_directory(
        \ a:args, a:context, a:arglead, a:cmdline, a:cursorpos)
endfunction"}}}

function! unite#sources#grep#parse(line) abort "{{{
  let ret = matchlist(a:line,
        \ '^\(\%([a-zA-Z]:\)\?[^:]*\):\(\d\+\)\%(:\(\d\+\)\)\?:\(.*\)$')
  if empty(ret) || ret[1] == '' || ret[4] == ''
    return []
  endif

  if ret[1] =~ ':\d\+$'
    " Use column pattern
    let ret = matchlist(a:line, '^\(.*\):\(\d\+\):\(\d\+\):\(.*\)$')
  endif

  let path = ret[1]
  let linenr = ret[2]
  let col = ret[3]
  let text = ret[4]

  if linenr == ''
    let linenr = '1'
  endif
  if col == ''
    let col = '0'
  endif

  return [path, linenr, col, text]
endfunction"}}}

" vim: foldmethod=marker
