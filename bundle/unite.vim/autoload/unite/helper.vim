"=============================================================================
" FILE: helpers.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#helper#call_hook(sources, hook_name) abort "{{{
  let context = unite#get_context()
  if context.unite__disable_hooks
    return
  endif

  let custom = unite#custom#get()
  for source in a:sources
    let custom_source = get(custom.sources, source.name, {})

    try
      if has_key(source.hooks, a:hook_name)
        call call(source.hooks[a:hook_name],
              \ [source.args, source.unite__context], source.hooks)
      endif
      if has_key(custom_source, a:hook_name)
        call call(custom_source[a:hook_name],
              \ [source.args, source.unite__context])
      endif
    catch
      call unite#print_error(v:throwpoint)
      call unite#print_error(v:exception)
      call unite#print_error(
            \ 'Error occurred in calling hook "' . a:hook_name . '"!')
      call unite#print_error(
            \ 'Source name is ' . source.name)
    endtry
  endfor
endfunction"}}}

function! unite#helper#get_substitute_input(input) abort "{{{
  let unite = unite#get_current_unite()

  let input = a:input
  if empty(unite.args) && input =~ '^.\{-}\%(\\\@<!\s\)\+'
    " Ignore source name
    let input = matchstr(input, '^.\{-}\%(\\\@<!\s\)\+\zs.*')
  endif

  let substitute_patterns = reverse(unite#util#sort_by(
        \ values(unite#custom#get_profile(unite.profile_name,
        \        'substitute_patterns')),
        \ 'v:val.priority'))
  if unite.input != '' && stridx(input, unite.input) == 0
        \ && !empty(unite.args)
    " Substitute after input.
    let input_save = input
    let input = input_save[len(unite.input) :]
    let head = input_save[: len(unite.input)-1]
  else
    " Substitute all input.
    let head = ''
  endif

  let inputs = unite#helper#get_substitute_input_loop(
        \ input, substitute_patterns)

  return map(inputs, 'head . v:val')
endfunction"}}}
function! unite#helper#get_substitute_input_loop(input, substitute_patterns) abort "{{{
  if empty(a:substitute_patterns)
    return [a:input]
  endif

  let inputs = [a:input]
  for pattern in a:substitute_patterns
    let cnt = 0
    for input in inputs
      if input =~ pattern.pattern
        if type(pattern.subst) == type([])
          if len(inputs) == 1
            " List substitute.
            let inputs = []
            for subst in pattern.subst
              call add(inputs,
                    \ substitute(input, pattern.pattern, subst, 'g'))
            endfor
          endif
        else
          let inputs[cnt] = substitute(
                \ input, pattern.pattern, pattern.subst, 'g')
        endif
      endif

      let cnt += 1
    endfor
  endfor

  return inputs
endfunction"}}}

function! unite#helper#adjustments(currentwinwidth, the_max_source_name, size) abort "{{{
  let max_width = a:currentwinwidth - a:the_max_source_name - a:size
  if max_width < 20
    return [a:currentwinwidth - a:size, 0]
  else
    return [max_width, a:the_max_source_name]
  endif
endfunction"}}}

function! unite#helper#parse_options(cmdline) abort "{{{
  let args = []
  let options = {}

  " Eval
  let cmdline = (a:cmdline =~ '\\\@<!`.*\\\@<!`') ?
        \ s:eval_cmdline(a:cmdline) : a:cmdline

  for arg in split(cmdline, '\%(\\\@<!\s\)\+')
    let arg = substitute(arg, '\\\( \)', '\1', 'g')
    let arg_key = substitute(arg, '=\zs.*$', '', '')

    let name = substitute(tr(arg_key, '-', '_'), '=$', '', '')
    let value = (arg_key =~ '=$') ? arg[len(arg_key) :] : 1

    if arg_key =~ '^-custom-'
          \ || index(unite#variables#options(), arg_key) >= 0
      let options[name[1:]] = value
    else
      call add(args, arg)
    endif
  endfor

  return [args, options]
endfunction"}}}
function! unite#helper#parse_options_args(cmdline) abort "{{{
  let _ = []
  let [args, options] = unite#helper#parse_options(a:cmdline)
  for arg in args
    " Add source name.
    let source_name = matchstr(arg, '^[^:]*')
    let source_arg = arg[len(source_name)+1 :]
    let source_args = source_arg  == '' ? [] :
          \  map(split(source_arg, '\\\@<!:', 1),
          \      'substitute(v:val, ''\\\(.\)'', "\\1", "g")')
    call add(_, insert(source_args, source_name))
  endfor

  return [_, options]
endfunction"}}}
function! unite#helper#parse_options_user(args) abort "{{{
  " Add for history/unite.
  let [args, options] = unite#helper#parse_options_args(a:args)
  let options.unite__is_manual = 1
  return [args, options]
endfunction"}}}
function! s:eval_cmdline(cmdline) abort "{{{
  let cmdline = ''
  let prev_match = 0
  let match = match(a:cmdline, '\\\@<!`.\{-}\\\@<!`')
  while match >= 0
    if match - prev_match > 0
      let cmdline .= a:cmdline[prev_match : match - 1]
    endif
    let prev_match = matchend(a:cmdline,
          \ '\\\@<!`.\{-}\\\@<!`', match)
    let cmdline .= escape(eval(a:cmdline[match+1 : prev_match - 2]), '\: ')

    let match = match(a:cmdline, '\\\@<!`.\{-}\\\@<!`', prev_match)
  endwhile
  if prev_match >= 0
    let cmdline .= a:cmdline[prev_match :]
  endif

  return cmdline
endfunction"}}}

function! unite#helper#parse_source_args(args) abort "{{{
  let args = copy(a:args)
  if empty(args)
    return []
  endif

  let args[0] = unite#helper#parse_source_path(args[0])
  return args
endfunction"}}}

function! unite#helper#parse_source_path(path) abort "{{{
  " Expand ?!/buffer_project_subdir, !/project_subdir and ?/buffer_subdir
  if a:path =~ '^?!'
    " Use project directory from buffer directory
    let path = unite#helper#get_buffer_directory(bufnr('%'))
    let path = unite#util#substitute_path_separator(
      \ unite#util#path2project_directory(path) . a:path[2:])
  elseif a:path =~ '^!'
    " Use project directory from cwd
    let path = &filetype ==# 'vimfiler' ?
          \ b:vimfiler.current_dir :
          \ unite#util#substitute_path_separator(getcwd())
    let path = unite#util#substitute_path_separator(
      \ unite#util#path2project_directory(path) . a:path[1:])
  elseif a:path =~ '^?'
    " Use buffer directory
    let path = unite#util#substitute_path_separator(
      \ unite#helper#get_buffer_directory(bufnr('%')) . a:path[1:])
  else
    let path = a:path
  endif

  " Don't assume empty path means current directory.
  " Let the sources customize default rules.
  if path != ''
    let pathlist = path =~ "\n" ? split(path, "\n") : [path]
    for pathitem in pathlist
      " resolve .. in the paths
      let pathitem = resolve(unite#util#substitute_path_separator(
            \ fnamemodify(unite#util#expand(pathitem), ':p')))
    endfor
    let path = join(pathlist, "\n")
  endif

  return path
endfunction"}}}

function! unite#helper#get_marked_candidates() abort "{{{
  return unite#util#sort_by(filter(copy(unite#get_unite_candidates()),
        \ 'v:val.unite__is_marked'), 'v:val.unite__marked_time')
endfunction"}}}

function! unite#helper#get_input(...) abort "{{{
  let is_force = get(a:000, 0, 0)
  let unite = unite#get_current_unite()
  if !is_force && mode() !=# 'i'
    return unite.context.input
  endif

  if unite.prompt_linenr == 0
    return ''
  endif

  " Prompt check.
  if unite.context.prompt != '' &&
        \ getline(unite.prompt_linenr)[: len(unite.context.prompt)-1]
        \   !=# unite.context.prompt
    let modifiable_save = &l:modifiable
    setlocal modifiable

    " Restore prompt.
    call setline(unite.prompt_linenr, unite.context.prompt)

    let &l:modifiable = modifiable_save
  endif

  return getline(unite.prompt_linenr)[len(unite.context.prompt):]
endfunction"}}}

function! unite#helper#get_source_names(sources) abort "{{{
  return map(map(copy(a:sources),
        \ "type(v:val) == type([]) ? v:val[0] : v:val"),
        \ "type(v:val) == type('') ? v:val : v:val.name")
endfunction"}}}

function! unite#helper#get_postfix(prefix, is_create, ...) abort "{{{
  let prefix = substitute(a:prefix, '@\d\+$', '', '')
  let buffers = get(a:000, 0, range(1, bufnr('$')))
  let buflist = sort(filter(map(buffers,
        \ 'bufname(v:val)'), 'stridx(v:val, prefix) >= 0'), 's:sort_buffer_name')
  if empty(buflist)
    return ''
  endif

  return a:is_create ? '@'.(matchstr(buflist[-1], '@\zs\d\+$') + 1)
        \ : matchstr(buflist[-1], '@\d\+$')
endfunction"}}}

function! s:sort_buffer_name(lhs, rhs) abort "{{{
  return matchstr(a:lhs, '@\zs\d\+$') - matchstr(a:rhs, '@\zs\d\+$')
endfunction"}}}

function! unite#helper#convert_source_name(source_name) abort "{{{
  let unite = unite#get_current_unite()
  return (len(unite.sources) == 1 ||
        \  !unite.context.short_source_names) ? a:source_name :
        \ a:source_name !~ '\A'  ? a:source_name[:1] :
        \ substitute(a:source_name, '\a\zs\a\+', '', 'g')
endfunction"}}}

function! unite#helper#invalidate_cache(source_name) abort  "{{{
  for source in unite#get_current_unite().sources
    if source.name ==# a:source_name
      let source.unite__is_invalidate = 1
    endif
  endfor
endfunction"}}}

function! unite#helper#get_unite_winnr(buffer_name) abort "{{{
  for winnr in filter(range(1, winnr('$')),
        \ "getbufvar(winbufnr(v:val), '&filetype') ==# 'unite'")
    let buffer_context = get(getbufvar(
          \ winbufnr(winnr), 'unite'), 'context', {})
    if !empty(buffer_context) &&
          \ buffer_context.buffer_name ==# a:buffer_name
      if buffer_context.temporary
            \ && !empty(filter(copy(buffer_context.unite__old_buffer_info),
            \ 'v:val.buffer_name ==# buffer_context.buffer_name'))
        " Disable resume.
        let buffer_context.unite__old_buffer_info = []
      endif
      return winnr
    endif
  endfor

  return -1
endfunction"}}}
function! unite#helper#get_unite_bufnr(buffer_name) abort "{{{
  for bufnr in filter(range(1, bufnr('$')),
        \ "getbufvar(v:val, '&filetype') ==# 'unite'")
    let buffer_context = get(getbufvar(bufnr, 'unite'), 'context', {})
    if !empty(buffer_context) &&
          \ buffer_context.buffer_name ==# a:buffer_name
      if buffer_context.temporary
            \ && !empty(filter(copy(buffer_context.unite__old_buffer_info),
            \ 'v:val.buffer_name ==# buffer_context.buffer_name'))
        " Disable resume.
        let buffer_context.unite__old_buffer_info = []
      endif

      return bufnr
    endif
  endfor

  return -1
endfunction"}}}

function! unite#helper#get_current_candidate(...) abort "{{{
  let linenr = a:0 >= 1? a:1 : line('.')
  let unite = unite#get_current_unite()
  if unite.context.prompt_direction ==# 'below'
    let num = unite.prompt_linenr == 0 ?
          \ linenr - line('$') - 1 :
          \ linenr == unite.prompt_linenr ?
          \ -1 : linenr - line('$')
  else
    let num = linenr == unite.prompt_linenr ?
          \ 0 : linenr - 1 - unite.prompt_linenr
  endif

  let unite.candidate_cursor = num

  return get(unite#get_unite_candidates(), num, {})
endfunction"}}}

function! unite#helper#get_current_candidate_linenr(num) abort "{{{
  let candidate_num = 0
  let num = 0
  for candidate in unite#get_unite_candidates()
    if !candidate.is_dummy
      let candidate_num += 1
    endif

    if candidate_num > a:num
      break
    endif

    let num += 1
  endfor

  let unite = unite#get_current_unite()
  if unite.context.prompt_direction ==# 'below'
    let num = num * -1
    if unite.prompt_linenr == 0
      let num += line('$') + 1
    endif
  else
    let num += 1
  endif

  return unite.prompt_linenr + num
endfunction"}}}

function! unite#helper#call_filter(filter_name, candidates, context) abort "{{{
  let filter = unite#get_filters(a:filter_name)
  if empty(filter)
    return a:candidates
  endif

  return filter.filter(a:candidates, a:context)
endfunction"}}}
function! unite#helper#call_source_filters(filters, candidates, context, source) abort "{{{
  let candidates = a:candidates
  for l:Filter in a:filters
    if type(l:Filter) == type('')
      let candidates = unite#helper#call_filter(
            \ l:Filter, candidates, a:context)
    else
      let candidates = call(l:Filter, [candidates, a:context], a:source)
    endif

    unlet l:Filter
  endfor

  return candidates
endfunction"}}}

function! unite#helper#get_source_args(sources) abort "{{{
  return map(copy(a:sources),
        \ 'type(v:val) == type([]) ? [v:val[0], v:val[1:]] : [v:val, []]')
endfunction"}}}

function! unite#helper#choose_window() abort "{{{
  " Create key table.
  let keys = {}
  for [key, number] in items(g:unite_quick_match_table)
    let keys[number] = key
  endfor

  " Save statusline.
  let save_statuslines = map(unite#helper#get_choose_windows(),
        \ "[v:val, getbufvar(winbufnr(v:val), '&statusline')]")

  let save_laststatus = &laststatus

  try
    let &laststatus = 2

    let winnr_save = winnr()
    for [winnr, statusline] in save_statuslines
      noautocmd execute winnr.'wincmd w'
      let &l:statusline =
            \ repeat(' ', winwidth(0)/2-len(winnr())).get(keys, winnr()-1, 0)
      redraw
    endfor

    noautocmd execute winnr_save.'wincmd w'
    redraw

    while 1
      echohl PreProc
      echon 'choose > '
      echohl Normal

      let num = get(g:unite_quick_match_table,
            \ nr2char(getchar()), 0) + 1
      if num < 0 || winbufnr(num) > 0
        return num
      endif

      echo ''
    endwhile
  finally
    let &laststatus = save_laststatus

    echo ''

    let winnr_save = winnr()
    for [winnr, statusline] in save_statuslines
      noautocmd execute winnr.'wincmd w'
      let &l:statusline = statusline
      redraw
    endfor

    noautocmd execute winnr_save.'wincmd w'
    redraw
  endtry
endfunction"}}}

function! unite#helper#get_choose_windows() abort "{{{
  return filter(range(1, winnr('$')), "
        \ !getwinvar(v:val, '&previewwindow')
        \ && getwinvar(v:val, '&filetype') !=# 'vimfiler'
        \ && getwinvar(v:val, '&filetype') !=# 'unite'
        \ && getwinvar(v:val, '&buftype') !~# 'terminal'
        \ && (getwinvar(v:val, '&buftype') !~# 'nofile'
        \   || getwinvar(v:val, '&buftype') =~# 'acwrite')
        \ && getwinvar(v:val, '&filetype') !=# 'qf'")
endfunction"}}}

function! unite#helper#get_buffer_directory(bufnr) abort "{{{
  let filetype = getbufvar(a:bufnr, '&filetype')
  if filetype ==# 'vimfiler'
    let dir = getbufvar(a:bufnr, 'vimfiler').current_dir
  elseif filetype ==# 'vimshell'
    let dir = getbufvar(a:bufnr, 'vimshell').current_dir
  elseif filetype ==# 'vinarise'
    let dir = getbufvar(a:bufnr, 'vinarise').current_dir
  else
    let path = unite#util#substitute_path_separator(bufname(a:bufnr))
    let dir = unite#util#path2directory(path)
  endif

  return dir
endfunction"}}}

function! unite#helper#cursor_prompt() abort "{{{
  " Move to prompt linenr.
  let unite = unite#get_current_unite()
  call cursor((unite.context.prompt_direction ==# 'below' ?
        \ line('$') : unite.init_prompt_linenr), 0)
endfunction"}}}

function! unite#helper#skip_prompt() abort "{{{
  " Skip prompt linenr.
  let unite = unite#get_current_unite()
  if line('.') == unite.prompt_linenr
    call cursor(line('.') + (unite.context.prompt_direction
          \ ==# 'below' ? -1 : 1), 1)
  endif
endfunction"}}}

if unite#util#has_lua()
  function! unite#helper#paths2candidates(paths) abort "{{{
    let candidates = []
  lua << EOF
do
  local paths = vim.eval('a:paths')
  local candidates = vim.eval('candidates')
  for path in paths() do
    local candidate = vim.dict()
    candidate.word = path
    candidate.action__path = path
    candidates:add(candidate)
  end
end
EOF

    return candidates
  endfunction"}}}
else
  function! unite#helper#paths2candidates(paths) abort "{{{
    return map(copy(a:paths), "{
          \ 'word' : v:val,
          \ 'action__path' : v:val,
          \ }")
  endfunction"}}}
endif

function! unite#helper#get_candidate_directory(candidate) abort "{{{
  return has_key(a:candidate, 'action__directory') ?
        \ a:candidate.action__directory :
        \ unite#util#path2directory(a:candidate.action__path)
endfunction"}}}

function! unite#helper#is_prompt(line) abort "{{{
  let prompt_linenr = unite#get_current_unite().prompt_linenr
  let context = unite#get_context()
  return (context.prompt_direction ==# 'below' && a:line >= prompt_linenr)
        \ || (context.prompt_direction !=# 'below' && a:line <= prompt_linenr)
endfunction"}}}

function! unite#helper#relative_target(target) abort "{{{
  let target = unite#util#substitute_path_separator(fnamemodify(
        \ substitute(a:target, '[^:]\zs/$', '', ''), ':.'))
  if target == unite#util#substitute_path_separator(getcwd())
    return '.'
  endif
  if unite#util#is_windows()
    let drive_letter = matchstr(a:target, '^\a:')
    let target = strpart(target, 0, 1) ==# '/' && drive_letter !=# '' ?
          \ drive_letter . target : target
  endif
  return target
endfunction"}}}

function! unite#helper#join_targets(targets) abort "{{{
  return join(map(copy(a:targets),
        \    "unite#util#escape_shell(unite#helper#relative_target(v:val))"))
endfunction"}}}

function! unite#helper#is_pty(command) abort "{{{
  " Note: "pt" and "ack" and "ag" and "hw" needs pty.
  " It is too bad.
  return fnamemodify(a:command, ':t:r') =~#
        \ '^pt$\|^ack\%(-grep\)\?$\|^ag$\|^hw$'
endfunction"}}}

function! unite#helper#complete_search_history(arglead, cmdline, cursorpos) abort "{{{
  return filter(map(unite#util#uniq(s:histget('search')
        \                           + s:histget('input')),
        \           "substitute(v:val, '\\c^\\(\\\\[cmv<]\\)*\\|\\\\>$', '', 'g')"),
        \ "stridx(tolower(v:val), tolower(a:arglead)) == 0")
endfunction"}}}

function! unite#helper#get_input_list(input) abort "{{{
  return map(split(a:input, '\\\@<! ', 1), "
        \ substitute(unite#util#expand(v:val), '\\\\ ', ' ', 'g')")
endfunction"}}}

function! s:histget(type) abort "{{{
  return filter(map(reverse(range(1, histnr(a:type))),
        \           'histget(a:type, v:val)'),
        \       'v:val != ""')
endfunction"}}}

function! unite#helper#ignore_candidates(candidates, context) abort "{{{
  let candidates = copy(a:candidates)

  if a:context.ignore_pattern != ''
    let candidates = unite#filters#vim_filter_pattern(
          \   candidates, a:context.ignore_pattern)
  endif

  if !empty(a:context.ignore_globs)
    let candidates = unite#filters#filter_patterns(candidates,
          \ unite#filters#globs2patterns(a:context.ignore_globs),
          \ unite#filters#globs2patterns(a:context.white_globs))
  endif

  return candidates
endfunction"}}}

function! unite#helper#call_unite(command, args, line1, line2) abort "{{{
  let [args, context] = unite#helper#parse_options_user(a:args)
  if a:command ==# 'UniteWithCurrentDir'
        \ && !has_key(context, 'path')
    let path = &filetype ==# 'vimfiler' ?
          \ b:vimfiler.current_dir :
          \ unite#util#substitute_path_separator(fnamemodify(getcwd(), ':p'))
    let context.path = path
  elseif a:command ==# 'UniteWithBufferDir'
        \ && !has_key(context, 'path')
    let context.path = unite#helper#get_buffer_directory(bufnr('%'))
  elseif a:command ==# 'UniteWithProjectDir'
        \ && !has_key(context, 'path')
    let path = &filetype ==# 'vimfiler' ?
          \ b:vimfiler.current_dir :
          \ unite#util#substitute_path_separator(getcwd())
    let context.path = unite#util#path2project_directory(path)
  elseif a:command ==# 'UniteWithInputDirectory'
        \ && !has_key(context, 'path')
    let context.path = unite#helper#parse_source_path(
          \ input('Input narrowing directory: ', '', 'dir'))
  elseif a:command ==# 'UniteWithCursorWord'
        \ && !has_key(context, 'input')
    let context.input = expand('<cword>')
  elseif a:command ==# 'UniteWithInput'
        \ && !has_key(context, 'input')
    let context.input = input('Input narrowing text: ', '')
  endif

  let context.firstline = a:line1
  let context.lastline = a:line2
  let context.bufnr = bufnr('%')

  call unite#start(args, context)
endfunction"}}}
function! unite#helper#call_unite_resume(args) abort "{{{
  let [args, context] = unite#helper#parse_options(a:args)

  call unite#resume(join(args), context)
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
