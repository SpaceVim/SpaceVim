let s:Revelator = vital#gina#import('App.Revelator')


function! gina#core#revelator#cancel() abort
  return call(s:Revelator.message, ['CANCEL', ''], s:Revelator)
endfunction

function! gina#core#revelator#info(msg) abort
  return call(s:Revelator.info, [a:msg], s:Revelator)
endfunction

function! gina#core#revelator#warning(msg) abort
  return call(s:Revelator.warning, [a:msg], s:Revelator)
endfunction

function! gina#core#revelator#error(msg) abort
  return call(s:Revelator.error, [a:msg], s:Revelator)
endfunction

function! gina#core#revelator#critical(msg) abort
  return call(s:Revelator.critical, [a:msg], s:Revelator)
endfunction

function! gina#core#revelator#call(funcref, args, ...) abort
  return call(s:Revelator.call, [a:funcref, a:args] + a:000, s:Revelator)
endfunction


" Private --------------------------------------------------------------------
function! s:receiver(revelation) abort
  if a:revelation.category ==# 'CANCEL'
    return 1
  elseif a:revelation.category ==# 'INFO'
    redraw
    call gina#core#console#info(a:revelation.message)
    call gina#core#console#debug(a:revelation.throwpoint)
    return 1
  elseif a:revelation.category ==# 'WARNING'
    redraw
    call gina#core#console#warn(a:revelation.message)
    call gina#core#console#debug(a:revelation.throwpoint)
    return 1
  elseif a:revelation.category ==# 'ERROR'
    redraw
    call gina#core#console#error(a:revelation.message)
    call gina#core#console#debug(a:revelation.throwpoint)
    return 1
  elseif a:revelation.category ==# 'CRITICAL'
    redraw
    call gina#core#console#error(a:revelation.message)
    call gina#core#console#error(a:revelation.throwpoint)
    return 1
  endif
endfunction

call s:Revelator.unregister(s:Revelator.get_default_receiver())
call s:Revelator.register(function('s:receiver'))
