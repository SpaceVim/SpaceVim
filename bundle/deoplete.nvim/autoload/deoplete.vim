"=============================================================================
" FILE: deoplete.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! deoplete#initialize() abort
  return deoplete#init#_initialize()
endfunction
function! deoplete#is_enabled() abort
  return deoplete#init#_is_handler_enabled()
endfunction
function! deoplete#enable() abort
  if has('vim_starting')
    augroup deoplete
      autocmd!
      autocmd VimEnter * call deoplete#enable()
    augroup END
    return 1
  endif

  if deoplete#initialize() && deoplete#is_enabled()
    return 1
  endif
  return deoplete#init#_enable_handler()
endfunction
function! deoplete#disable() abort
  call deoplete#initialize()
  return deoplete#init#_disable_handler()
endfunction
function! deoplete#toggle() abort
  call deoplete#initialize()
  return deoplete#is_enabled() ?
        \ deoplete#init#_disable_handler() :
        \ deoplete#init#_enable_handler()
endfunction

function! deoplete#enable_logging(level, logfile) abort
  let g:deoplete#_logging = {'level': a:level, 'logfile': a:logfile}
  call deoplete#util#rpcnotify('deoplete_enable_logging', {})
endfunction

function! deoplete#send_event(event, ...) abort
  if &l:previewwindow
    return
  endif

  let sources = deoplete#util#convert2list(get(a:000, 0, []))
  call deoplete#util#rpcnotify('deoplete_on_event',
        \ {'event': a:event, 'sources': sources})
endfunction

function! deoplete#complete() abort
  return deoplete#mapping#_dummy('deoplete#mapping#_complete')
endfunction
function! deoplete#auto_complete(...) abort
  return deoplete#handler#_completion_begin(get(a:000, 0, 'Async'))
endfunction
function! deoplete#manual_complete(...) abort
  if !deoplete#is_enabled()
    return ''
  endif

  call deoplete#init#_prev_completion()

  " Start complete.
  return "\<C-r>=deoplete#mapping#_rpcrequest_wrapper("
        \ . string(get(a:000, 0, [])) . ")\<CR>"
endfunction
function! deoplete#close_popup() abort
  call deoplete#handler#_skip_next_completion()
  return pumvisible() ? "\<C-y>" : ''
endfunction
function! deoplete#smart_close_popup() abort
  return pumvisible() ? "\<C-e>" : ''
endfunction
function! deoplete#cancel_popup() abort
  call deoplete#handler#_skip_next_completion()
  return pumvisible() ? "\<C-e>" : ''
endfunction
function! deoplete#insert_candidate(number) abort
  return deoplete#mapping#_insert_candidate(a:number)
endfunction
function! deoplete#undo_completion() abort
  return deoplete#mapping#_undo_completion()
endfunction
function! deoplete#complete_common_string() abort
  return deoplete#mapping#_complete_common_string()
endfunction
function! deoplete#can_complete() abort
  return !empty(get(get(g:, 'deoplete#_context', {}), 'candidates', []))
        \ && deoplete#mapping#_can_complete()
endfunction
