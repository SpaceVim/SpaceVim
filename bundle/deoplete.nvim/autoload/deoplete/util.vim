"=============================================================================
" FILE: util.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! deoplete#util#print_error(string, ...) abort
  let name = a:0 ? a:1 : 'deoplete'
  echohl Error | echomsg printf('[%s] %s', name,
        \ deoplete#util#string(a:string)) | echohl None
endfunction
function! deoplete#util#print_warning(string) abort
  echohl WarningMsg | echomsg '[deoplete] '
        \ . deoplete#util#string(a:string) | echohl None
endfunction
function! deoplete#util#print_debug(string) abort
  echomsg '[deoplete] ' . deoplete#util#string(a:string)
endfunction

function! deoplete#util#convert2list(expr) abort
  return type(a:expr) ==# v:t_list ? a:expr : [a:expr]
endfunction
function! deoplete#util#string(expr) abort
  return type(a:expr) ==# v:t_string ? a:expr : string(a:expr)
endfunction

function! deoplete#util#get_input(event) abort
  let mode = mode()
  if a:event ==# 'InsertEnter'
    let mode = 'i'
  endif
  let input = (mode ==# 'i' ? (col('.')-1) : col('.')) >= len(getline('.')) ?
        \      getline('.') :
        \      matchstr(getline('.'),
        \         '^.*\%' . (mode ==# 'i' ? col('.') : col('.') - 1)
        \         . 'c' . (mode ==# 'i' ? '' : '.'))

  if a:event ==# 'InsertCharPre'
    let input .= v:char
  endif

  return input
endfunction
function! deoplete#util#get_next_input(event) abort
  return getline('.')[len(deoplete#util#get_input(a:event)) :]
endfunction

function! deoplete#util#vimoption2python(option) abort
  return '[\w' . s:vimoption2python(a:option) . ']'
endfunction
function! deoplete#util#vimoption2python_not(option) abort
  return '[^\w' . s:vimoption2python(a:option) . ']'
endfunction
function! s:vimoption2python(option) abort
  let has_dash = 0
  let patterns = []
  for pattern in split(a:option, ',')
    if pattern =~# '\d\+'
      let pattern = substitute(pattern, '\d\+',
            \ '\=nr2char(submatch(0))', 'g')
    endif

    if pattern ==# ''
      " ,
      call add(patterns, ',')
    elseif pattern ==# '\'
      call add(patterns, '\\')
    elseif pattern ==# '-'
      let has_dash = 1
    else
      " Avoid ambiguous Python 3 RE syntax for nested sets
      if pattern =~# '^--'
        let pattern = '\' . pattern
      elseif pattern =~# '--$'
        let pattern = split(pattern, '-')[0] . '-\-'
      endif

      call add(patterns, pattern)
    endif
  endfor

  " Dash must be last.
  if has_dash
    call add(patterns, '-')
  endif

  return join(deoplete#util#uniq(patterns), '')
endfunction

function! deoplete#util#uniq(list) abort
  let list = map(copy(a:list), '[v:val, v:val]')
  let i = 0
  let seen = {}
  while i < len(list)
    let key = string(list[i][1])
    if has_key(seen, key)
      call remove(list, i)
    else
      let seen[key] = 1
      let i += 1
    endif
  endwhile
  return map(list, 'v:val[0]')
endfunction

function! deoplete#util#get_syn_names() abort
  if col('$') >= 200
    return []
  endif

  let names = []
  try
    " Note: synstack() seems broken in concealed text.
    for id in synstack(line('.'), (mode() ==# 'i' ? col('.')-1 : col('.')))
      let name = synIDattr(id, 'name')
      call add(names, name)
      if synIDattr(synIDtrans(id), 'name') !=# name
        call add(names, synIDattr(synIDtrans(id), 'name'))
      endif
    endfor
  catch
    " Ignore error
  endtry
  return names
endfunction

function! deoplete#util#neovim_version() abort
  redir => v
  silent version
  redir END
  return split(v, '\n')[0]
endfunction

function! deoplete#util#has_yarp() abort
  return !has('nvim') || deoplete#custom#_get_option('yarp')
endfunction

function! deoplete#util#get_keyword_pattern(filetype) abort
  let keyword_patterns = deoplete#custom#_get_option('keyword_patterns')
  if empty(keyword_patterns)
    let patterns = deoplete#custom#_get_filetype_option(
        \   'keyword_patterns', a:filetype, '')
  else
    let filetype = has_key(keyword_patterns, a:filetype) ? a:filetype : '_'
    let patterns = get(keyword_patterns, filetype, '')
  endif
  let pattern = join(deoplete#util#convert2list(patterns), '|')

  " Convert keyword.
  let k_pattern = deoplete#util#vimoption2python(
        \ &l:iskeyword . (&l:lisp ? ',-' : ''))
  return substitute(pattern, '\\k', '\=k_pattern', 'g')
endfunction

function! deoplete#util#rpcnotify(method, context) abort
  if !deoplete#init#_channel_initialized()
    return ''
  endif

  let a:context['rpc'] = a:method

  if deoplete#util#has_yarp()
    if g:deoplete#_yarp.job_is_dead
      return ''
    endif
    call g:deoplete#_yarp.notify(a:method, a:context)
  else
    call rpcnotify(g:deoplete#_channel_id, a:method, a:context)
  endif

  return ''
endfunction

" Compare versions.  Return values is the distance between versions.  Each
" version integer (from right to left) is an ascending power of 100.
"
" Example:
" '0.1.10' is (1 * 100) + 10, or 110.
" '1.2.3' is (1 * 10000) + (2 * 100) + 3, or 10203.
"
" Returns:
" <0 if a < b
" >0 if a > b
" 0 if versions are equal.
function! deoplete#util#versioncmp(a, b) abort
  let a = map(split(a:a, '\.'), 'str2nr(v:val)')
  let b = map(split(a:b, '\.'), 'str2nr(v:val)')
  let l = min([len(a), len(b)])
  let d = 0

  " Only compare the parts that are common to both versions.
  for i in range(l)
    let d += (a[i] - b[i]) * pow(100, l - i - 1)
  endfor

  return d
endfunction

function! deoplete#util#split(string) abort
  return split(a:string, '\s*,\s*')
endfunction

function! deoplete#util#check_eskk_phase_henkan() abort
  if !exists('b:eskk') || empty(b:eskk)
    return 0
  endif

  let preedit = eskk#get_preedit()
  let phase = preedit.get_henkan_phase()
  return phase is g:eskk#preedit#PHASE_HENKAN
endfunction

function! deoplete#util#check_popup() abort
  return exists('*complete_info') && complete_info().mode ==# 'eval'
endfunction
