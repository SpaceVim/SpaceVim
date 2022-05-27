let s:Emitter = vital#gina#import('App.Emitter')
let s:modified_timer = v:null


function! gina#core#emitter#emit(name, ...) abort
  call call(s:Emitter.emit, [a:name] + a:000, s:Emitter)
endfunction

function! gina#core#emitter#subscribe(name, listener, ...) abort
  call call(s:Emitter.subscribe, [a:name, a:listener] + a:000, s:Emitter)
endfunction

function! gina#core#emitter#unsubscribe(name, listener, ...) abort
  call call(s:Emitter.unsubscribe, [a:name, a:listener] + a:000, s:Emitter)
endfunction

function! gina#core#emitter#add_middleware(middleware) abort
  call call(s:Emitter.add_middleware, [a:middleware] + a:000, s:Emitter)
endfunction

function! gina#core#emitter#remove_middleware(...) abort
  call call(s:Emitter.remove_middleware, a:000, s:Emitter)
endfunction


" Subscribe ------------------------------------------------------------------
function! s:on_modified(...) abort
  if !empty(gina#process#runnings())
    " DO NOT update if there are some running process
    call gina#core#emitter#emit('modified:delay')
    return
  endif
  let winid_saved = win_getid()
  for winnr in range(1, winnr('$'))
    let bufnr = winbufnr(winnr)
    if !getbufvar(bufnr, '&modified')
          \ && getbufvar(bufnr, '&autoread')
          \ && bufname(bufnr) =~# '^gina://'
      call win_gotoid(bufwinid(bufnr))
      edit
    endif
  endfor
  call win_gotoid(winid_saved)
endfunction

function! s:on_modified_delay() abort
  if s:modified_timer isnot# v:null
    " Do not emit 'modified' for previous 'modified:delay'
    silent! call timer_stop(s:modified_timer)
  endif
  let s:modified_timer = timer_start(
        \ g:gina#core#emitter#modified_delay,
        \ function('s:emit_modified')
        \)
endfunction

function! s:emit_modified(...) abort
  call gina#core#emitter#emit('modified')
endfunction

if !exists('s:subscribed')
  let s:subscribed = 1
  call gina#core#emitter#subscribe(
        \ 'modified',
        \ function('s:on_modified')
        \)

  call gina#core#emitter#subscribe(
        \ 'modified:delay',
        \ function('s:on_modified_delay')
        \)
endif


call gina#config(expand('<sfile>'), {
      \ 'modified_delay': 10,
      \})
