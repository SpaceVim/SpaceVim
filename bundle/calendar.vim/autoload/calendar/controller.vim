" =============================================================================
" Filename: autoload/calendar/controller.vim
" Author: itchyny
" License: MIT License
" Last Change: 2021/09/14 13:07:41.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Calendar controller. This object is the top-level object, b:calendar.
function! calendar#controller#new() abort
  let self = deepcopy(s:self)
  let self.model = calendar#model#new()
  let self.view = calendar#view#new()
  let self.task = calendar#task#new()
  let self.event = calendar#event#new()
  let self.mark = calendar#mark#new()
  return self
endfunction

let s:self = {}

let s:self.pos = [0, 0]

let s:self.cursor_pos = [0, 0]

let s:self.mode = ''

let s:self.action_name = ''

let s:self.defaultsyntaxnames = ['Select', 'Sunday', 'Saturday',
      \ 'TodaySunday', 'TodaySaturday', 'Today',
      \ 'OtherMonth', 'OtherMonthSelect', 'DayTitle', 'SundayTitle', 'SaturdayTitle',
      \ 'NormalSpace', 'Comment', 'CommentSelect']

function! s:self.time() dict abort
  return self.model.time()
endfunction

function! s:self.set_time(time) dict abort
  return self.model.set_time(a:time)
endfunction

function! s:self.second() dict abort
  return self.model.second()
endfunction

function! s:self.minute() dict abort
  return self.model.minute()
endfunction

function! s:self.hour() dict abort
  return self.model.hour()
endfunction

function! s:self.move_second(diff) dict abort
  call self.model.move_second(a:diff)
endfunction

function! s:self.move_minute(diff) dict abort
  call self.model.move_minute(a:diff)
endfunction

function! s:self.move_hour(diff) dict abort
  call self.model.move_hour(a:diff)
endfunction

function! s:self.day() dict abort
  return self.model.day()
endfunction

function! s:self.set_day(day) dict abort
  return self.model.set_day(a:day)
endfunction

function! s:self.month() dict abort
  return self.model.month()
endfunction

function! s:self.set_month() dict abort
  return self.model.set_month(self.day().month())
endfunction

function! s:self.year() dict abort
  return self.model.year()
endfunction

function! s:self.get_days() dict abort
  return self.model.get_days()
endfunction

function! s:self.move_day(diff) dict abort
  call self.model.move_day(a:diff)
endfunction

function! s:self.move_month(diff) dict abort
  call self.model.move_month(a:diff)
endfunction

function! s:self.move_year(diff) dict abort
  call self.model.move_year(a:diff)
endfunction

function! s:self.start_visual() dict abort
  call self.model.start_visual()
endfunction

function! s:self.start_line_visual() dict abort
  call self.model.start_line_visual()
endfunction

function! s:self.start_block_visual() dict abort
  call self.model.start_block_visual()
endfunction

function! s:self.exit_visual() dict abort
  call self.model.exit_visual()
endfunction

function! s:self.visual_mode() dict abort
  return self.model.visual_mode()
endfunction

function! s:self.is_visual() dict abort
  return self.model.is_visual()
endfunction

function! s:self.is_line_visual() dict abort
  return self.model.is_line_visual()
endfunction

function! s:self.is_block_visual() dict abort
  return self.model.is_block_visual()
endfunction

function! s:self.visual_start_day() dict abort
  return self.model.visual_start_day()
endfunction

function! s:self.visual_start_time() dict abort
  return self.model.visual_start_time()
endfunction

function! s:self.go(day) dict abort
  call self.set_day(a:day)
  call self.set_month()
  call self.update()
endfunction

function! s:self.prepare() dict abort
  let [self.winheight, self.winwidth] = [calendar#util#winheight(), calendar#util#winwidth()]
  call calendar#mapping#new()
  call calendar#autocmd#new()
  call calendar#setlocal#new()
endfunction

function! s:self.update() dict abort
  call self.prepare()
  call self.redraw(0)
endfunction

function! s:self.update_force() dict abort
  call self.prepare()
  call self.redraw(1)
endfunction

function! s:self.update_force_redraw() dict abort
  call self.event.clear_cache()
  call self.task.clear_cache()
  call self.prepare()
  call self.redraw(1, 1)
endfunction

function! s:self.update_if_resized() dict abort
  if self.winheight != calendar#util#winheight() || self.winwidth != calendar#util#winwidth()
    call self.update_force_redraw()
  endif
endfunction

function! s:self.clear() dict abort
  for name in self.defaultsyntaxnames + get(b:calendar, 'syntaxnames', [])
    exec 'silent! syntax clear Calendar' . name
  endfor
endfunction

function! s:self.redraw(...) dict abort
  if histget(':', -1) ==# 'silent call b:calendar.update()'
    silent! call histdel(':', -1)
  endif
  let u = self.view.gather(a:0 ? a:1 : 0)
  if type(u) != type([])
    return
  endif
  call calendar#setlocal#modifiable()
  silent % delete _
  if a:0 > 1 && a:2
    redraw
  endif
  call self.clear()
  call setline(1, map(range(calendar#util#winheight()), 'u[v:val].s'))
  let xs = {}
  let names = []
  for t in u
    for s in t.syn
      let name = s[0]
      if name !=# '' && s[1] >= 0 && s[2] >= 0
        if name ==# 'Cursor'
          let self.pos = [s[2], s[1]]
        else
          if !has_key(xs, name)
            let xs[name] = []
            call add(names, name)
          endif
          call add(xs[name], s[4] ? [s[1], s[1] + s[4] + 1, s[2] + 1, s[3] + 1] : [s[1] + 1, s[2] + 1, s[3] + 1])
        endif
      endif
    endfor
  endfor
  for name in names
    execute 'syntax match Calendar' . name . ' /\v' . join(map(xs[name], 'len(v:val) > 3'
          \.' ? "%>" . v:val[0] . "l%<" . v:val[1] . "l%" . v:val[2] . "c.*%" . v:val[3] . "c"'
          \.' : "%" . v:val[0] . "l%" . v:val[1] . "c.*%" . v:val[2] . "c"'), '|') . '/'
  endfor
  call self.cursor()
  call calendar#setlocal#nomodifiable()
endfunction

function! s:self.cursor() dict abort
  let b:calendar.cursor_pos = [self.pos[1] + 1, self.pos[0] + 1]
  call cursor(b:calendar.cursor_pos[0], b:calendar.cursor_pos[1])
endfunction

function! s:self.cursor_moved() dict abort
  if [line('.'), col('.')] == b:calendar.cursor_pos
    return
  else
    let [l, c] = [line('.'), col('.')]
    let [pl, pc] = b:calendar.cursor_pos
    let g = getline('.')
    let [wp, wn, wg] = map([getline(pl)[:pc - 2], g[:c - 2], g], 'calendar#string#strdisplaywidth(v:val)')
    if pl == l
      call self.action(wg <= wn * 2 && wn * 2 <= wg + 3 ? 'line_middle'
            \ : g[:c - 2] =~? '^\s*$' ? 'line_head'
            \ : len(g) == c ?           'line_last'
            \ : pc < c ?                'right'
            \ :                         'left')
    elseif wp - wn < 2 && wp - wn > -2
      call self.action(pl < l ? 'down' : 'up')
    elseif l == 1 && (c > 2 && getline(1)[:c - 2] =~? '^ *$' || c <= 2)
      call self.action('first_line')
    elseif l == line('$') && c > 2 && getline(1)[:c - 2] =~? '^ *$'
      call self.action('last_line_last')
    endif
  endif
endfunction

function! s:self.action(action) dict abort
  let action = a:action
  if index([ 'delete', 'yank', 'change' ], action) >= 0
    if self.mode ==# action
      let self.mode = ''
      let action .= '_line'
    else
      let self.mode = action
      return
    endif
  else
    let self.mode = ''
  endif
  let self.action_name = action
  let ret = self.view.action(action)
  if type(ret) == type(0) && ret == 0
    call self.update()
  endif
  return ret
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
