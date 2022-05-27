let s:t_number = type(0)

function! gina#custom#command#option(scheme, query, ...) abort
  if a:query !~# '^--\?\S\+\%(|--\?\S\+\)*$'
    throw gina#core#revelator#error(
          \ 'Invalid query. See :h gina#custom#command#option'
          \)
  endif
  let value = get(a:000, 0, 1)
  let remover = type(value) == s:t_number ? s:build_remover(a:query) : ''
  let preference = gina#custom#preference(a:scheme, 0)
  call add(preference.command.options, [a:query, value, remover])
endfunction

function! gina#custom#command#alias(scheme, alias, ...) abort
  if a:scheme =~# '^/'
    throw gina#core#revelator#error(
          \ '/{pattern} cannot be used to define a command alias'
          \)
  endif
  let preference = gina#custom#preference(a:alias, 0)
  let preference.command.origin = a:scheme
  let preference.command.raw = get(a:000, 0, 0)
endfunction


" Private --------------------------------------------------------------------
function! s:build_remover(query) abort
  let terms = split(a:query, '|')
  let names = map(copy(terms), 'matchstr(v:val, ''^--\?\zs\S\+'')')
  let remover = map(
        \ range(len(terms)),
        \ '(terms[v:val] =~# ''^--'' ? ''--no-'' : ''-!'') . names[v:val]'
        \)
  return join(remover, '|')
endfunction
