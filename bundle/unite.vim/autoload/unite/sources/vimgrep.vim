"=============================================================================
" FILE: vimgrep.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

" Variables  "{{{
call unite#util#set_default(
      \ 'g:unite_source_vimgrep_search_word_highlight', 'Search')
"}}}

function! unite#sources#vimgrep#define() abort "{{{
  return s:source
endfunction "}}}

let s:source = {
      \ 'name': 'vimgrep',
      \ 'max_candidates': 1000,
      \ 'hooks' : {},
      \ 'syntax' : 'uniteSource__Vimgrep',
      \ 'matchers' : 'matcher_regexp',
      \ 'ignore_globs' : [
      \         '*~', '*.o', '*.exe', '*.bak',
      \         'DS_Store', '*.pyc', '*.sw[po]', '*.class',
      \         '.hg/**', '.git/**', '.bzr/**', '.svn/**',
      \ ],
      \ }

function! s:source.hooks.on_init(args, context) abort "{{{
  let args = unite#helper#parse_source_args(a:args)

  let target = get(args, 0, '')
  if target == ''
    let target = unite#helper#parse_source_path(
      \ unite#util#substitute_path_separator(
        \ unite#util#input('Target: ', '**', 'file')))
  endif

  if target == '%'
    let target = unite#util#substitute_path_separator(
          \ bufname(unite#get_current_unite().prev_bufnr))
  endif

  let a:context.source__targets = map(split(target, "\n"),
        \ "isdirectory(v:val) ? v:val . '/**' : v:val")

  let a:context.source__input = get(args, 1, '')
  if a:context.source__input == '' || a:context.unite__is_restart
    let a:context.source__input = unite#util#input('Pattern: ',
          \ a:context.source__input,
          \ 'customlist,unite#helper#complete_search_history')
  endif

  let a:context.source__directory =
        \ (len(a:context.source__targets) == 1) ?
        \ unite#util#substitute_path_separator(
        \  unite#util#expand(a:context.source__targets[0])) : ''
endfunction"}}}
function! s:source.hooks.on_syntax(args, context) abort "{{{
  syntax case ignore
  syntax region uniteSource__VimgrepLine
        \ start=' ' end='$'
        \ containedin=uniteSource__Vimgrep
  syntax match uniteSource__VimgrepFile /^[^:]*/ contained
        \ containedin=uniteSource__VimgrepLine
        \ nextgroup=uniteSource__VimgrepSeparator
  syntax match uniteSource__VimgrepSeparator /:/ contained
        \ containedin=uniteSource__VimgrepLine
        \ nextgroup=uniteSource__VimgrepLineNr
  syntax match uniteSource__VimgrepLineNr /\d\+\ze:/ contained
        \ containedin=uniteSource__VimgrepLine
        \ nextgroup=uniteSource__VimgrepPattern
  execute 'syntax match uniteSource__VimgrepPattern /'
        \ . substitute(a:context.source__input, '\([/\\]\)', '\\\1', 'g')
        \ . '/ contained containedin=uniteSource__VimgrepLine'
  highlight default link uniteSource__VimgrepFile Directory
  highlight default link uniteSource__VimgrepLineNr LineNR
  execute 'highlight default link uniteSource__VimgrepPattern'
        \ g:unite_source_vimgrep_search_word_highlight
endfunction"}}}
function! s:source.hooks.on_post_filter(args, context) abort "{{{
  for candidate in a:context.candidates
    let candidate.kind = ['file', 'jump_list']
    let candidate.action__col_pattern = a:context.source__input
    let candidate.is_multiline = 1
  endfor
endfunction"}}}

function! s:source.gather_candidates(args, context) abort "{{{
  if empty(a:context.source__targets)
        \ || a:context.source__input == ''
    return []
  endif

  let cmdline = printf('silent vimgrep /%s/j %s',
    \   escape(a:context.source__input, '/'),
    \   join(map(copy(a:context.source__targets), 'escape(v:val, " ")')))

  call unite#print_source_message(
        \ 'Command-line: ' . cmdline, s:source.name)

  let buffers = range(1, bufnr('$'))

  let _ = []
  try
    execute cmdline
    let qflist = getqflist()

    let cwd = getcwd()
    call unite#util#lcd(a:context.source__directory)

    for qf in filter(qflist,
          \ "v:val.bufnr != '' && bufname(v:val.bufnr) != ''")
      let dict = {
            \   'action__path' : unite#util#substitute_path_separator(
            \       fnamemodify(bufname(qf.bufnr), ':p')),
            \   'action__text' : qf.text,
            \   'action__line' : qf.lnum,
            \ }
      let dict.word = printf('%s:%s:%s',
            \  unite#util#substitute_path_separator(
            \     fnamemodify(dict.action__path, ':.')),
            \ dict.action__line, dict.action__text)

      call add(_, dict)
    endfor

    if isdirectory(a:context.source__directory)
      call unite#util#lcd(cwd)
    endif
  catch /^Vim\%((\a\+)\)\?:E480/
    " Ignore.
    return []
  finally
    " Delete unlisted buffers.
    for bufnr in filter(range(1, bufnr('$')),
          \ '!buflisted(v:val) && bufexists(v:val)
          \   && index(buffers, v:val) < 0')
      silent! execute 'bwipeout' bufnr
    endfor

    " Clear qflist.
    call setqflist([])

    cclose
  endtry

  return _
endfunction "}}}

function! s:source.complete(args, context, arglead, cmdline, cursorpos) abort "{{{
  return unite#sources#file#complete_directory(
        \ a:args, a:context, a:arglead, a:cmdline, a:cursorpos)
endfunction"}}}

" vim: foldmethod=marker
