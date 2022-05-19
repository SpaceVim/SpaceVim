function! gina#core#tracker#track(git, path, lnum, ...) abort
  let options = extend({
        \ 'lhs': '',
        \ 'rhs': 'HEAD',
        \ 'cache': 0,
        \}, a:0 ? a:1 : {}
        \)
  let result = s:investigate(
        \ a:git, a:path,
        \ options.lhs,
        \ options.rhs,
        \ options.cache
        \)
  let offset = 0
  for ref in result.refs
    if a:lnum > ref.ll && a:lnum < (ref.ll + ref.ls)
      let offset = a:lnum - ref.ll
      return offset <= ref.rs ? ref.rl + offset : ref.rl + ref.rs
    elseif a:lnum > ref.ll
      let offset += (ref.rs - ref.ls)
    else
      break
    endif
  endfor
  return a:lnum + offset
endfunction


function! s:investigate(git, path, lhs, rhs, cache) abort
  let result = gina#process#call_or_fail(a:git, filter([
        \ 'diff',
        \ '--unified=0',
        \ '--dst-prefix=',
        \ '--find-renames',
        \ '--inter-hunk-context=0',
        \ a:cache ? '--cache' : '',
        \ printf('%s..%s', a:lhs, a:rhs),
        \ '--',
        \ a:path,
        \], '!empty(v:val)'))
  let path = get(filter(copy(result.stdout), 'v:val =~# ''^+++'''), 0, a:path)
  let path = substitute(path, '^+++ ', '', '')
  let refs = map(
        \ filter(copy(result.stdout), 'v:val =~# ''^@@'''),
        \ 's:extract_ranges(v:val)'
        \)
  return {
        \ 'path': path,
        \ 'refs': refs,
        \}
endfunction

function! s:extract_ranges(record) abort
  let m = matchlist(
        \ a:record,
        \ '^@@ -\(\d\+\%(,\d\+\)\?\) +\(\d\+\%(,\d\+\)\?\) @@',
        \)
  let lhs = split(m[1], ',')
  let rhs = split(m[2], ',')
  return {
        \ 'll': abs(0 + lhs[0]),
        \ 'ls': 0 + get(lhs, 1, 1),
        \ 'rl': abs(0 + rhs[0]),
        \ 'rs': 0 + get(rhs, 1, 1),
        \}
endfunction
