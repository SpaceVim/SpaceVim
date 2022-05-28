" =============================================================================
" Filename: autoload/calendar/setting.vim
" Author: itchyny
" License: MIT License
" Last Change: 2020/10/17 01:28:47.
" =============================================================================

scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" Obtaining settings.
"    1: b:_calendar[option] is set by :Calendar -option=value
"    2: g:calendar_option is set in vimrc. let g:calendar_option = value
"    3: s:option() is the default value.
" Firstly, check the buffer variable if exists. It is set from argument. See
" calendar#new(args) for more detail. If the buffer was not found as a buffer
" variable, check the global variable. A user can set the variable in the vimrc
" file. Lastly, returns the default setting. All the default settings are
" defined in this file. Conversely, all the variables defined in this file can
" be configured by users from their vimrc file.
function! calendar#setting#get(name) abort
  return get(get(b:, '_calendar', {}), a:name, get(g:, 'calendar_' . a:name, s:{a:name}()))
endfunction

function! calendar#setting#get_default(name) abort
  return s:{a:name}()
endfunction

function! s:locale() abort
  return substitute(v:lang, '[.-]', '_', 'g')
endfunction

function! s:calendar() abort
  return 'default'
endfunction

function! s:calendar_candidates() abort
  return 0
endfunction

function! s:first_day() abort
  return v:lang =~# '\v(US|CA|JP|IL)|^(ja)' ? 'sunday' : 'monday'
endfunction

let s:t = strftime('%z')
function! s:time_zone() abort
  return s:t
endfunction

function! s:date_endian() abort
  return v:lang =~# '\v(JP|KR|HU|LT|IR|MN)|^(ja|zh)' ? 'big'
     \ : v:lang =~# 'US' ? 'middle'
     \ : 'little'
endfunction

function! s:date_separator() abort
  return v:lang =~# '\v(AM|AT|AZ|BY|BG|HR|CZ|EE|FI|GE|DE|HU|IS|KZ|KG|LV|MN|NO|RO|RU|SK|CH|TM|UA)' ? '.'
     \ : v:lang =~# '\v(BD|CN|DK|FR|IN|IE|LT|NL|SE|TW)' ? '-'
     \ : '/'
endfunction

function! s:date_month_name() abort
  return 0
endfunction

function! s:date_full_month_name() abort
  return 0
endfunction

function! s:task() abort
  return 0
endfunction

function! s:event_start_time() abort
  return 1
endfunction

function! s:event_start_time_minwidth() abort
  return 16
endfunction

function! s:week_number() abort
  return 0
endfunction

function! s:clock_12hour() abort
  return 0
endfunction

let s:c = expand('~/.cache/calendar.vim/')
function! s:cache_directory() abort
  return s:c
endfunction

function! s:google_calendar() abort
  return 0
endfunction

function! s:google_task() abort
  return 0
endfunction

function! s:updatetime() abort
  return 200
endfunction

function! s:view() abort
  return 'month'
endfunction

function! s:views() abort
  return ['year', 'month', 'week', 'day_4', 'day', 'clock']
endfunction

function! s:cyclic_view() abort
  return 0
endfunction

function! s:yank_deleting() abort
  return 1
endfunction

function! s:skip_event_delete_confirm() abort
  return 0
endfunction

function! s:skip_task_delete_confirm() abort
  return 0
endfunction

function! s:skip_task_clear_completed_confirm() abort
  return 0
endfunction

function! s:task_delete() abort
  return 0
endfunction

function! s:task_width() abort
  return calendar#util#winwidth() / 6
endfunction

function! s:view_source() abort
  return [
        \ { 'type': 'ymd'
        \ , 'top': '1'
        \ , 'align': 'center'
        \ , 'maxwidth': 'b:calendar.view.task_visible() ? calendar#util#winwidth() - calendar#task#width() : calendar#util#winwidth() - 1'
        \ , 'visible': 'b:calendar.view.get_calendar_views() !~# "clock\\|event\\|agenda"'
        \ } ,
        \ { 'type': 'event'
        \ , 'left': '(calendar#util#winwidth() - self.width()) / 2'
        \ , 'top': '(calendar#util#winheight() - self.height()) / 2'
        \ , 'on_top': '1'
        \ , 'position': 'absolute'
        \ , 'maxwidth': 'max([calendar#util#winwidth() / 3, 15])'
        \ , 'maxheight': 'max([calendar#util#winheight() / 2, 3])'
        \ , 'visible': 'b:calendar.view.event_visible() && b:calendar.view.get_calendar_views() !~# "clock\\|event\\|agenda"'
        \ },
        \ { 'type': 'task'
        \ , 'align': 'right'
        \ , 'left': 'calendar#util#winwidth() - calendar#task#width()'
        \ , 'top': '(calendar#util#winheight() - self.height()) / 2'
        \ , 'position': 'absolute'
        \ , 'maxwidth': 'calendar#task#width()'
        \ , 'maxheight': 'max([calendar#util#winheight() * 5 / 6, 3])'
        \ , 'visible': 'b:calendar.view.task_visible()'
        \ },
        \ { 'type': 'help'
        \ , 'align': 'center'
        \ , 'position': 'absolute'
        \ , 'on_top': '1'
        \ , 'left': '(calendar#util#winwidth() - self.width()) / 2'
        \ , 'top': '(calendar#util#winheight() - self.height()) / 2'
        \ , 'maxwidth': 'max([min([calendar#util#winwidth() / 2, min([77, calendar#util#winwidth()])]), min([30, calendar#util#winwidth()])])'
        \ , 'maxheight': 'max([calendar#util#winheight() * 3 / 5, 3])'
        \ , 'visible': 'b:calendar.view.help_visible()'
        \ },
        \ { 'type': 'calendar'
        \ , 'top': 'b:calendar.view.get_calendar_views() =~# "clock\\|event\\|agenda" ? 0 : 3'
        \ , 'align': 'center'
        \ , 'maxwidth': 'b:calendar.view.task_visible() ? calendar#util#winwidth() - calendar#task#width() - 3  : calendar#util#winwidth() - 1'
        \ , 'maxheight': 'calendar#util#winheight() - (b:calendar.view.get_calendar_views() =~# "clock\\|event\\|agenda" ? 0 : 3)'
        \ },
        \ ]
endfunction

function! calendar#setting#frame() abort
  let n = calendar#setting#get('frame')
  if has_key(s:f, n) | return s:f[n] | endif
  let s:f[n] = calendar#setting#get('frame_' . n)
  return s:f[n]
endfunction
let s:f = {}

function! s:frame() abort
  return &enc ==# 'utf-8' && &fenc ==# 'utf-8' ? 'unicode' : 'default'
endfunction

function! s:frame_default() abort
  return { 'type': 'default', 'vertical': '|', 'horizontal': '-', 'junction': '+',
         \ 'left': '+', 'right': '+', 'top': '+', 'bottom': '+',
         \ 'topleft': '+', 'topright': '+', 'bottomleft': '+', 'bottomright': '+' }
endfunction

function! s:frame_unicode() abort
  if &enc ==# 'utf-8' && &fenc ==# 'utf-8'
    return { 'type': 'unicode', 'vertical': "\u2502", 'horizontal': "\u2500", 'junction': "\u253C",
           \ 'left': "\u251C", 'right': "\u2524", 'top': "\u252C", 'bottom': "\u2534",
           \ 'topleft': "\u250C", 'topright': "\u2510", 'bottomleft': "\u2514", 'bottomright': "\u2518" }
  else
    return s:frame_default()
  endif
endfunction

function! s:frame_unicode_bold() abort
  if &enc ==# 'utf-8' && &fenc ==# 'utf-8'
    return { 'type': 'unicode_bold', 'vertical': "\u2503", 'horizontal': "\u2501", 'junction': "\u254B",
           \ 'left': "\u2523", 'right': "\u252B", 'top': "\u2533", 'bottom': "\u253B",
           \ 'topleft': "\u250F", 'topright': "\u2513", 'bottomleft': "\u2517", 'bottomright': "\u251B" }
  else
    return s:frame_default()
  endif
endfunction

function! s:frame_unicode_round() abort
  if &enc ==# 'utf-8' && &fenc ==# 'utf-8'
    return extend(s:frame_unicode_bold(), {
          \ 'type': 'unicode_round', 'topleft': "\u256D", 'topright': "\u256E",
          \ 'bottomleft': "\u2570", 'bottomright': "\u256F" })
  else
    return s:frame_default()
  endif
endfunction

function! s:frame_unicode_double() abort
  if &enc ==# 'utf-8' && &fenc ==# 'utf-8'
    return { 'type': 'unicode_double', 'vertical': "\u2551", 'horizontal': "\u2550", 'junction': "\u256C",
           \ 'left': "\u2560", 'right': "\u2563", 'top': "\u2566", 'bottom': "\u2569",
           \ 'topleft': "\u2554", 'topright': "\u2557", 'bottomleft': "\u255A", 'bottomright': "\u255D" }
  else
    return s:frame_default()
  endif
endfunction

function! s:frame_space() abort
  return { 'type': 'space', 'vertical': ' ', 'horizontal': ' ', 'junction': ' ',
         \ 'left': ' ', 'right': ' ', 'top': ' ', 'bottom': ' ',
         \ 'topleft': ' ', 'topright': ' ', 'bottomleft': ' ', 'bottomright': ' ' }
endfunction

function! s:google_client() abort
  if has_key(s:, '_google_client')
    return s:_google_client
  endif
  let s:_google_client = {
        \ 'redirect_uri': 'urn:ietf:wg:oauth:2.0:oob',
        \ 'scope': 'https://www.googleapis.com/auth/calendar https://www.googleapis.com/auth/tasks',
        \ 'api_key': '',
        \ 'client_id': '',
        \ 'client_secret': '',
        \ }
  if exists('g:calendar_google_api_key')
    let s:_google_client.api_key = g:calendar_google_api_key
  endif
  if exists('g:calendar_google_client_id')
    let s:_google_client.client_id = g:calendar_google_client_id
  endif
  if exists('g:calendar_google_client_secret')
    let s:_google_client.client_secret = g:calendar_google_client_secret
  endif
  return s:_google_client
endfunction

function! s:message_prefix() abort
  return '[calendar] '
endfunction

function! s:debug() abort
  return 0
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
