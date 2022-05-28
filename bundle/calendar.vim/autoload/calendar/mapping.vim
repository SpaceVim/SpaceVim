" =============================================================================
" Filename: autoload/calendar/mapping.vim
" Author: itchyny
" License: MIT License
" Last Change: 2019/08/07 21:21:45.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Setting mappings in the calendar buffer.

function! calendar#mapping#new() abort

  let save_cpo = &cpo
  set cpo&vim

  if has_key(get(b:, 'calendar', {}), 'view')
    let v = b:calendar.view
    if maparg('<ESC>', 'n') !=# '<Plug>(calendar_escape)'
      if v.help_visible() || v.event_visible() || v.task_visible() || b:calendar.visual_mode()
        if v:version > 703
          nmap <buffer><nowait> <ESC> <Plug>(calendar_escape)
        else
          nmap <buffer>         <ESC> <Plug>(calendar_escape)
        endif
      endif
    else
      if !(v.help_visible() || v.event_visible() || v.task_visible() || b:calendar.visual_mode())
        nunmap <buffer> <ESC>
      endif
    endif
  endif
  if &l:filetype ==# 'calendar'
    let &cpo = save_cpo
    return
  endif

  " normal mode mapping
  let actions = ['left', 'right', 'down', 'up', 'prev', 'next', 'move_down', 'move_up', 'move_event',
        \ 'down_big', 'up_big', 'down_large', 'up_large',
        \ 'line_head', 'line_middle', 'line_last', 'bar',
        \ 'first_line', 'last_line', 'first_line_head', 'last_line_last', 'space',
        \ 'scroll_down', 'scroll_up', 'scroll_top_head', 'scroll_top',
        \ 'scroll_center_head', 'scroll_center', 'scroll_bottom_head', 'scroll_bottom',
        \ 'add', 'subtract', 'status', 'plus', 'minus', 'task', 'event', 'close_task', 'close_event',
        \ 'delete', 'delete_line', 'yank', 'yank_line', 'change', 'change_line',
        \ 'undo', 'undo_line', 'tab', 'shift_tab', 'next_match', 'prev_match',
        \ 'today', 'enter', 'view_left',  'view_right', 'redraw', 'clear', 'help', 'hide', 'exit',
        \ 'visual', 'visual_line', 'visual_block', 'exit_visual',
        \ 'start_insert', 'start_insert_append', 'start_insert_head', 'start_insert_last',
        \ 'start_insert_prev_line', 'start_insert_next_line', 'start_insert_quick',
        \ ]
  for action in actions
    exec printf("nnoremap <buffer><silent> <Plug>(calendar_%s) :<C-u>call b:calendar.action('%s')<CR>", action, action)
  endfor

  " escape
  nmap <buffer><silent><expr> <Plug>(calendar_escape)
        \ b:calendar.view.help_visible() ? "\<Plug>(calendar_help)" :
        \ b:calendar.view.event_visible() ? "\<Plug>(calendar_event)" :
        \ b:calendar.visual_mode() ? "\<Plug>(calendar_exit_visual)" :
        \ b:calendar.view.task_visible() ? "\<Plug>(calendar_task)" :
        \ ""

  " mark
  let marks = map(range(97, 97 + 25), 'nr2char(v:val)')
  for mark in marks
    exec printf("nmap <buffer><silent> m%s :<C-u>call b:calendar.mark.set('%s')<CR>", mark, mark)
    exec printf("nmap <buffer><silent> `%s :<C-u>call b:calendar.mark.get('%s')<CR>", mark, mark)
    exec printf("nmap <buffer><silent> '%s :<C-u>call b:calendar.mark.get('%s')<CR>", mark, mark)
    exec printf("nmap <buffer><silent> g`%s :<C-u>call b:calendar.mark.get('%s')<CR>", mark, mark)
    exec printf("nmap <buffer><silent> g'%s :<C-u>call b:calendar.mark.get('%s')<CR>", mark, mark)
  endfor
  for mark in ['`', "'"]
    exec printf("nmap <buffer><silent> %s%s :<C-u>call b:calendar.mark.get('%s')<CR>", mark, mark, mark ==# "'" ? mark . mark : mark)
  endfor

  " command line mapping
  cnoremap <buffer><silent><expr> <Plug>(calendar_command_enter) b:calendar.action('command_enter')

  " move neighborhood
  nmap <buffer> h <Plug>(calendar_left)
  nmap <buffer> l <Plug>(calendar_right)
  nmap <buffer> j <Plug>(calendar_down)
  nmap <buffer> k <Plug>(calendar_up)
  nmap <buffer> <Left> <Plug>(calendar_left)
  nmap <buffer> <Right> <Plug>(calendar_right)
  nmap <buffer> <Down> <Plug>(calendar_down)
  nmap <buffer> <Up> <Plug>(calendar_up)
  nmap <buffer> <BS> h
  nmap <buffer> <C-h> h
  nmap <buffer> gh h
  nmap <buffer> gl l
  nmap <buffer> gj j
  nmap <buffer> gk k
  nmap <buffer> g<Left> <Left>
  nmap <buffer> g<Right> <Right>
  nmap <buffer> g<Down> <Down>
  nmap <buffer> g<Up> <Up>
  nmap <buffer> <S-Down> <Down>
  nmap <buffer> <S-Up> <Up>
  nmap <buffer> <C-n> <Plug>(calendar_down)
  nmap <buffer> <C-p> <Plug>(calendar_up)
  nmap <buffer> <C-j> <Plug>(calendar_move_down)
  nmap <buffer> <C-k> <Plug>(calendar_move_up)
  nmap <buffer> <C-S-Down> <Plug>(calendar_move_down)
  nmap <buffer> <C-S-Up> <Plug>(calendar_move_up)
  nmap <buffer> M <Plug>(calendar_move_event)
  nmap <buffer> w <Plug>(calendar_next)
  nmap <buffer> W w
  nmap <buffer> e w
  nmap <buffer> <S-Right> w
  nmap <buffer> <C-Right> w
  nmap <buffer> b <Plug>(calendar_prev)
  nmap <buffer> B b
  nmap <buffer> ge b
  nmap <buffer> gE b
  nmap <buffer> <S-Left> b
  nmap <buffer> <C-Left> b

  " move page
  nmap <buffer> <C-d> <Plug>(calendar_down_big)
  nmap <buffer> <C-u> <Plug>(calendar_up_big)
  nmap <buffer> <C-f> <Plug>(calendar_down_large)
  nmap <buffer> <C-b> <Plug>(calendar_up_large)
  nmap <buffer> <PageDown> <C-f>
  nmap <buffer> <PageUp> <C-b>

  " move column
  nmap <buffer> 0 <Plug>(calendar_line_head)
  nmap <buffer> ^ 0
  nmap <buffer> g0 0
  nmap <buffer> <Home> 0
  nmap <buffer> g<Home> 0
  nmap <buffer> g^ ^
  nmap <buffer> gm <Plug>(calendar_line_middle)
  nmap <buffer> $ <Plug>(calendar_line_last)
  nmap <buffer> g$ $
  nmap <buffer> g_ $
  nmap <buffer> <End> $
  nmap <buffer> g<End> $
  nmap <buffer> gg <Plug>(calendar_first_line)
  nmap <buffer> <C-Home> gg
  nmap <buffer> ( <Plug>(calendar_first_line)
  nmap <buffer> { (
  nmap <buffer> [[ (
  nmap <buffer> [] [[
  nmap <buffer> G <Plug>(calendar_last_line)
  nmap <buffer> ) <Plug>(calendar_last_line)
  nmap <buffer> } )
  nmap <buffer> ]] )
  nmap <buffer> ][ ]]
  nmap <buffer> <C-End> <Plug>(calendar_last_line_last)
  nmap <buffer> <Bar> <Plug>(calendar_bar)

  " scroll
  nmap <buffer> <C-e> <Plug>(calendar_scroll_down)
  nmap <buffer> <C-y> <Plug>(calendar_scroll_up)
  nmap <buffer> z<CR> <Plug>(calendar_scroll_top_head)
  nmap <buffer> zt <Plug>(calendar_scroll_top)
  nmap <buffer> z. <Plug>(calendar_scroll_center_head)
  nmap <buffer> zz <Plug>(calendar_scroll_center)
  nmap <buffer> z- <Plug>(calendar_scroll_bottom_head)
  nmap <buffer> zb <Plug>(calendar_scroll_bottom)

  " delete
  nmap <buffer> d <Plug>(calendar_delete)
  nmap <buffer> D <Plug>(calendar_delete_line)

  " yank
  nmap <buffer> y <Plug>(calendar_yank)
  nmap <buffer> Y <Plug>(calendar_yank_line)

  " change
  nmap <buffer> c <Plug>(calendar_change)
  nmap <buffer> C <Plug>(calendar_change_line)

  " utility
  nmap <buffer> <Undo> <Plug>(calendar_undo)
  nmap <buffer> u <Plug>(calendar_undo)
  nmap <buffer> U <Plug>(calendar_undo_line)
  nmap <buffer> <TAB> <Plug>(calendar_tab)
  nmap <buffer> <S-Tab> <Plug>(calendar_shift_tab)
  nmap <buffer> n <Plug>(calendar_next_match)
  nmap <buffer> N <Plug>(calendar_prev_match)
  nmap <buffer> t <Plug>(calendar_today)
  nmap <buffer> <CR> <Plug>(calendar_enter)
  nmap <buffer> <C-a> <Plug>(calendar_add)
  nmap <buffer> <C-x> <Plug>(calendar_subtract)
  nmap <buffer> <C-g> <Plug>(calendar_status)
  nmap <buffer> + <Plug>(calendar_plus)
  nmap <buffer> - <Plug>(calendar_minus)
  nmap <buffer> T <Plug>(calendar_task)
  nmap <buffer> E <Plug>(calendar_event)
  nmap <buffer> < <Plug>(calendar_view_left)
  nmap <buffer> > <Plug>(calendar_view_right)
  nmap <buffer> <Space> <Plug>(calendar_space)
  nmap <buffer> <C-l> <Plug>(calendar_redraw)
  nmap <buffer> <C-r> <Plug>(calendar_redraw)
  nmap <buffer> L <Plug>(calendar_clear)
  nmap <buffer> ? <Plug>(calendar_help)
  nmap <buffer> q <Plug>(calendar_hide)
  nmap <buffer> Q <Plug>(calendar_exit)

  " nop
  nmap <buffer> H <Nop>
  nmap <buffer> J <Nop>
  nmap <buffer> p <Nop>
  nmap <buffer> P <Nop>
  nmap <buffer> r <Nop>
  nmap <buffer> R <Nop>
  nmap <buffer> ~ <Nop>

  " insert mode
  nmap <buffer> i <Plug>(calendar_start_insert)
  nmap <buffer> a <Plug>(calendar_start_insert_append)
  nmap <buffer> I <Plug>(calendar_start_insert_head)
  nmap <buffer> A <Plug>(calendar_start_insert_last)
  nmap <buffer> O <Plug>(calendar_start_insert_prev_line)
  nmap <buffer> o <Plug>(calendar_start_insert_next_line)

  " visual mode
  nmap <buffer> v <Plug>(calendar_visual)
  nmap <buffer> V <Plug>(calendar_visual_line)
  nmap <buffer> <C-v> <Plug>(calendar_visual_block)
  nmap <buffer> gh v
  nmap <buffer> gH V
  nmap <buffer> g<C-h> <C-v>

  " command line
  cmap <buffer> <CR> <Plug>(calendar_command_enter)

  " mouse wheel
  map <buffer> <ScrollWheelUp> <Plug>(calendar_prev)
  map <buffer> <ScrollWheelDown> <Plug>(calendar_next)

  let &cpo = save_cpo

endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
