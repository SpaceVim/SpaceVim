" =============================================================================
" Filename: autoload/calendar/argument.vim
" Author: itchyny
" License: MIT License
" Last Change: 2020/10/17 01:28:50.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Deal with argument for the :Calendar command.

let s:calendars = filter(map(split(globpath(&rtp, 'autoload/calendar/day/**.vim'), '\n'),
      \ "substitute(v:val, '.*/\\|.vim', '', 'g')"),
      \ 'v:val !~# "^\(default\\|gregorian\\|julian\)$"')
let s:all_value_options = {
      \ '-year': [],
      \ '-month': [],
      \ '-day': [],
      \ '-locale': [ 'default', 'en', 'ja' ],
      \ '-calendar': ['default', 'gregorian', 'julian'] + sort(s:calendars),
      \ '-calendar_candidates': [],
      \ '-first_day': [ 'sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday' ],
      \ '-time_zone': map(range(-12, 12), 'printf("%+03d00", v:val)'),
      \ '-date_endian': [ 'little', 'big', 'middle' ],
      \ '-date_separator': [ '/', '-', '.', '" "' ],
      \ '-event_start_time_minwidth': [],
      \ '-cache_directory': [],
      \ '-updatetime': [],
      \ '-view': [ 'year', 'month', 'week', 'days', 'day', 'clock', 'event', 'agenda' ],
      \ '-frame': [ 'default', 'unicode', 'space', 'unicode_bold', 'unicode_round', 'unicode_double' ],
      \ '-position': [ 'here', 'below', 'tab', 'left', 'right', 'topleft', 'topright' ],
      \ '-split': [ 'horizontal', 'vertical' ],
      \ '-width': [],
      \ '-height': [],
      \ '-message_prefix': [],
      \ '-task_width': [],
      \ }
let s:all_novalue_options = [
      \ '-google_calendar',
      \ '-google_task',
      \ '-date_month_name',
      \ '-date_full_month_name',
      \ '-cyclic_view',
      \ '-task',
      \ '-event_start_time',
      \ '-skip_event_delete_confirm',
      \ '-skip_task_delete_confirm',
      \ '-skip_task_clear_completed_confirm',
      \ '-yank_deleting',
      \ '-task_delete',
      \ '-clock_12hour',
      \ '-week_number',
      \ '-debug' ]
let s:value_options = deepcopy(s:all_value_options)
let s:novalue_options = deepcopy(s:all_novalue_options)
if has_key(g:, 'calendar_hide_options') && type(g:calendar_hide_options) == type([]) && len(g:calendar_hide_options)
  for s:k in g:calendar_hide_options
    if has_key(s:value_options, s:k)
      unlet s:value_options[s:k]
    elseif has_key(s:value_options, '-' . s:k)
      unlet s:value_options['-' . s:k]
    endif
    let s:i = index(s:novalue_options, s:k)
    if s:i >= 0
      call remove(s:novalue_options, s:i)
    endif
    let s:i = index(s:novalue_options, '-' . s:k)
    if s:i >= 0
      call remove(s:novalue_options, s:i)
    endif
  endfor
  unlet s:k s:i
endif
let s:options = copy(s:novalue_options) + map(keys(deepcopy(s:value_options)), 'v:val . "="')
let s:all_options = copy(s:novalue_options)
for [s:key, s:val] in items(deepcopy(s:value_options))
  call extend(s:all_options, map(s:val, 's:key . "=" . v:val'))
endfor
unlet s:key s:val

" Completion function.
function! calendar#argument#complete(arglead, cmdline, cursorpos) abort
  try
    for key in keys(s:value_options)
      if a:cmdline =~# key
        if a:cmdline =~# key . '=$'
          return &wildmode =~# 'full'
                \ ? map(copy(s:value_options[key]), 'key . "=" . v:val')
                \ : copy(s:value_options[key])
        elseif a:cmdline =~# key . '=\S\+$'
          let lead = '^' . substitute(a:cmdline, '.*=', '', '')
          let list = filter(copy(s:value_options[key]), 'v:val =~# lead')
          if !len(list)
            let lead = substitute(a:cmdline, '.*=', '', '')
            let list = filter(copy(s:value_options[key]), 'v:val =~# lead')
          endif
          let arglead = substitute(a:arglead, '=.*', '=', '')
          return map(list, 'arglead . v:val')
        endif
      endif
    endfor
    let s:options = copy(s:novalue_options)
          \ + map(keys(deepcopy(s:value_options)), &wildmode =~# 'full' ? 'v:val' : 'v:val . "="')
    let options = copy(s:options)
    if a:arglead != ''
      let options = sort(filter(copy(s:options), 'stridx(v:val, a:arglead) != -1'))
      if len(options) == 0
        let arglead = substitute(a:arglead, '^-\+', '', '')
        let options = sort(filter(copy(s:options), 'stridx(v:val, arglead) != -1'))
        if len(options) == 0
          try
            let argl = substitute(a:arglead, '\(.\)', '.*\1', 'g') . '.*'
            let options = sort(filter(copy(s:options), 'v:val =~? argl'))
            if len(options) == 0
              let options = sort(filter(copy(s:all_options), 'stridx(v:val, arglead) != -1'))
            endif
          catch
            let options = copy(s:options)
          endtry
        endif
      endif
    endif
    return sort(filter(options, 'stridx(a:cmdline, v:val) == -1'))
  catch
    return s:options
  endtry
endfunction

" Splitting the argument.
" This function deals with quotes.
function! calendar#argument#split(args) abort
  let args = ['']
  let quoteflag = 0
  let quote = ''
  for i in range(len(a:args))
    if a:args[i] ==# ' '
      if quoteflag
        let args[-1] .= a:args[i]
      elseif args[-1] !=# ''
        call add(args, '')
      endif
    elseif (a:args[i] ==# '"' || a:args[i] ==# "'")
      if quoteflag && quote ==# a:args[i]
        call add(args, '')
        let quoteflag = 0
        let quote = ''
      elseif quoteflag
        let args[-1] .= a:args[i]
      else
        let quoteflag = 1
        let quote = a:args[i]
      endif
    else
      let args[-1] .= a:args[i]
    endif
  endfor
  return filter(args, 'len(v:val)')
endfunction

" Option parsing and constructing the buffer-creating command.
function! calendar#argument#parse(args) abort
  let args = calendar#argument#split(a:args)
  let isnewbuffer = bufname('%') != '' || &l:filetype != '' || &modified
  let name = " `='" . calendar#argument#buffername('calendar') . "'`"
  let command = 'tabnew'
  let commandprefix = ''
  let addname = 1
  let ymd = []
  let variables = {}
  let [width, height] = [-1, -1]
  let [arg_year, flg_year] = [0, 0]
  let [arg_month, flg_month] = [0, 0]
  let [arg_day, flg_day] = [0, 0]
  let flg_ymd = 0
  for arg in args
    let novalue = 0
    if arg !~# '=' && arg !~# '^\d\+$'
      if index(s:novalue_options, substitute(arg, '!$', '', '')) >= 0
        let bang = arg =~# '!$'
        let arg = substitute(arg, '!$', '', '') . '=' . (!bang)
        let novalue = 1
      else
        let pat = substitute(substitute(arg, '^-', '=', ''), '!$', '', '') . '$'
        let opts = filter(copy(s:all_options), 'v:val =~# pat')
        let bang = arg =~# '!$' ? '!' : ''
        if len(opts) == 1
          let arg = opts[0] . bang
        elseif len(opts) > 1
          call calendar#echo#error(calendar#message#get('multiple_argument') . ': ' . join(opts, ', '))
        endif
      endif
    endif
    if arg =~# '='
      let optvar = split(arg, '=')
      if len(optvar) == 2 && (has_key(s:value_options, optvar[0]) || novalue)
        let option = substitute(optvar[0], '^-\+', '', '')
        if option ==# 'position'
          if optvar[1] ==# 'here'
            let command = 'try | edit' . name . ' | catch | tabnew' . name . ' | endtry'
            let addname = 0
          elseif optvar[1] ==# 'here!'
            let command = 'edit!'
          elseif optvar[1] ==# 'below'
            if command ==# 'tabnew'
              let command = 'new'
            endif
            let commandprefix = 'below '
            let isnewbuffer = 1
          elseif index(['left', 'right', 'topleft', 'topright'], optvar[1]) >= 0
            if command ==# 'tabnew'
              let command = 'vnew'
            endif
            let commandprefix = optvar[1] ==# 'left' ? 'leftabove '
                  \           : optvar[1] ==# 'right' ? 'rightbelow '
                  \           : optvar[1] ==# 'topleft' ? 'topleft '
                  \           : optvar[1] ==# 'topright' ? 'botright '
                  \           : ''
            let isnewbuffer = 1
          elseif optvar[1] ==# 'tab'
            let command = 'tabnew'
            let isnewbuffer = 1
          endif
        elseif option ==# 'split'
          if optvar[1] ==# 'horizontal'
            let command = 'new'
            let isnewbuffer = 1
          elseif optvar[1] ==# 'vertical'
            let command = 'vnew'
            let isnewbuffer = 1
          endif
        elseif option ==# 'width'
          let width = optvar[1] + 0
        elseif option ==# 'height'
          let height = optvar[1] + 0
        elseif option ==# 'year'
          let [arg_year, flg_year, flg_ymd] = [optvar[1], 1, 1]
        elseif option ==# 'month'
          let [arg_month, flg_month, flg_ymd] = [optvar[1], 1, 1]
        elseif option ==# 'day'
          let [arg_day, flg_day, flg_ymd] = [optvar[1], 1, 1]
        endif
        let variables[option] = optvar[1]
      endif
    elseif arg =~# '^\d\+$'
      call add(ymd, arg)
    endif
  endfor
  if command ==# 'new' && height > 0
    let command = height . ' ' . command
  elseif command ==# 'vnew' && width > 0
    let command = width . ' ' . command
  endif
  let cmd1 = 'keepalt '. commandprefix . command . (addname ? name : '')
  let cmd2 = 'keepalt edit' . name
  let command = 'if isnewbuffer | ' . cmd1 . ' | else | ' . cmd2 . '| endif'
  if flg_ymd
    let ymd = [arg_year, arg_month, arg_day, flg_year, flg_month, flg_day]
  endif
  return [isnewbuffer, command, variables, ymd]
endfunction

" :Calendar [year month day]
" The order is properly dealt with based on the endian setting.
function! calendar#argument#day(day, default) abort
  let [y, m, d] = a:default
  let l = len(a:day)
  let endian = calendar#setting#get('date_endian')
  if l == 1
    let day0 = a:day[0] * 1
    if 0 < day0 && day0 < 13
      let [m, d] = [day0, 1]
    else
      let [y, m, d] = [day0, 1, 1]
    endif
  elseif l == 2
    let [day0, day1] = [a:day[0] * 1, a:day[1] * 1]
    if 0 < day0 && day0 < 13 && 0 < day1 && day1 < 32 && (endian ==# 'big' || endian ==# 'middle')
      let [m, d] = [day0, day1]
    elseif 0 < day0 && day0 < 32 && 0 < day1 && day1 < 13 && (endian ==# 'little')
      let [m, d] = [day1, day0]
    elseif 0 < day1 && day1 < 13 && endian ==# 'big'
      let [y, m, d] = [day0, day1, 1]
    elseif 0 < day0 && day0 < 13 && (endian ==# 'middle' || endian ==# 'little')
      let [y, m, d] = [day1, day0, 1]
    endif
  elseif l == 3
    if endian ==# 'big'
      let [y, m, d] = [a:day[0] * 1, a:day[1] * 1, a:day[2] * 1]
    elseif endian ==# 'middle'
      let [m, d, y] = [a:day[0] * 1, a:day[1] * 1, a:day[2] * 1]
    else
      let [d, m, y] = [a:day[0] * 1, a:day[1] * 1, a:day[2] * 1]
    endif
  elseif l == 6
    if a:day[3] | let y = a:day[0] | endif
    if a:day[4] | let m = a:day[1] | endif
    if a:day[5] | let d = a:day[2] | endif
  endif
  return calendar#day#new(y, m, d)
endfunction

" Decision of the buffer name.
function! calendar#argument#buffername(name) abort
  let buflist = []
  for i in range(tabpagenr('$'))
   call extend(buflist, tabpagebuflist(i + 1))
  endfor
  let matcher = 'bufname(v:val) =~# ("\\[" . a:name . "\\( \\d\\+\\)\\?\\]") && index(buflist, v:val) >= 0'
  let substituter = 'substitute(bufname(v:val), ".*\\(\\d\\+\\).*", "\\1", "") + 0'
  let bufs = map(filter(range(1, bufnr('$')), matcher), substituter)
  let i = 0
  while index(bufs, i) >= 0
    let i += 1
  endwhile
  return '[' . a:name . (len(bufs) && i ? ' ' . i : '') . ']'
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
