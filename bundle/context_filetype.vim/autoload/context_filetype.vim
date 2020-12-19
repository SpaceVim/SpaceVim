"=============================================================================
" FILE: context_filetype.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

scriptencoding utf-8

let g:context_filetype#filetypes = get(g:,
      \ 'context_filetype#filetypes', {})

let g:context_filetype#ignore_composite_filetypes = get(g:,
      \ 'context_filetype#ignore_composite_filetypes', {})

let g:context_filetype#same_filetypes = get(g:,
      \ 'context_filetype#same_filetypes', {})

let g:context_filetype#search_offset = get(g:,
      \ 'context_filetype#search_offset', 200)

function! context_filetype#version() abort
  return str2nr(printf('%02d%02d', 1, 0))
endfunction


function! context_filetype#get(...) abort
  let base_filetype = get(a:, 1, &filetype)
  let filetypes = context_filetype#filetypes()
  let context = s:get_nest(base_filetype, filetypes)
  if context.range == s:null_range && !has_key(context, 'synname')
    let context.filetype = base_filetype
  endif
  return context
endfunction


function! context_filetype#get_filetype(...) abort
  let base_filetype = get(a:, 1, &filetype)
  return context_filetype#get(base_filetype).filetype
endfunction

function! context_filetype#get_filetypes(...) abort
  let filetype = call('context_filetype#get_filetype', a:000)

  let filetypes = [filetype]
  if filetype =~ '\.'
    if has_key(g:context_filetype#ignore_composite_filetypes, filetype)
      let filetypes =
            \ [g:context_filetype#ignore_composite_filetypes[filetype]]
    else
      " Set composite filetype.
      let filetypes += split(filetype, '\.')
    endif
  endif

  for ft in copy(filetypes)
    let filetypes += s:get_same_filetypes(ft)
  endfor

  if len(filetypes) > 1
    let filetypes = s:uniq(filetypes)
  endif

  return filetypes
endfunction

function! context_filetype#get_same_filetypes(...) abort
  let filetype = call('context_filetype#get_filetype', a:000)

  let filetypes = []
  for ft in context_filetype#get_filetypes(filetype)
    let filetypes += s:get_same_filetypes(ft)
  endfor

  if len(filetypes) > 1
    let filetypes = s:uniq(filetypes)
  endif

  return filetypes
endfunction


function! context_filetype#get_range(...) abort
  let base_filetype = get(a:, 1, &filetype)
  return context_filetype#get(base_filetype).range
endfunction


function! context_filetype#default_filetypes() abort
  return deepcopy(s:default_filetypes)
endfunction

function! context_filetype#filetypes() abort
  if exists('b:context_filetype_filetypes')
    return deepcopy(b:context_filetype_filetypes)
  endif
  return extend(deepcopy(s:default_filetypes), deepcopy(g:context_filetype#filetypes))
endfunction


" s:default_filetypes
let s:default_filetypes = {
      \ 'c': [
      \   {
      \    'start': '_*asm_*\s\+\h\w*',
      \    'end': '$', 'filetype': 'masm',
      \   },
      \   {
      \    'start': '_*asm_*\s*\%(\n\s*\)\?{',
      \    'end': '}', 'filetype': 'masm',
      \   },
      \   {
      \    'start': '_*asm_*\s*\%(_*volatile_*\s*\)\?(',
      \    'end': ');', 'filetype': 'gas',
      \   },
      \ ],
      \ 'cpp': [
      \   {
      \    'start': '_*asm_*\s\+\h\w*',
      \    'end': '$', 'filetype': 'masm',
      \   },
      \   {
      \    'start': '_*asm_*\s*\%(\n\s*\)\?{',
      \    'end': '}', 'filetype': 'masm',
      \   },
      \   {
      \    'start': '_*asm_*\s*\%(_*volatile_*\s*\)\?(',
      \    'end': ');', 'filetype': 'gas',
      \   },
      \ ],
      \ 'd': [
      \   {
      \    'start': 'asm\s*\%(\n\s*\)\?{',
      \    'end': '}', 'filetype': 'masm',
      \   },
      \ ],
      \ 'eruby': [
      \   {
      \    'start': '<%[=#]\?',
      \    'end': '%>', 'filetype': 'ruby',
      \   },
      \ ],
      \ 'help': [
      \   {
      \    'start': '^>\|\s>$',
      \    'end': '^<\|^\S\|^$', 'filetype': 'vim',
      \   },
      \ ],
      \ 'html': [
      \   {
      \    'start':
      \     '<script\%( [^>]*\)\? type="text/javascript"\%( [^>]*\)\?>',
      \    'end': '</script>', 'filetype': 'javascript',
      \   },
      \   {
      \    'start':
      \     '<script\%( [^>]*\)\? type="text/coffeescript"\%( [^>]*\)\?>',
      \    'end': '</script>', 'filetype': 'coffee',
      \   },
      \   {
      \    'start':
      \     '<script\%( [^>]*\)\?>',
      \    'end': '</script>', 'filetype': 'javascript',
      \   },
      \   {
      \    'start':
      \     '<style\%( [^>]*\)\?>',
      \    'end': '</style>', 'filetype': 'css',
      \   },
      \   {
      \    'start':
      \     '<[^>]\+ style=\([''"]\)',
      \    'end': '\1', 'filetype': 'css',
      \   },
      \ ],
      \ 'vue': [
      \   {
      \    'start':
      \     '<template\%( [^>]*\)\? \%(lang="\%(\(\h\w*\)\)"\)\%( [^>]*\)\?>',
      \    'end': '</template>', 'filetype': '\1',
      \   },
      \   {
      \    'start':
      \     '<template\%( [^>]*\)\?>',
      \    'end': '</template>', 'filetype': 'html',
      \   },
      \   {
      \    'start':
      \     '<script\%( [^>]*\)\? \%(ts\|lang="\%(ts\|typescript\)"\)\%( [^>]*\)\?>',
      \    'end': '</script>', 'filetype': 'typescript',
      \   },
      \   {
      \    'start':
      \     '<script\%( [^>]*\)\? \%(lang="\%(\(\h\w*\)\)"\)\%( [^>]*\)\?>',
      \    'end': '</script>', 'filetype': '\1',
      \   },
      \   {
      \    'start':
      \     '<script\%( [^>]*\)\?>',
      \    'end': '</script>', 'filetype': 'javascript',
      \   },
      \   {
      \    'start':
      \     '<style\%( [^>]*\)\? \%(lang="\%(\(\h\w*\)\)"\)\%( [^>]*\)\?>',
      \    'end': '</style>', 'filetype': '\1',
      \   },
      \   {
      \    'start':
      \     '<style\%( [^>]*\)\?>',
      \    'end': '</style>', 'filetype': 'css',
      \   },
      \   {
      \    'start':
      \     '<\(\h\w*\)>',
      \    'end': '</\1>', 'filetype': 'vue-\1',
      \   },
      \   {
      \    'start':
      \     '<\(\h\w*\) \%(lang="\%(\(\h\w*\)\)"\)\%( [^>]*\)\?>',
      \    'end': '</\1>', 'filetype': '\2',
      \   },
      \ ],
      \ 'int-nyaos': [
      \   {
      \    'start': '\<lua_e\s\+\(["'']\)',
      \    'end': '\1\@<!\1\1\@!', 'filetype': 'lua',
      \   },
      \ ],
      \ 'lua': [
      \   {
      \    'start': 'vim.command\s*(\([''"]\)',
      \    'end': '\\\@<!\1', 'filetype': 'vim',
      \   },
      \   {
      \    'start': 'vim.eval\s*(\([''"]\)',
      \    'end': '\\\@<!\1', 'filetype': 'vim',
      \   },
      \ ],
      \ 'nyaos': [
      \   {
      \    'start': '\<lua_e\s\+\(["'']\)',
      \    'end': '\1\@<!\1\1\@!', 'filetype': 'lua',
      \   },
      \ ],
      \ 'perl6': [
      \   {
      \    'start': 'Q:PIR\s*{',
      \    'end': '}', 'filetype': 'pir',
      \   },
      \ ],
      \ 'python': [
      \   {
      \    'start': 'vim.command\s*(\([''"]\)',
      \    'end': '\\\@<!\1', 'filetype': 'vim',
      \   },
      \   {
      \    'start': 'vim.eval\s*(\([''"]\)',
      \    'end': '\\\@<!\1', 'filetype': 'vim',
      \   },
      \   {
      \    'start': 'vim.call\s*(\([''"]\)',
      \    'end': '\\\@<!\1', 'filetype': 'vim',
      \   },
      \ ],
      \ 'vim': [
      \   {
      \    'start': '^\s*pe\%[rl\] <<\s*\(\h\w*\)',
      \    'end': '^\1', 'filetype': 'perl',
      \   },
      \   {
      \    'start': '^\s*py\%[thon\]3\? <<\s*\(\h\w*\)',
      \    'end': '^\1', 'filetype': 'python',
      \   },
      \   {
      \    'start': '^\s*rub\%[y\] <<\s*\(\h\w*\)',
      \    'end': '^\1', 'filetype': 'ruby',
      \   },
      \   {
      \    'start': '^\s*lua <<\s*\(\h\w*\)',
      \    'end': '^\1', 'filetype': 'lua',
      \   },
      \   {
      \    'start': '^\s*lua ',
      \    'end': '\n\|\s\+|', 'filetype': 'lua',
      \   },
      \ ],
      \ 'vimperator': [
      \   {
      \    'start': '^\s*\%(javascript\|js\)\s\+<<\s*\(\h\w*\)',
      \    'end': '^\1', 'filetype': 'javascript',
      \   }
      \ ],
      \ 'vimshell': [
      \   {
      \    'start': 'vexe \([''"]\)',
      \    'end': '\\\@<!\1', 'filetype': 'vim',
      \   },
      \   {
      \    'start': ' :\w*',
      \    'end': '\n', 'filetype': 'vim',
      \   },
      \   {
      \    'start': ' vexe\s\+',
      \    'end': '\n', 'filetype': 'vim',
      \   },
      \ ],
      \ 'xhtml': [
      \   {
      \    'start':
      \     '<script\%( [^>]*\)\? type="text/javascript"\%( [^>]*\)\?>',
      \    'end': '</script>', 'filetype': 'javascript',
      \   },
      \   {
      \    'start':
      \     '<script\%( [^>]*\)\? type="text/coffeescript"\%( [^>]*\)\?>',
      \    'end': '</script>', 'filetype': 'coffee',
      \   },
      \   {
      \    'start': '<style\%( [^>]*\)\? type="text/css"\%( [^>]*\)\?>',
      \    'end': '</style>', 'filetype': 'css',
      \   },
      \ ],
      \ 'markdown': [
      \   {
      \    'start' : '^\s*```\s*\(\h\w*\)',
      \    'end' : '^\s*```$', 'filetype' : '\1',
      \   },
      \ ],
      \ 'haml': [
      \   {
      \    'start' : '^\s*-',
      \    'end' : '$', 'filetype' : 'ruby',
      \   },
      \   {
      \    'start' : '^\s*\w*=',
      \    'end' : '$', 'filetype' : 'ruby',
      \   },
      \   {
      \    'start' : '^:javascript$',
      \    'end' : '^\S', 'filetype' : 'javascript',
      \   },
      \   {
      \    'start' : '^:css$',
      \    'end' : '^\S', 'filetype' : 'css',
      \   },
      \ ],
      \ 'jade': [
      \   {
      \    'start' : '^\(\s*\)script\.\s*$',
      \    'end' : '^\%(\1\s\|\s*$\)\@!',
      \    'filetype' : 'javascript',
      \   },
      \   {
      \    'start' : '^\(\s*\):coffeescript\s*$',
      \    'end' : '^\%(\1\s\|\s*$\)\@!',
      \    'filetype' : 'coffee',
      \   },
      \   {
      \    'start' : '^\(\s*\):\(\h\w*\)\s*$',
      \    'end' : '^\%(\1\s\|\s*$\)\@!',
      \    'filetype' : '\2',
      \   },
      \ ],
      \ 'toml': [
      \   {
      \    'start': '\<hook_\%('.
      \             'add\|source\|post_source\|post_update'.
      \             '\)\s*=\s*\('."'''".'\|"""\)',
      \    'end': '\1', 'filetype': 'vim',
      \   },
      \ ],
      \ 'go': [
      \   {
      \    'start': '^\s*\%(//\s*\)\?#\s*include\s\+',
      \    'end': '$', 'filetype': 'c',
      \   },
      \ ],
      \ 'asciidoc': [
      \   {
      \    'start' : '^\[source\%(%[^,]*\)\?,\(\h\w*\)\(,.*\)\?\]\s*\n----\s*\n',
      \    'end' : '^----\s*$', 'filetype' : '\1',
      \   },
      \   {
      \    'start' : '^\[source\%(%[^,]*\)\?,\(\h\w*\)\(,.*\)\?\]\s*\n',
      \    'end' : '^$', 'filetype' : '\1',
      \   },
      \ ],
      \ 'review': [
      \   {
      \    'start': '^//list\[[^]]\+\]\[[^]]\+\]\[\([^]]\+\)\]{',
      \    'end': '^//}', 'filetype' : '\1',
      \   },
      \ ],
      \ 'javascript': [
      \   {
      \    'synname_pattern': '^jsx',
      \    'filetype' : 'jsx',
      \   },
      \   {
      \    'start': '^\s*{/\*',
      \    'end': '\*/}', 'filetype' : 'jsx',
      \   },
      \ ],
      \ 'typescript': [
      \   {
      \    'synname_pattern': '^jsx',
      \    'filetype' : 'tsx',
      \   },
      \   {
      \    'start': '^\s*{/\*',
      \    'end': '\*/}', 'filetype' : 'tsx',
      \   },
      \ ],
\}


" s:default_same_filetypes {{{
let s:default_same_filetypes = {
      \ 'cpp': 'c',
      \ 'erb': 'ruby,html,xhtml',
      \ 'html': 'xhtml',
      \ 'xml': 'xhtml',
      \ 'xhtml': 'html,xml',
      \ 'htmldjango': 'html',
      \ 'css': 'scss',
      \ 'scss': 'css',
      \ 'stylus': 'css',
      \ 'less': 'css',
      \ 'tex': 'bib,plaintex',
      \ 'plaintex': 'bib,tex',
      \ 'lingr-say': 'lingr-messages,lingr-members',
      \ 'J6uil_say': 'J6uil',
      \ 'vimconsole': 'vim',
      \
      \ 'int-irb': 'ruby',
      \ 'int-ghci': 'haskell',
      \ 'int-hugs': 'haskell',
      \ 'int-python': 'python',
      \ 'int-python3': 'python',
      \ 'int-ipython': 'python',
      \ 'int-ipython3': 'python',
      \ 'int-gosh': 'scheme',
      \ 'int-clisp': 'lisp',
      \ 'int-erl': 'erlang',
      \ 'int-zsh': 'zsh',
      \ 'int-bash': 'bash',
      \ 'int-sh': 'sh',
      \ 'int-cmdproxy': 'dosbatch',
      \ 'int-powershell': 'powershell',
      \ 'int-perlsh': 'perl',
      \ 'int-perl6': 'perl6',
      \ 'int-ocaml': 'ocaml',
      \ 'int-clj': 'clojure',
      \ 'int-lein': 'clojure',
      \ 'int-sml': 'sml',
      \ 'int-smlsharp': 'sml',
      \ 'int-js': 'javascript',
      \ 'int-kjs': 'javascript',
      \ 'int-rhino': 'javascript',
      \ 'int-coffee': 'coffee',
      \ 'int-gdb': 'gdb',
      \ 'int-scala': 'scala',
      \ 'int-nyaos': 'nyaos',
      \ 'int-php': 'php',
\}


function! s:get_same_filetypes(filetype) abort
  let same_filetypes = extend(copy(s:default_same_filetypes),
        \ g:context_filetype#same_filetypes)
  return split(get(same_filetypes, a:filetype,
          \ get(same_filetypes, '_', '')), ',')
endfunction


function! s:stopline_forward() abort
  let stopline_forward = line('.') + g:context_filetype#search_offset
  return (stopline_forward > line('$')) ? line('$') : stopline_forward
endfunction


function! s:stopline_back() abort
  let stopline_back = line('.') - g:context_filetype#search_offset
  return (stopline_back <= 1) ? 1 : stopline_back
endfunction


" a <= b
function! s:pos_less_equal(a, b) abort
  return a:a[0] == a:b[0] ? a:a[1] <= a:b[1] : a:a[0] <= a:b[0]
endfunction


function! s:is_in(start, end, pos) abort
  " start <= pos && pos <= end
  return s:pos_less_equal(a:start, a:pos) && s:pos_less_equal(a:pos, a:end)
endfunction


function! s:file_range() abort
  return [[1, 1], [line('$'), len(getline('$'))+1]]
endfunction

function! s:replace_submatch(pattern, match_list) abort
  return substitute(a:pattern, '\\\@>\(\d\)',
      \ {m -> a:match_list[m[1]]}, 'g')
endfunction

function! s:replace_submatch_pattern(pattern, match_list) abort
  let pattern = ''
  let backref_end_prev = 0
  let backref_start = match(a:pattern, '\\\@>\d')
  let backref_end = backref_start + 2
  let magic = '\m'
  let magic_start = match(a:pattern, '\\\@>[vmMV]')
  while 0 <= backref_start
    while 0 <= magic_start && magic_start <= backref_end
      let magic = a:pattern[magic_start : magic_start + 1]
      let magic_start = match(a:pattern, '\\\@>[vmMV]', magic_start + 2)
      if magic_start == backref_end
        let backref_end += 2
      endif
    endwhile
    if backref_start != 0
      let pattern .= a:pattern[backref_end_prev : backref_start - 1]
    endif
    let pattern .= '\V'
        \ . escape(a:match_list[a:pattern[backref_start + 1]], '\')
        \ . magic
    let backref_end_prev = backref_end
    let backref_start = match(a:pattern, '\\\@>\d', backref_end_prev)
    let backref_end = backref_start + 2
  endwhile
  return pattern . a:pattern[backref_end_prev : -1]
endfunction


let s:null_pos = [0, 0]
let s:null_range = [[0, 0], [0, 0]]


function! s:search_range(start_pattern, end_pattern) abort
  let stopline_forward = s:stopline_forward()
  let stopline_back    = s:stopline_back()

  let cur_text =
        \ (mode() ==# 'i' ? (col('.')-1) : col('.')) >= len(getline('.')) ?
        \      getline('.') :
        \      matchstr(getline('.'),
        \         '^.*\%' . (mode() ==# 'i' ? col('.') : col('.') - 1)
        \         . 'c' . (mode() ==# 'i' ? '' : '.'))
  let curline_pattern = a:start_pattern . '\ze.\{-}$'
  if cur_text =~# curline_pattern
    let start = [line('.'), matchend(cur_text, curline_pattern)]
  else
    let start = searchpos(a:start_pattern, 'bnceW', stopline_back)
  endif
  if start == s:null_pos
    return s:null_range
  endif
  let start[1] += 1

  let end_pattern = a:end_pattern
  if end_pattern =~# '\\\@>\d'
    let lines = getline(start[0], line('.'))
    let match_list = matchlist(join(lines, "\n"), a:start_pattern)
    let end_pattern = s:replace_submatch_pattern(end_pattern, match_list)
  endif

  let end_forward = searchpos(end_pattern, 'ncW', stopline_forward)
  if end_forward == s:null_pos
    let end_forward = [line('$'), len(getline('$'))+1]
  endi

  let end_backward = searchpos(end_pattern, 'bnW', stopline_back)
  if s:pos_less_equal(start, end_backward)
    return s:null_range
  endif
  let end_forward[1] -= 1

  if mode() !=# 'i' && start[1] >= strdisplaywidth(getline(start[0]))
    let start[0] += 1
    let start[1] = 1
  endif

  if end_forward[1] <= 1
    let end_forward[0] -= 1
    let len = len(getline(end_forward[0]))
    let len = len ? len : 1
    let end_forward[1] = len
  endif

  return [start, end_forward]
endfunction


let s:null_context = {
\ 'filetype' : '',
\ 'range' : s:null_range,
\}


function! s:get_context(filetype, context_filetypes, search_range) abort
  let base_filetype = empty(a:filetype) ? 'nothing' : a:filetype
  let context_filetypes = get(a:context_filetypes, base_filetype, [])
  if empty(context_filetypes)
    return s:null_context
  endif

  let pos = [line('.'), col('.')]

  for context in context_filetypes
    if has_key(context, 'synname_pattern')
      for id in synstack(line('.'), col('.'))
        let synname = synIDattr(id, 'name')
        if synname =~# context.synname_pattern
          return {'filetype' : context.filetype, 'range': s:null_range, 'synname': synname}
        endif
      endfor
      continue
    endif

    let range = s:search_range(context.start, context.end)

    " Set cursor position
    let start = range[0]
    let end   = [range[1][0], (mode() ==# 'i') ? range[1][1]+1 : range[1][1]]

    " start <= pos && pos <= end
    " search_range[0] <= start && start <= search_range[1]
    " search_range[0] <= end   && end   <= search_range[1]
    if range != s:null_range
          \  && s:is_in(start, end, pos)
          \  && s:is_in(a:search_range[0], a:search_range[1], range[0])
          \  && s:is_in(a:search_range[0], a:search_range[1], range[1])
      let context_filetype = context.filetype
      if context.filetype =~# '\\\@>\d'
        let stopline_back = s:stopline_back()
        let lines = getline(
              \ searchpos(context.start, 'nbW', stopline_back)[0],
              \ line('.')
              \ )
        let match_list = matchlist(join(lines, "\n"), context.start)
        let context_filetype = s:replace_submatch(context.filetype, match_list)
      endif
      return {'filetype' : context_filetype, 'range' : range}
    endif
  endfor

  return s:null_context
endfunction


function! s:get_nest_impl(filetype, context_filetypes, prev_context) abort
  let context = s:get_context(a:filetype,
        \ a:context_filetypes, a:prev_context.range)
  if context.range != s:null_range && context.filetype !=# a:filetype
    return s:get_nest_impl(context.filetype, a:context_filetypes, context)
  else
    return a:prev_context
  endif
endfunction


function! s:get_nest(filetype, context_filetypes) abort
  let context = s:get_context(a:filetype, a:context_filetypes, s:file_range())
  return s:get_nest_impl(context.filetype, a:context_filetypes, context)
endfunction

function! s:uniq(list) abort
  let dict = {}
  for item in a:list
    if item != '' && !has_key(dict, item)
      let dict[item] = item
    endif
  endfor

  return values(dict)
endfunction
