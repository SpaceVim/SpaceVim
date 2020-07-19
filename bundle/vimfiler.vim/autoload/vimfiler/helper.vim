"=============================================================================
" FILE: helper.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! vimfiler#helper#_get_directory_files(directory, ...) abort
  " Save current files.

  let is_manualed = get(a:000, 0, 0)

  let context = {
        \ 'vimfiler__is_dummy' : 0,
        \ 'is_redraw' : is_manualed,
        \ }
  let path = a:directory
  if path !~ '^\a\w*:'
    let path = b:vimfiler.source . ':' . path
  endif
  let args = vimfiler#parse_path(path)
  let current_files = vimfiler#init#_candidates(
        \ unite#get_vimfiler_candidates([args], context),
        \ b:vimfiler.source)

  for file in current_files
    " Initialize.
    let file.vimfiler__is_marked = 0
    let file.vimfiler__is_opened = 0
    let file.vimfiler__nest_level = 0
  endfor

  return vimfiler#helper#_sort_files(current_files)
endfunction
function! vimfiler#helper#_sort_files(files) abort
  let files = a:files
  let dirs = filter(copy(a:files), 'v:val.vimfiler__is_directory')
  let files = filter(copy(a:files), '!v:val.vimfiler__is_directory')
  if g:vimfiler_directory_display_top
    let files = s:sort(dirs, b:vimfiler.local_sort_type)
          \+ s:sort(files, b:vimfiler.local_sort_type)
  else
    let files = s:sort(files + dirs, b:vimfiler.local_sort_type)
  endif

  return files
endfunction
function! vimfiler#helper#_parse_path(path) abort
  let path = a:path

  let source_name = matchstr(path, '^\h[^:]*\ze:')
  if (vimfiler#util#is_windows() && len(source_name) == 1)
        \ || source_name == ''
    " Default source.
    let source_name = 'file'
    let source_arg = path
    if vimfiler#util#is_win_path(source_arg)
      let source_arg = vimfiler#util#substitute_path_separator(
            \ fnamemodify(expand(source_arg), ':p'))
    endif
  else
    let source_arg = path[len(source_name)+1 :]
  endif

  let source_args = source_arg  == '' ? [] :
        \  map(split(source_arg, '\\\@<!:', 1),
        \      'substitute(v:val, ''\\\(.\)'', "\\1", "g")')

  return insert(source_args, source_name)
endfunction
function! vimfiler#helper#_get_cd_path(dir) abort
  let dir = vimfiler#util#substitute_path_separator(a:dir)

  if dir =~ '^\h\w*:'
    " Parse path.
    let ret = vimfiler#parse_path(dir)
    let b:vimfiler.source = ret[0]
    let dir = join(ret[1:], ':')
  elseif a:dir !=# b:vimfiler.current_dir
    let b:vimfiler.source = 'file'
  endif

  let current_dir = b:vimfiler.current_dir

  if dir == '..'
    let chars = split(current_dir, '\zs')
    if count(chars, '/') <= 1
      if count(chars, ':') < 1
            \ || b:vimfiler.source ==# 'file'
        " Ignore.
        return current_dir
      endif
      let dir = substitute(current_dir, ':[^:]*$', '', '')
    else
      let dir = fnamemodify(substitute(current_dir, '[/\\]$', '', ''), ':h')
    endif

    if dir == '//'
      return current_dir . '/home'
    endif

  elseif dir == '/'
    " Root.

    if vimfiler#util#is_windows() && current_dir =~ '^//'
      " For UNC path.
      let dir = matchstr(current_dir, '^//[^/]*/[^/]*')
    else
      let dir = vimfiler#util#is_windows() ?
            \ matchstr(fnamemodify(current_dir, ':p'),
            \         '^\a\+:[/\\]') : dir
    endif
  elseif dir == '~'
    " Home.
    let dir = expand('~')
  elseif dir =~ ':'
        \ || (vimfiler#util#is_windows() && dir =~ '^//')
        \ || (!vimfiler#util#is_windows() && dir =~ '^/')
    " Network drive or absolute path.
  elseif b:vimfiler.source ==# 'file'
    " Relative path.
    let dir = simplify(current_dir . dir)
  endif
  let fullpath = vimfiler#util#substitute_path_separator(dir)

  if vimfiler#util#is_windows()
    let fullpath = vimfiler#util#resolve(fullpath)
  endif

  if fullpath !~ '/$'
    let fullpath .= '/'
  endif

  return fullpath
endfunction

function! vimfiler#helper#_complete(arglead, cmdline, cursorpos) abort
  let _ = []

  " Option names completion.
  let _ +=  filter(vimfiler#variables#options(),
        \ 'stridx(v:val, a:arglead) == 0')

  " Source path completion.
  let _ += vimfiler#complete_path(a:arglead,
        \ join(split(a:cmdline)[1:]), a:cursorpos)

  let args = split(join(split(a:cmdline,
        \ '\\\@<!\s\+')[1:]), '\\\@<!\s\+')
  if !empty(args) && args[-1] !=# a:arglead
    call map(_, "v:val[len(args[-1])-len(a:arglead) :]")
  endif

  return sort(_)
endfunction
function! vimfiler#helper#_complete_path(arglead, cmdline, cursorpos) abort
  let ret = vimfiler#parse_path(a:cmdline)
  let source_name = ret[0]
  let source_args = ret[1:]

  let _ = []

  " Source args completion.
  let _ += unite#vimfiler_complete(
        \ [insert(copy(source_args), source_name)],
        \ join(source_args, ':'), a:cmdline, a:cursorpos)

  if a:arglead !~ ':'
    " Source name completion.
    let _ += map(filter(unite#get_vimfiler_source_names(),
          \ 'stridx(v:val, a:arglead) == 0'), 'v:val.":"')
  else
    " Add "{source-name}:".
    let _  = map(_, 'source_name.":".v:val')
  endif

  let args = split(join(split(a:cmdline,
        \ '\\\@<!\s\+')[1:]), '\\\@<!\s\+')
  if !empty(args) && args[-1] !=# a:arglead
    call map(_, "v:val[len(args[-1])-len(a:arglead) :]")
  endif

  return sort(_)
endfunction

function! vimfiler#helper#_get_file_directory(...) abort
  let line_num = get(a:000, 0, line('.'))

  let file = vimfiler#get_file(b:vimfiler, line_num)
  if empty(file)
    let directory = b:vimfiler.current_dir
  else
    let directory = unite#helper#get_candidate_directory(file)

    if file.vimfiler__is_directory
          \ && !file.vimfiler__is_opened
      let directory = vimfiler#util#substitute_path_separator(
            \ fnamemodify(directory, ':h'))
    endif
  endif

  return directory
endfunction


function! vimfiler#helper#_get_buffer_directory(bufnr) abort
  let filetype = getbufvar(a:bufnr, '&filetype')
  if filetype ==# 'vimfiler'
    let dir = getbufvar(a:bufnr, 'vimfiler').current_dir
  elseif filetype ==# 'vimshell'
    let dir = getbufvar(a:bufnr, 'vimshell').current_dir
  elseif filetype ==# 'vinarise'
    let dir = getbufvar(a:bufnr, 'vinarise').current_dir
  elseif filetype ==# 'deol'
    let dir = t:deol.cwd
  else
    let path = vimfiler#util#substitute_path_separator(bufname(a:bufnr))
    let dir = vimfiler#util#path2directory(path)
  endif

  return dir
endfunction

function! vimfiler#helper#_set_cursor() abort
  let pos = getpos('.')
  execute 'normal!' (line('.') <= winheight(0) ? 'zb' :
        \ line('$') - line('.') > winheight(0) ? 'zz' : line('$').'zb')
  call setpos('.', pos)
endfunction

function! vimfiler#helper#_call_filters(files, context) abort
  let files = a:files
  for filter in b:vimfiler.filters
    let files = filter.filter(files, a:context)
  endfor
  return files
endfunction

function! s:sort(files, type) abort
  let ignorecase_save = &ignorecase
  try
    let &ignorecase = vimfiler#util#is_windows()

    if a:type =~? '^n\%[one]$'
      " Ignore.
      let files = a:files
    elseif a:type =~? '^s\%[ize]$'
      let files = vimfiler#util#sort_by(
            \ a:files, 'v:val.vimfiler__filesize')
    elseif a:type =~? '^e\%[xtension]$'
      let files = vimfiler#util#sort_by(
            \ a:files, 'v:val.vimfiler__extension')
    elseif a:type =~? '^f\%[ilename]$'
      let files = vimfiler#helper#_sort_human(
            \ a:files, vimfiler#util#has_lua())
    elseif a:type =~? '^t\%[ime]$'
      let files = vimfiler#util#sort_by(
            \ a:files, 'v:val.vimfiler__filetime')
    elseif a:type =~? '^m\%[anual]$'
      " Not implemented.
      let files = a:files
    else
      throw 'Invalid sort type.'
    endif
  finally
    let &ignorecase = ignorecase_save
  endtry

  if a:type =~ '^\u'
    " Reverse order.
    let files = reverse(files)
  endif

  return files
endfunction

function! vimfiler#helper#_sort_human(candidates, has_lua) abort
  if !a:has_lua || len(filter(copy(a:candidates),
        \ "v:val.vimfiler__filename =~ '\\d'")) >= 2
    return sort(a:candidates, 's:compare_filename')
  endif

  " Use lua interface.
  lua << EOF
do
  local ignorecase = vim.eval('&ignorecase')
  local candidates = vim.eval('a:candidates')
  local t = {}
  for i = 1, #candidates do
    t[i] = candidates[i-1]
    if ignorecase ~= 0 then
      t[i].vimfiler__filename = string.lower(t[i].vimfiler__filename)
    end
  end

  table.sort(t, function(a, b)
    return a.vimfiler__filename < b.vimfiler__filename
  end)

  for i = 0, #candidates-1 do
    candidates[i] = t[i+1]
  end
end
EOF
  return a:candidates
endfunction

" Compare filename by human order.
function! s:compare_filename(i1, i2) abort
  let words_1 = s:get_words(a:i1.vimfiler__filename)
  let words_2 = s:get_words(a:i2.vimfiler__filename)
  let words_1_len = len(words_1)
  let words_2_len = len(words_2)

  for i in range(0, min([words_1_len, words_2_len])-1)
    if words_1[i] >? words_2[i]
      return 1
    elseif words_1[i] <? words_2[i]
      return -1
    endif
  endfor

  return words_1_len - words_2_len
endfunction

function! s:get_words(filename) abort
  let words = []
  for split in split(a:filename, '\d\+\zs\ze')
    let words += split(split, '\D\zs\ze\d\+')
  endfor

  return map(words, "v:val =~ '^\\d\\+$' ? str2nr(v:val) : v:val")
endfunction
