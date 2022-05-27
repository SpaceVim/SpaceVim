function! gina#custom#action#alias(scheme, alias, origin) abort
  let preference = gina#custom#preference(a:scheme, 0)
  call add(preference.action.aliases, [a:alias, a:origin])
endfunction

function! gina#custom#action#shorten(scheme, action_scheme, ...) abort
  let excludes = get(a:000, 0, [])
  let preference = gina#custom#preference(a:scheme, 0)
  call add(preference.action.shortens, [a:action_scheme, excludes])
endfunction


" Private --------------------------------------------------------------------
function! s:apply_preference(preference) abort
  for [alias, origin] in a:preference.action.aliases
    call gina#action#alias(alias, origin)
  endfor
  for [action_scheme, excludes] in a:preference.action.shortens
    call gina#action#shorten(action_scheme, excludes)
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
augroup gina_custom_action_internal
  autocmd! *
  autocmd FileType * call s:FileType()
augroup END
