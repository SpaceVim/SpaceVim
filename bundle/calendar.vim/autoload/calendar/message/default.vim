" =============================================================================
" Filename: autoload/calendar/message/default.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/03/29 06:30:38.
" =============================================================================

scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! calendar#message#default#get() abort
  return extend(s:english_message, s:message())
endfunction

let s:english_message = deepcopy(calendar#message#en#get())

if exists('*strftime')
  function! s:message() abort
    let message = {}
    let message.day_name        = map(range(3, 9), "strftime('%a', 60 * 60 * (24 * v:val + 10))")
    let message.day_name_long   = map(range(3, 9), "strftime('%A', 60 * 60 * (24 * v:val + 10))")
    let message.month_name      = map(range(12), "strftime('%b', 60 * 60 * 24 * (32 * v:val + 5))")
    let message.month_name_long = map(range(12), "strftime('%B', 60 * 60 * 24 * (32 * v:val + 5))")
    return message
  endfunction
else
  function! s:message() abort
    return {}
  endfunction
endif

let &cpo = s:save_cpo
unlet s:save_cpo
