"=============================================================================
" FILE: parser.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

let s:Cache = neosnippet#util#get_vital().import('System.Cache.Deprecated')

function! neosnippet#parser#_parse_snippets(filename) abort
  if !filereadable(a:filename)
    call neosnippet#util#print_error(
          \ printf('snippet file "%s" is not found.', a:filename))
    return {}
  endif

  if neosnippet#util#is_sudo()
    return s:parse(a:filename)[0]
  endif

  let cache_dir = neosnippet#variables#data_dir()
  let snippets = {}
  if !s:Cache.check_old_cache(cache_dir, a:filename)
    try
      let snippets = neosnippet#helpers#json2vim(
            \ s:Cache.readfile(cache_dir, a:filename)[0])
    catch
    endtry
  endif
  if empty(snippets) || s:Cache.check_old_cache(cache_dir, a:filename)
    let [snippets, sourced] = s:parse(a:filename)
    if len(snippets) > 5 && !sourced
      call s:Cache.writefile(
            \ cache_dir, a:filename,
            \ [neosnippet#helpers#vim2json(snippets)])
    endif
  endif

  return snippets
endfunction
function! neosnippet#parser#_parse_snippet(filename, trigger) abort
  if !filereadable(a:filename)
    call neosnippet#util#print_error(
          \ printf('snippet file "%s" is not found.', a:filename))
    return {}
  endif

  let snippet_dict = {
        \ 'word' : join(readfile(a:filename), "\n\t"),
        \ 'name' : a:trigger,
        \ 'options' : neosnippet#parser#_initialize_snippet_options()
        \ }

  return neosnippet#parser#_initialize_snippet(
        \ snippet_dict, a:filename, 1, '', a:trigger)
endfunction

function! s:parse(snippets_file) abort
  let dup_check = {}
  let snippet_dict = {}
  let linenr = 1
  let snippets = {}
  let sourced = 0

  for line in readfile(a:snippets_file)
    if line =~# '^\h\w*.*\s$'
      " Delete spaces.
      let line = substitute(line, '\s\+$', '', '')
    endif

    if line =~# '^#'
      " Ignore.
    elseif line =~# '^include'
      " Include snippets file.
      let snippets = extend(snippets, s:include_snippets(
            \ [matchstr(line, '^include\s\+\zs.*$')]))
    elseif line =~# '^extends'
      " Extend snippets files.
      let fts = split(matchstr(line, '^extends\s\+\zs.*$'), '\s*,\s*')
      for ft in fts
        let snippets = extend(snippets, s:include_snippets(
              \ [ft.'.snip', ft.'.snippets', ft.'/*']))
      endfor
    elseif line =~# '^source'
      " Source Vim script file.
      for file in split(globpath(join(
            \ neosnippet#helpers#get_snippets_directory(), ','),
            \ matchstr(line, '^source\s\+\zs.*$')), '\n')
        execute 'source' fnameescape(file)
        let sourced = 1
      endfor
    elseif line =~# '^delete\s'
      let name = matchstr(line, '^delete\s\+\zs.*$')
      if name !=# '' && has_key(snippets, name)
        call filter(snippets, 'v:val.real_name !=# name')
      endif
    elseif line =~# '^snippet\s'
      if !empty(snippet_dict)
        " Set previous snippet.
        call s:set_snippet_dict(snippet_dict,
              \ snippets, dup_check, a:snippets_file)
      endif

      let snippet_dict = s:parse_snippet_name(
            \ a:snippets_file, line, linenr, dup_check)
    elseif !empty(snippet_dict)
      if line =~# '^\s' || line ==# ''
        if snippet_dict.word ==# '' && line =~# '^\t'
          " Substitute head tab character.
          let line = substitute(line, '^\t', '', '')
        else
          let line = substitute(line, '^ *', '', '')
        endif

        let snippet_dict.word .= line . "\n"
      else
        call s:add_snippet_attribute(
              \ a:snippets_file, line, linenr, snippet_dict)
      endif
    endif

    let linenr += 1
  endfor

  if !empty(snippet_dict)
    " Set previous snippet.
    call s:set_snippet_dict(snippet_dict,
          \ snippets, dup_check, a:snippets_file)
  endif

  return [snippets, sourced]
endfunction

function! s:parse_snippet_name(snippets_file, line, linenr, dup_check) abort
  " Initialize snippet dict.
  let snippet_dict = {
        \ 'word' : '',
        \ 'linenr' : a:linenr,
        \ 'options' : neosnippet#parser#_initialize_snippet_options()
        \ }

  " Try using the name without the description (abbr).
  let base_name = matchstr(a:line, '^snippet\s\+\zs\S\+')
  let snippet_dict.name = base_name

  " Fall back to using the name with integer counter,
  " but only if the name is a duplicate.
  " SnipMate snippets may have duplicate names, but different
  " descriptions (abbrs).
  let description = matchstr(a:line, '^snippet\s\+\S\+\s\+\zs.*$')
  if g:neosnippet#enable_snipmate_compatibility
        \ && description !=# '' && description !=# snippet_dict.name
        \ && has_key(a:dup_check, snippet_dict.name)
    " Convert description.
    let i = 0
    while has_key(a:dup_check, snippet_dict.name)
      let snippet_dict.name = base_name . '__' . i
      let i += 1
    endwhile
  endif

  " Collect the description (abbr) of the snippet, if set on snippet line.
  " This is for compatibility with SnipMate-style snippets.
  let snippet_dict.abbr = matchstr(a:line,
        \ '^snippet\s\+\S\+\s\+\zs.*$')

  " Check for duplicated names.
  if has_key(a:dup_check, snippet_dict.name)
    let dup = a:dup_check[snippet_dict.name]
    call neosnippet#util#print_error(printf(
          \ '%s:%d is overriding `%s` from %s:%d',
          \ a:snippets_file, a:linenr, snippet_dict.name,
          \ dup.action__path, dup.action__line))
    call neosnippet#util#print_error(printf(
          \ 'Please rename the snippet name or use `delete %s`.',
          \ snippet_dict.name))
  endif

  return snippet_dict
endfunction

function! s:add_snippet_attribute(snippets_file, line, linenr, snippet_dict) abort
  " Allow overriding/setting of the description (abbr) of the snippet.
  " This will override what was set via the snippet line.
  if a:line =~# '^abbr\s'
    let a:snippet_dict.abbr = matchstr(a:line, '^abbr\s\+\zs.*$')
  elseif a:line =~# '^alias\s'
    let a:snippet_dict.alias = split(matchstr(a:line,
          \ '^alias\s\+\zs.*$'), '[,[:space:]]\+')
  elseif a:line =~# '^prev_word\s'
    let prev_word = matchstr(a:line,
          \ '^prev_word\s\+[''"]\zs.*\ze[''"]$')
    if prev_word ==# '^'
      " For backward compatibility.
      let a:snippet_dict.options.head = 1
    else
      call neosnippet#util#print_error(
            \ 'prev_word must be "^" character.')
    endif
  elseif a:line =~# '^regexp\s'
    let a:snippet_dict.regexp = matchstr(a:line,
          \ '^regexp\s\+[''"]\zs.*\ze[''"]$')
  elseif a:line =~# '^options\s\+'
    for option in split(matchstr(a:line,
          \ '^options\s\+\zs.*$'), '[,[:space:]]\+')
      if !has_key(a:snippet_dict.options, option)
        call neosnippet#util#print_error(
              \ printf('%s:%d', a:snippets_file, a:linenr))
        call neosnippet#util#print_error(
              \ printf('Invalid option name : "%s"', option))
      else
        let a:snippet_dict.options[option] = 1
      endif
    endfor
  else
    call neosnippet#util#print_error(
          \ printf('%s:%d', a:snippets_file, a:linenr))
    call neosnippet#util#print_error(
          \ printf('Invalid syntax : "%s"', a:line))
  endif
endfunction

function! s:set_snippet_dict(snippet_dict, snippets, dup_check, snippets_file) abort
  if empty(a:snippet_dict)
    return
  endif

  let action_pattern = '^snippet\s\+' . a:snippet_dict.name . '$'
  let snippet = neosnippet#parser#_initialize_snippet(
        \ a:snippet_dict, a:snippets_file,
        \ a:snippet_dict.linenr, action_pattern,
        \ a:snippet_dict.name)
  let a:snippets[a:snippet_dict.name] = snippet
  let a:dup_check[a:snippet_dict.name] = snippet

  for alias in get(a:snippet_dict, 'alias', [])
    let alias_snippet = copy(snippet)
    let alias_snippet.word = alias
    if exists('*json_encode')
      let alias_snippet.user_data = json_encode({
           \   'snippet': alias_snippet.snip,
           \   'snippet_trigger': alias,
           \ })
    endif

    let a:snippets[alias] = alias_snippet
    let a:dup_check[alias] = alias_snippet
  endfor
endfunction

function! neosnippet#parser#_initialize_snippet(dict, path, line, pattern, name) abort
  let a:dict.word = substitute(a:dict.word, '\n\+$', '', '')

  if !has_key(a:dict, 'abbr') || a:dict.abbr ==# ''
    " Set default abbr.
    let abbr = ''
    let a:dict.abbr = a:dict.name
  else
    let abbr = a:dict.abbr
  endif

  let snippet = {
        \ 'word': a:dict.name, 'snip': a:dict.word,
        \ 'description': a:dict.word,
        \ 'menu_template': abbr,
        \ 'menu_abbr': abbr,
        \ 'info': a:dict.word,
        \ 'options': a:dict.options,
        \ 'real_name': a:name,
        \ 'action__path': a:path,
        \ 'action__line': a:line,
        \ 'action__pattern': a:pattern,
        \}

  if exists('*json_encode')
    let snippet.user_data = json_encode({
          \   'snippet': a:dict.word,
          \   'snippet_trigger': a:dict.name,
          \ })
  endif

  if has_key(a:dict, 'regexp')
    let snippet.regexp = a:dict.regexp
  endif

  return snippet
endfunction

function! neosnippet#parser#_initialize_snippet_options() abort
  return {
        \ 'head' : 0,
        \ 'word' :
        \   g:neosnippet#expand_word_boundary,
        \ 'indent' : 0,
        \ 'oneshot' : 0,
        \ 'lspitem' : 0,
        \ }
endfunction

function! neosnippet#parser#_get_completed_snippet(completed_item, cur_text, next_text) abort
  let item = a:completed_item

  if strridx(a:cur_text, item.word) != len(a:cur_text) - len(item.word)
    return ''
  endif

  " Set abbr
  let abbrs = []
  if get(item, 'info', '') =~# '^.\+('
    call add(abbrs, matchstr(item.info, '^\_s*\zs.*'))
  endif
  if get(item, 'abbr', '') =~# '^.\+('
    call add(abbrs, item.abbr)
  endif
  if get(item, 'menu', '') =~# '^.\+('
    call add(abbrs, item.menu)
  endif
  if item.word =~# '^.\+(' || get(item, 'kind', '') ==# 'f'
    call add(abbrs, item.word)
  endif

  if get(item, 'user_data', '') !=# ''
    let user_data = json_decode(item.user_data)
    if type(user_data) ==# v:t_dict && has_key(user_data, 'lspitem')
      " Use lspitem userdata
      let lspitem = user_data.lspitem
      if has_key(lspitem, 'label')
        call add(abbrs, lspitem.label)
      endif
    endif
  endif

  call map(abbrs, "escape(v:val, '\')")

  " () Only supported
  let pairs = {'(': ')'}
  let no_key = index(keys(pairs), item.word[-1:]) < 0
  let word_pattern = '\<' . neosnippet#util#escape_pattern(item.word)
  let angle_pattern = word_pattern . '<.\+>(.*)'
  let check_pattern = word_pattern . '\%(<.\+>\)\?(.*)'
  let abbrs = filter(abbrs, '!no_key || v:val =~# check_pattern')

  if empty(abbrs)
    return ''
  endif
  let abbr = abbrs[0]

  let key = no_key ? '(' : item.word[-1:]
  if a:next_text[:0] ==# key
    " Disable auto pair
    return ''
  endif

  let pair = pairs[key]

  " Make snippet arguments
  let cnt = 1
  let snippet = ''

  if no_key && abbr !~# angle_pattern
    " Auto key
    let snippet .= key
  endif

  if empty(filter(values(pairs), 'stridx(abbr, v:val) > 0'))
    " Pairs not found pattern
    let snippet .= '${' . cnt . '}'
    let cnt += 1
  endif

  if abbr =~# angle_pattern
    " Add angle analysis
    let snippet .= '<'

    let args = ''
    for arg in split(substitute(
          \ neosnippet#parser#_get_in_paren('<', '>', abbr),
          \ '<\zs.\{-}\ze>', '', 'g'), '[^[]\zs\s*,\s*')
      let args .= neosnippet#parser#_conceal_argument(arg, cnt, args)
      let cnt += 1
    endfor
    let snippet .= args
    let snippet .= '>'

    if no_key
      let snippet .= key
    endif
  endif

  let args = ''
  for arg in split(substitute(
        \ neosnippet#parser#_get_in_paren(key, pair, abbr),
        \ key.'\zs.\{-}\ze'.pair . '\|<\zs.\{-}\ze>', '', 'g'),
        \ '[^[]\zs\s*,\s*')
    if key ==# '(' && (
          \ (&filetype ==# 'python' && arg ==# 'self') ||
          \ (&filetype ==# 'rust' && arg =~# '\m^&\?\(mut \)\?self$'))
      " Ignore self argument
      continue
    endif

    let args .= neosnippet#parser#_conceal_argument(arg, cnt, args)
    let cnt += 1
  endfor
  let snippet .= args

  if key !=# '(' && snippet ==# ''
    let snippet .= '${' . cnt . '}'
    let cnt += 1
  endif

  let snippet .= pair
  let snippet .= '${' . cnt . '}'

  return snippet
endfunction

function! neosnippet#parser#_get_in_paren(key, pair, str) abort
  let s = ''
  let level = 0
  for c in split(a:str, '\zs')
    if c ==# a:key
      let level += 1

      if level == 1
        continue
      endif
    elseif c ==# a:pair
      if level == 1 && (s !=# '' || a:str =~# '()\s*(.\{-})')
        return s
      else
        let level -= 1
      endif
    endif

    if level > 0
      let s .= c
    endif
  endfor

  return ''
endfunction

function! neosnippet#parser#_conceal_argument(arg, cnt, args) abort
  let outside = ''
  let inside = ''
  if a:args !=# ''
    if g:neosnippet#enable_optional_arguments
      let inside = ', '
    else
      let outside = ', '
    endif
  endif
  return printf('%s${%d:#:%s%s}', outside, a:cnt, inside, escape(a:arg, '{}'))
endfunction

function! s:include_snippets(globs) abort
  let snippets = {}
  for glob in a:globs
    let snippets_dir = neosnippet#helpers#get_snippets_directory(
          \ fnamemodify(glob, ':r'))
    for file in split(globpath(join(snippets_dir, ','), glob), '\n')
      call extend(snippets, neosnippet#parser#_parse_snippets(file))
    endfor
  endfor

  return snippets
endfunction
