function! gina#custom#mapping#map(scheme, lhs, rhs, ...) abort
  let options = get(a:000, 0, {})
  let preference = gina#custom#preference(a:scheme, 0)
  call add(preference.mapping.mappings, [a:lhs, a:rhs, options])
endfunction

function! gina#custom#mapping#nmap(scheme, lhs, rhs, ...) abort
  let options = get(a:000, 0, {})
  let options.mode = 'n'
  call gina#custom#mapping#map(a:scheme, a:lhs, a:rhs, options)
endfunction

function! gina#custom#mapping#vmap(scheme, lhs, rhs, ...) abort
  let options = get(a:000, 0, {})
  let options.mode = 'v'
  call gina#custom#mapping#map(a:scheme, a:lhs, a:rhs, options)
endfunction

function! gina#custom#mapping#imap(scheme, lhs, rhs, ...) abort
  let options = get(a:000, 0, {})
  let options.mode = 'i'
  call gina#custom#mapping#map(a:scheme, a:lhs, a:rhs, options)
endfunction


" Private --------------------------------------------------------------------
function! s:apply_preference(preference) abort
  for [lhs, rhs, options] in a:preference.mapping.mappings
    call gina#util#map(lhs, rhs, options)
  endfor
endfunction

function! s:FileType() abort
  let scheme = gina#core#buffer#param('%', 'scheme')
  if empty(scheme)
    return
  endif
  for preference in gina#custom#preferences(scheme)
    call s:apply_preference(preference)
  endfor
endfunction


" Autocmd --------------------------------------------------------------------
augroup gina_custom_mapping_internal
  autocmd! *
  autocmd FileType * call s:FileType()
augroup END
