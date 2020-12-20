"=============================================================================
" FILE: defx.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! defx#initialize() abort
  return defx#init#_initialize()
endfunction

function! defx#start(paths, user_context) abort
  let prev_winid = win_getid()

  call defx#initialize()
  let context = defx#init#_context(a:user_context)
  let paths = map(a:paths, "[v:val[0], fnamemodify(v:val[1], ':p')]")

  call defx#util#rpcrequest('_defx_start',
        \ [paths, context], v:false)

  if context['search'] !=# ''
    call defx#call_action('search', [context['search']])
  endif

  if !context['focus']
    " Restore the window
    call win_gotoid(prev_winid)
  endif
endfunction
function! defx#start_candidates(candidates, user_context) abort
  call defx#initialize()
  let context = defx#init#_context(a:user_context)
  let listfile = tempname()
  call writefile(a:candidates, listfile)
  let paths = [['file/list', listfile]]
  call defx#util#rpcrequest('_defx_start',
        \ [paths, context], v:false)
  if context['search'] !=# ''
    call defx#call_action('search', [context['search']])
  endif
endfunction

function! defx#do_action(action, ...) abort
  if &l:filetype !=# 'defx'
    return ''
  endif

  let args = defx#util#convert2list(get(a:000, 0, []))
  return printf(":\<C-u>call defx#call_action(%s, %s)\<CR>",
        \ string(a:action), string(args))
endfunction
function! defx#async_action(action, ...) abort
  if &l:filetype !=# 'defx'
    return ''
  endif

  let args = defx#util#convert2list(get(a:000, 0, []))
  return printf(":\<C-u>call defx#call_async_action(%s, %s)\<CR>",
        \ string(a:action), string(args))
endfunction
function! defx#call_action(action, ...) abort
  if &l:filetype !=# 'defx'
    return
  endif

  let context = defx#init#_context({})
  let args = defx#util#convert2list(get(a:000, 0, []))
  call defx#util#rpcrequest(
        \ '_defx_do_action', [a:action, args, context], v:false)
endfunction
function! defx#call_async_action(action, ...) abort
  if &l:filetype !=# 'defx'
    return
  endif

  let context = defx#init#_context({})
  let args = defx#util#convert2list(get(a:000, 0, []))
  call defx#util#rpcrequest(
        \ '_defx_async_action', [a:action, args, context], v:true)
endfunction
function! defx#redraw() abort
  call defx#util#rpcrequest('_defx_redraw', [], v:false)
endfunction

function! defx#get_candidate() abort
  if &l:filetype !=# 'defx'
    return {}
  endif

  return defx#util#rpcrequest('_defx_get_candidate', [], v:false)
endfunction
function! defx#is_directory() abort
  return get(defx#get_candidate(), 'is_directory', v:false)
endfunction
function! defx#is_opened_tree() abort
  return get(defx#get_candidate(), 'is_opened_tree', v:false)
endfunction
function! defx#get_context() abort
  if &l:filetype !=# 'defx'
    return {}
  endif

  return defx#util#rpcrequest('_defx_get_context', [], v:false)
endfunction
