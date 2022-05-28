" =============================================================================
" Filename: syntax/calendar.vim
" Author: itchyny
" License: MIT License
" Last Change: 2019/07/30 22:38:01.
" =============================================================================

if version < 700
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

let s:is_gui = has('gui_running') || (has('termguicolors') && &termguicolors)
let s:fg_color = calendar#color#normal_fg_color()
let s:bg_color = calendar#color#normal_bg_color()
let s:comment_fg_color = calendar#color#comment_fg_color()
let s:select_color = calendar#color#gen_color(s:fg_color, s:bg_color, 1, 4)
let s:space_fg_color = calendar#color#gen_color(s:fg_color, s:bg_color, 0, 1)
let s:space_bg_color = calendar#color#gen_color(s:fg_color, s:bg_color, 1, 0)
let s:is_win32cui = has('win32') && !s:is_gui
let s:is_dark = calendar#color#is_dark()

if !s:is_gui
  if s:is_win32cui
    if s:is_dark
      let s:select_color = 8
      let s:today_color = 10
      let s:today_fg_color = 0
      let s:othermonth_fg_color = 8
    else
      let s:select_color = 7
      let s:today_color = 2
      let s:today_fg_color = 15
      let s:othermonth_fg_color = 7
    endif
    let s:weekday_color = 8
    let s:weekday_fg_color = 0
    let s:sunday_bg_color = 12
    let s:saturday_bg_color = 9
    let s:sunday_fg_color = 0
    let s:saturday_fg_color = 0
    let s:sunday_title_fg_color = s:sunday_fg_color
    let s:saturday_title_fg_color = s:saturday_fg_color
  elseif s:is_dark
    let s:sunday_bg_color = calendar#color#select_rgb(s:fg_color, 0, 5)
    let s:saturday_bg_color = calendar#color#select_rgb(s:fg_color, 2, 5)
    let s:sunday_fg_color = calendar#color#gen_color(s:sunday_bg_color, s:bg_color, 1, 7)
    let s:saturday_fg_color = calendar#color#gen_color(s:saturday_bg_color, s:bg_color, 1, 7)
    let s:today_color = calendar#color#select_rgb(s:fg_color, 1, 5)
    let s:today_fg_color = calendar#color#gen_color(s:today_color, s:bg_color, 1, 5)
  else
    let s:sunday_fg_color = calendar#color#select_rgb(s:bg_color, 0, 6)
    let s:saturday_fg_color = calendar#color#select_rgb(s:bg_color, 2, 6)
    let s:sunday_bg_color = calendar#color#gen_color(s:sunday_fg_color, s:bg_color, 1, 4)
    let s:saturday_bg_color = calendar#color#gen_color(s:saturday_fg_color, s:bg_color, 1, 4)
    let s:today_fg_color = calendar#color#gen_color(calendar#color#select_rgb(s:fg_color, 1, 6), s:fg_color, 4, 3)
    let s:today_color = calendar#color#gen_color(s:today_fg_color, s:bg_color, 1, 3)
  endif
else
  let s:sunday_fg_color = calendar#color#select_rgb(s:is_dark ? s:fg_color : s:bg_color, 1)
  let s:saturday_fg_color = calendar#color#select_rgb(s:is_dark ? s:fg_color : s:bg_color, 4)
  let s:sunday_bg_color = calendar#color#gen_color(s:sunday_fg_color, s:is_dark ? s:fg_color : s:bg_color, 1, 3)
  let s:saturday_bg_color = calendar#color#gen_color(s:saturday_fg_color, s:is_dark ? s:fg_color : s:bg_color, 1, 3)
  let s:today_fg_color = calendar#color#gen_color(calendar#color#select_rgb(s:is_dark ? s:fg_color : s:bg_color, 2), s:is_dark ? s:bg_color : s:fg_color, 4, 3)
  let s:today_color = calendar#color#gen_color(s:today_fg_color, s:is_dark ? s:fg_color : s:bg_color, 1, 3)
endif
if !s:is_win32cui
  let s:weekday_color = calendar#color#gen_color(s:fg_color, s:bg_color, 1, 5)
  let s:weekday_fg_color = calendar#color#gen_color(s:fg_color, s:bg_color, 3, 2)
  let s:othermonth_fg_color = calendar#color#gen_color(s:fg_color, s:bg_color, 3, 4)
  let s:sunday_title_fg_color = calendar#color#gen_color(s:sunday_fg_color, s:sunday_bg_color, 3, 1)
  let s:saturday_title_fg_color = calendar#color#gen_color(s:saturday_fg_color, s:saturday_bg_color, 3, 1)
endif

call calendar#color#syntax('Select', '', s:select_color, '')
call calendar#color#syntax('Sunday', s:sunday_fg_color, s:sunday_bg_color, '')
call calendar#color#syntax('Saturday', s:saturday_fg_color, s:saturday_bg_color, '')
call calendar#color#syntax('TodaySunday', s:sunday_fg_color, s:sunday_bg_color, 'bold')
call calendar#color#syntax('TodaySaturday', s:saturday_fg_color, s:saturday_bg_color, 'bold')
call calendar#color#syntax('Today', s:today_fg_color, s:today_color, 'bold')
call calendar#color#syntax('DayTitle', s:weekday_fg_color, s:weekday_color, '')
call calendar#color#syntax('SundayTitle', s:sunday_title_fg_color, s:sunday_bg_color, '')
call calendar#color#syntax('SaturdayTitle', s:saturday_title_fg_color, s:saturday_bg_color, '')
call calendar#color#syntax('OtherMonth', s:othermonth_fg_color, '', '')
call calendar#color#syntax('OtherMonthSelect', s:othermonth_fg_color, s:select_color, '')
call calendar#color#syntax('NormalSpace', s:space_fg_color, s:space_bg_color, '')
call calendar#color#syntax('CommentSelect', s:comment_fg_color, s:select_color, '')

highlight link CalendarComment Comment

unlet! s:fg_color s:bg_color s:comment_fg_color s:select_color s:space_fg_color s:space_bg_color s:is_win32cui s:is_dark
      \ s:today_color s:today_fg_color s:othermonth_fg_color s:weekday_color s:weekday_fg_color
      \ s:sunday_bg_color s:sunday_fg_color s:sunday_title_fg_color
      \ s:saturday_bg_color s:saturday_fg_color s:saturday_title_fg_color

let b:current_syntax = 'calendar'

let &cpo = s:save_cpo
unlet s:save_cpo
