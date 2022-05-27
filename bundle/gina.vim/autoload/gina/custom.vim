let s:preferences = {}
let s:pattern_preferences = {}

function! gina#custom#preference(scheme, ...) abort
  let readonly = a:0 ? a:1 : 1
  let preferences = a:scheme =~# '^/'
        \ ? s:pattern_preferences
        \ : s:preferences
  let preferences[a:scheme] = get(preferences, a:scheme, {})
  let preference = extend(preferences[a:scheme], {
        \ 'action': {
        \   'aliases': [],
        \   'shortens': [],
        \ },
        \ 'mapping': {
        \   'mappings': [],
        \ },
        \ 'command': {
        \   'options': [],
        \   'origin': a:scheme,
        \   'raw': 0,
        \ },
        \ 'executes': [],
        \}, 'keep'
        \)
  return readonly ? deepcopy(preference) : preference
endfunction

function! gina#custom#preferences(scheme) abort
  let preferences = []
  for [pattern, preference] in items(s:pattern_preferences)
    if a:scheme =~# pattern[1:]
      call add(preferences, preference)
    endif
  endfor
  return extend(
        \ deepcopy(preferences),
        \ [gina#custom#preference(a:scheme)]
        \)
endfunction

function! gina#custom#clear() abort
  let s:preferences = {}
  let s:pattern_preferences = {}
endfunction

function! gina#custom#execute(scheme, expr) abort
  let value = get(a:000, 0, 1)
  let preference = gina#custom#preference(a:scheme, 0)
  call add(preference.executes, [a:expr])
endfunction


" Private --------------------------------------------------------------------
function! s:apply_preference(preference) abort
  for [expr] in a:preference.executes
    execute expr
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
augroup gina_custom_internal
  autocmd! *
  autocmd FileType * call s:FileType()
augroup END
