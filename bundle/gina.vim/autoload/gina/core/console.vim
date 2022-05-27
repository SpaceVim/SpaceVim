let s:Console = vital#gina#import('Vim.Console')
let s:Console.prefix = '[gina] '


if has('nvim')
  function! gina#core#console#message(msg) abort
    return s:message(a:msg)
  endfunction
else
  " NOTE:
  " Vim 8.0.0329 will not echo entire message which was invoked in timer/job.
  " While echo pipe is used to inform the result of the process to a user, it
  " is kind critical so use autocmd to forcedly invoke message.
  let s:message_queue = []
  function! gina#core#console#message(msg) abort
    augroup gina_core_console_message_internal
      autocmd! *
      autocmd CursorMoved * call s:message_callback()
      autocmd CursorHold  * call s:message_callback()
      autocmd InsertEnter * call s:message_callback()
    augroup END
    call add(s:message_queue, a:msg)
  endfunction

  function! s:message_callback() abort
    while !empty(s:message_queue)
      let msg = remove(s:message_queue, 0)
      call s:message(msg)
    endwhile
    augroup gina_core_console_message_internal
      autocmd! *
    augroup END
  endfunction
endif

function! gina#core#console#echo(...) abort
  return call(s:Console.echo, a:000, s:Console)
endfunction

function! gina#core#console#echon(...) abort
  return call(s:Console.echon, a:000, s:Console)
endfunction

function! gina#core#console#echomsg(...) abort
  return call(s:Console.echomsg, a:000, s:Console)
endfunction

function! gina#core#console#debug(...) abort
  return call(s:Console.debug, a:000, s:Console)
endfunction

function! gina#core#console#info(...) abort
  return call(s:Console.info, a:000, s:Console)
endfunction

function! gina#core#console#warn(...) abort
  return call(s:Console.warn, a:000, s:Console)
endfunction

function! gina#core#console#error(...) abort
  return call(s:Console.error, a:000, s:Console)
endfunction

function! gina#core#console#ask(...) abort
  return call(s:Console.ask, a:000, s:Console)
endfunction

function! gina#core#console#confirm(...) abort
  return call(s:Console.confirm, a:000, s:Console)
endfunction

function! gina#core#console#ask_or_cancel(...) abort
  let result = call(s:Console.ask, a:000, s:Console)
  if empty(result)
    throw gina#core#revelator#info('Canceled')
  endif
  return result
endfunction

function! s:message(msg) abort
  if g:gina#core#console#enable_message_history
    return gina#core#console#echomsg(a:msg)
  endif
  return gina#core#console#echo(a:msg)
endfunction

call gina#config(expand('<sfile>'), {
      \ 'enable_message_history': 0,
      \})
