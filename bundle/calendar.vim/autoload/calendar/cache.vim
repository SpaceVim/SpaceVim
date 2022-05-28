" =============================================================================
" Filename: autoload/calendar/cache.vim
" Author: itchyny
" License: MIT License
" Last Change: 2020/11/20 00:09:42.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Cache object.
function! calendar#cache#new(...) abort
  let self = copy(s:self)
  let self.subpath = a:0 ? a:1 : ''
  let self.subpath .= len(self.subpath) && self.subpath[len(self.subpath) - 1] !~ '^[/\\]$' ? '/' : ''
  call s:setfperm_dir(self.dir())
  return self
endfunction

function! calendar#cache#clear() abort
  for path in s:clearpath
    call calendar#util#rmdir(path, 'rf')
  endfor
endfunction

let s:clearpath = []

augroup CalendarCache
  autocmd!
  autocmd VimLeavePre * call calendar#cache#clear()
augroup END

let s:self = {}

function! s:self.new(...) dict abort
  return calendar#cache#new(self.subpath . (a:0 ? self.escape(a:1) : ''))
endfunction

function! s:self.escape(key) dict abort
  return substitute(a:key, '[^a-zA-Z0-9_.-]', '\=printf("%%%02X",char2nr(submatch(0)))', 'g')
endfunction

if has('win32')
  function! s:self.dir() dict abort
    return substitute(substitute(s:expand_homedir(calendar#setting#get('cache_directory')), '[/\\]$', '', '') . '/' . self.subpath, '/', '\', 'g')
  endfunction
else
  function! s:self.dir() dict abort
    return substitute(s:expand_homedir(calendar#setting#get('cache_directory')), '[/\\]$', '', '') . '/' . self.subpath
  endfunction
endif

function! s:expand_homedir(path) abort
  if a:path !~# '^[~]/'
    return a:path
  endif
  return expand('~') . a:path[1:]
endfunction

function! s:self.path(key) dict abort
  return self.dir() . self.escape(a:key)
endfunction

function! s:self.rmdir_on_exit() dict abort
  call add(s:clearpath, self.dir())
endfunction

function! s:self.check_dir(...) dict abort
  let dir = self.dir()
  if !get(a:000, 0)
    return !isdirectory(dir)
  endif
  if !isdirectory(dir)
    try
      if exists('*mkdir')
        call mkdir(dir, 'p')
      else
        call calendar#util#system('mkdir -p ' .  shellescape(dir))
      endif
      call s:setfperm(dir)
    catch
    endtry
  endif
  if !isdirectory(dir)
    call calendar#echo#error(calendar#message#get('mkdir_fail') . ': ' . dir)
    return 1
  endif
endfunction

function! s:self.save(key, val) dict abort
  if self.check_dir(1)
    return 1
  endif
  let path = self.path(a:key)
  if filereadable(path) && !filewritable(path)
    call calendar#echo#error(calendar#message#get('cache_file_unwritable') . ': ' . path)
    return 1
  endif
  try
    call writefile(calendar#cache#string(a:val), path)
    call s:setfperm_file(path)
  catch
    call calendar#echo#error(calendar#message#get('cache_write_fail') . ': ' . path)
    return 1
  endtry
endfunction

function! s:self.get(key) dict abort
  if self.check_dir()
    return 1
  endif
  let path = self.path(a:key)
  if filereadable(path)
    call s:setfperm_file(path)
    let result = readfile(path)
    try
      if len(result)
        if exists('*js_decode') && has('patch-8.0.0216')
          return js_decode(len(result) > 1 ? join(result, '') : result[0])
        endif
        sandbox return eval(join(result, ''))
      else
        return 1
      endif
    catch
      return 1
    endtry
  else
    return 1
  endif
endfunction

function! s:self.get_raw(key) dict abort
  if self.check_dir()
    return 1
  endif
  let path = self.path(a:key)
  if filereadable(path)
    call s:setfperm_file(path)
    return readfile(path)
  else
    return 1
  endif
endfunction

function! s:self.delete(key) dict abort
  if self.check_dir()
    return 1
  endif
  let path = self.path(a:key)
  return delete(path)
endfunction

function! s:self.clear() dict abort
  call calendar#util#rmdir(self.dir(), 'rf')
endfunction

if exists('*json_encode')
  function! calendar#cache#string(v) abort
    return [json_encode(a:v)]
  endfunction
else
  " string() with making newlines and indents properly.
  function! calendar#cache#string(v, ...) abort
    let r = []
    let f = 1
    let s = a:0 ? a:1 : ''
    if type(a:v) == type([])
      call add(r, '[ ')
      let s .= '  '
      for i in range(len(a:v))
        call add(r, s . string(a:v[i]) . ',')
      endfor
      if r[-1][len(r[-1]) - 1] ==# ','
        let r[-1] = r[-1][:-2]
      endif
      call add(r, ' ]')
    elseif type(a:v) == type({})
      call add(r, '{ ')
      let s .= '  '
      for k in keys(a:v)
        if type(a:v[k]) == type({}) || type(a:v[k]) == type([]) && len(a:v[k]) > 2
          let result = calendar#cache#string(a:v[k], s . repeat(' ', len(string(k)) + 2))
          let result[-1] .= ','
          call add(r, s . string(k) . ': ' . result[0])
          call remove(result, 0)
          call extend(r, result)
        else
          call add(r, s . string(k) . ': ' . string(a:v[k]) . ',')
        endif
      endfor
      if r[-1][len(r[-1]) - 1] ==# ','
        let r[-1] = r[-1][:-2]
      endif
      call add(r, ' }')
    else
      call add(r, s . string(a:v))
      let f = 0
    endif
    if f
      if len(r[1]) > len(s) + 1
        let r[1] = r[1][len(s):]
      endif
      let r[0] .= r[1]
      call remove(r, 1)
      if len(r) > 1
        let r[-2] .= r[-1]
        call remove(r, -1)
      endif
    endif
    return r
  endfunction
endif

if exists('*getfperm') && exists('*setfperm')
  function! s:setfperm_dir(dir) abort
    let expected = 'rwx------'
    if getfperm(a:dir) !=# expected
      call setfperm(a:dir, expected)
    endif
  endfunction
  function! s:setfperm_file(path) abort
    let expected = 'rw-------'
    if getfperm(a:path) !=# expected
      call setfperm(a:path, expected)
    endif
  endfunction
else
  function! s:setfperm_dir(dir) abort
  endfunction
  function! s:setfperm_file(path) abort
  endfunction
endif

let &cpo = s:save_cpo
unlet s:save_cpo
