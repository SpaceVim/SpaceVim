"=============================================================================
" FILE: command.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Variables  "{{{
"}}}

function! unite#sources#command#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'command',
      \ 'description' : 'candidates from Ex command',
      \ 'default_action' : 'execute',
      \ 'default_kind' : 'command',
      \ 'max_candidates' : 200,
      \ 'action_table' : {},
      \ 'hooks' : {},
      \ 'syntax' : 'uniteSource__Command',
      \ }

function! s:source.hooks.on_init(args, context) abort "{{{
  " Get command list.
  let a:context.source__command = unite#util#redir('command')
endfunction"}}}
function! s:source.hooks.on_syntax(args, context) abort "{{{
  syntax match uniteSource__Command_DescriptionLine
        \ / -- .*$/
        \ contained containedin=uniteSource__Command
  syntax match uniteSource__Command_Description
        \ /.*$/
        \ contained containedin=uniteSource__Command_DescriptionLine
  syntax match uniteSource__Command_Marker
        \ / -- /
        \ contained containedin=uniteSource__Command_DescriptionLine
  highlight default link uniteSource__Command_Install Statement
  highlight default link uniteSource__Command_Marker Special
  highlight default link uniteSource__Command_Description Comment
endfunction"}}}

let s:cached_result = []
function! s:source.gather_candidates(args, context) abort "{{{
  if a:context.is_redraw || empty(s:cached_result)
    let s:cached_result = s:make_cache_commands()
  endif

  let result = copy(s:cached_result)
  let completions = [ 'augroup', 'buffer', 'behave',
        \ 'color', 'command', 'compiler', 'cscope',
        \ 'dir', 'environment', 'event', 'expression',
        \ 'file', 'file_in_path', 'filetype', 'function',
        \ 'help', 'highlight', 'history', 'locale',
        \ 'mapping', 'menu', 'option', 'shellcmd', 'sign',
        \ 'syntax', 'tag', 'tag_listfiles',
        \ 'var', 'custom', 'customlist' ]
  for line in split(a:context.source__command, '\n')[1:]
    let word = matchstr(line, '\u\w*')

    " Analyze prototype.
    let end = matchend(line, '\u\w*')
    let args = matchstr(line, '[[:digit:]?+*]', end)
    if args != '0'
      let prototype = matchstr(line, '\u\w*', end)

      if index(completions, prototype) < 0
        let prototype = 'arg'
      endif

      if args == '*'
        let prototype = '[' . prototype . '] ...'
      elseif args == '?'
        let prototype = '[' . prototype . ']'
      elseif args == '+'
        let prototype = prototype . ' ...'
      endif
    else
      let prototype = ''
    endif

    let dict = {
          \ 'word' : word,
          \ 'abbr' : printf('%-16s %s', word, prototype),
          \ 'source__command' : ':'.word,
          \ 'action__command' : word . ' ',
          \ 'action__command_args' : args,
          \ 'action__histadd' : 1,
          \ }
    let dict.action__description = dict.abbr

    call add(result, dict)
  endfor

  return unite#util#sort_by(result, 'tolower(v:val.word)')
endfunction"}}}
function! s:source.change_candidates(args, context) abort "{{{
  let dummy = substitute(a:context.input, '[*\\]', '', 'g')
  if len(split(dummy)) > 1
    " Add dummy result.
    return [{
          \ 'word' : dummy,
          \ 'abbr' : printf('[new command] %s', dummy),
          \ 'source' : 'command',
          \ 'action__command' : dummy,
          \ 'action__histadd' : 1,
          \}]
  endif

  return []
endfunction"}}}

function! s:make_cache_commands() abort "{{{
  let helpfile = expand(findfile('doc/index.txt', &runtimepath))
  if !filereadable(helpfile)
    return []
  endif

  let lines = readfile(helpfile)
  let commands = []
  let start = match(lines, '^|:!|')
  let end = match(lines, '^|:\~|', start)
  for lnum in range(end, start, -1)
    let desc = substitute(lines[lnum], '^\s\+\ze', '', 'g')
    let _ = matchlist(desc, '^|:\(.\{-}\)|\s\+:\S\+\s\+\(.*\)')
    if !empty(_)
      call add(commands, {
            \ 'word' : printf('%-16s -- %s', _[1], _[2]),
            \ 'action__command' : _[1] . ' ',
            \ 'source__command' : ':'._[1],
            \ 'action__histadd' : 1,
            \ })
    endif
  endfor

  return commands
endfunction"}}}

" Actions "{{{
let s:source.action_table.preview = {
      \ 'description' : 'view the help documentation',
      \ 'is_quit' : 0,
      \ }
function! s:source.action_table.preview.func(candidate) abort "{{{
  let winnr = winnr()

  try
    execute 'help' a:candidate.source__command
    normal! zv
    normal! zt
    setlocal previewwindow
  catch /^Vim\%((\a\+)\)\?:E149/
    " Ignore
  endtry

  execute winnr.'wincmd w'
endfunction"}}}
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
