" Utilities for output cache.

let s:save_cpo = &cpo
set cpo&vim

function! neobundle#cache#getfilename(cache_dir, filename) abort
  return s:_encode_name(a:cache_dir, a:filename)
endfunction

function! neobundle#cache#filereadable(cache_dir, filename) abort
  let cache_name = s:_encode_name(a:cache_dir, a:filename)
  return filereadable(cache_name)
endfunction

function! neobundle#cache#readfile(cache_dir, filename) abort
  let cache_name = s:_encode_name(a:cache_dir, a:filename)
  return filereadable(cache_name) ? readfile(cache_name) : []
endfunction

function! neobundle#cache#writefile(cache_dir, filename, list) abort
  let cache_name = s:_encode_name(a:cache_dir, a:filename)

  call writefile(a:list, cache_name)
endfunction

function! neobundle#cache#deletefile(cache_dir, filename) abort
  let cache_name = s:_encode_name(a:cache_dir, a:filename)
  return delete(cache_name)
endfunction

function! s:_encode_name(cache_dir, filename) abort
  " Check cache directory.
  if !isdirectory(a:cache_dir)
    call mkdir(a:cache_dir, 'p')
  endif
  let cache_dir = a:cache_dir
  if cache_dir !~ '/$'
    let cache_dir .= '/'
  endif

  return cache_dir . s:_create_hash(cache_dir, a:filename)
endfunction

function! neobundle#cache#check_old_cache(cache_dir, filename) abort
  " Check old cache file.
  let cache_name = s:_encode_name(a:cache_dir, a:filename)
  let ret = getftime(cache_name) == -1
        \ || getftime(cache_name) <= getftime(a:filename)
  if ret && filereadable(cache_name)
    " Delete old cache.
    call delete(cache_name)
  endif

  return ret
endfunction

function! s:_create_hash(dir, str) abort
  if len(a:dir) + len(a:str) < 150
    let hash = substitute(substitute(
          \ a:str, ':', '=-', 'g'), '[/\\]', '=+', 'g')
  elseif exists('*sha256')
    let hash = sha256(a:str)
  else
    " Use simple hash.
    let sum = 0
    for i in range(len(a:str))
      let sum += char2nr(a:str[i]) * (i + 1)
    endfor

    let hash = printf('%x', sum)
  endif

  return hash
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0:
