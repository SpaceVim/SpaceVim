let s:bridge_id = 0
let s:sources = {}

"
" cmp#register_source
"
function! cmp#register_source(name, source) abort
  let l:methods = []
  for l:method in [
  \   'is_available',
  \   'get_debug_name',
  \   'get_position_encoding_kind',
  \   'get_trigger_characters',
  \   'get_keyword_pattern',
  \   'complete',
  \   'execute',
  \   'resolve'
  \ ]
    if has_key(a:source, l:method) && type(a:source[l:method]) == v:t_func
      call add(l:methods, l:method)
    endif
  endfor

  let s:bridge_id += 1
  let a:source.bridge_id = s:bridge_id
  let a:source.id = luaeval('require("cmp").register_source(_A[1], require("cmp.vim_source").new(_A[2], _A[3]))', [a:name, s:bridge_id, l:methods])
  let s:sources[s:bridge_id] = a:source
  return a:source.id
endfunction

"
" cmp#unregister_source
"
function! cmp#unregister_source(id) abort
  if has_key(s:sources, a:id)
    unlet s:sources[a:id]
  endif
  call luaeval('require("cmp").unregister_source(_A)', a:id)
endfunction

"
" cmp#_method
"
function! cmp#_method(bridge_id, method, args) abort
  try
    let l:source = s:sources[a:bridge_id]
    if a:method ==# 'is_available'
      return l:source[a:method]()
    elseif a:method ==# 'get_debug_name'
      return l:source[a:method]()
    elseif a:method ==# 'get_position_encoding_kind'
      return l:source[a:method](a:args[0])
    elseif a:method ==# 'get_keyword_pattern'
      return l:source[a:method](a:args[0])
    elseif a:method ==# 'get_trigger_characters'
      return l:source[a:method](a:args[0])
    elseif a:method ==# 'complete'
      return l:source[a:method](a:args[0], s:callback(a:args[1]))
    elseif a:method ==# 'resolve'
      return l:source[a:method](a:args[0], s:callback(a:args[1]))
    elseif a:method ==# 'execute'
      return l:source[a:method](a:args[0], s:callback(a:args[1]))
    endif
  catch /.*/
    echomsg string({ 'exception': v:exception, 'throwpoint': v:throwpoint })
  endtry
  return v:null
endfunction

"
" s:callback
"
function! s:callback(id) abort
  return { ... -> luaeval('require("cmp.vim_source").on_callback(_A[1], _A[2])', [a:id, a:000]) }
endfunction
