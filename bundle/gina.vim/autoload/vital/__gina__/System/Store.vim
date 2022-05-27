let s:t_list = type([])
let s:store_cache = {}

function! s:hash(pathlist) abort
  return sha256(join(sort(a:pathlist)))
endfunction

function! s:get_slug_expr() abort
  return 'matchstr(expand(''<sfile>''), ''\zs[^. ]\+$'')'
endfunction

function! s:of(pathlist) abort
  let pathlist = type(a:pathlist) == s:t_list
        \ ? a:pathlist
        \ : [a:pathlist]
  let hash = s:hash(pathlist)
  if has_key(s:store_cache, hash)
    return s:store_cache[hash]
  endif
  let store = copy(s:store)
  let store.caches = {}
  let store.pathlist = copy(pathlist)
  lockvar store.pathlist
  let s:store_cache[hash] = store
  return store
endfunction

function! s:remove(pathlist) abort
  let pathlist = type(a:pathlist) == s:t_list
        \ ? a:pathlist
        \ : [a:pathlist]
  let hash = s:hash(pathlist)
  silent! unlet s:store_cache[hash]
endfunction


" Store instance -------------------------------------------------------------
let s:store = {}

function! s:store.is_expired(name) abort
  let cache = get(self.caches, a:name, {})
  if empty(cache)
    return 1
  endif
  for i in range(len(self.pathlist))
    let uptime1 = getftime(self.pathlist[i])
    let uptime2 = cache.uptimes[i]
    if uptime1 != uptime2 && (uptime1 == -1 || uptime2 == -1)
      return 1
    elseif uptime1 > uptime2
      return 1
    endif
  endfor
  return 0
endfunction

function! s:store.has(name) abort
  return has_key(self.caches, a:name)
endfunction

function! s:store.get(name, ...) abort
  let default = get(a:000, 0)
  if self.is_expired(a:name)
    return default
  endif
  return self.caches[a:name].cache
endfunction

function! s:store.set(name, value) abort
  let uptimes = map(copy(self.pathlist), 'getftime(v:val)')
  let cache = {
        \ 'cache': a:value,
        \ 'uptimes': uptimes
        \}
  let self.caches[a:name] = cache
  return self
endfunction

function! s:store.remove(name) abort
  silent! unlet self.caches[a:name]
  return self
endfunction

function! s:store.clear() abort
  let self.caches = {}
  return self
endfunction
