" vim match-up - even better matching
"
" Maintainer: Andy Massimino
" Email:      a@normed.space
"

scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! matchup#matchparen#init_module() " {{{1
  if !g:matchup_matchparen_enabled | return | endif

  call matchup#matchparen#enable()

  nnoremap <silent> <plug>(matchup-hi-surround)
        \ :<c-u>call matchup#matchparen#highlight_surrounding()<cr>
endfunction

" }}}1

function! matchup#matchparen#enable() " {{{1
  let g:matchup_matchparen_enabled = 1

  if g:matchup_matchparen_deferred
        \ && (!has('timers') || !exists('*timer_pause')
        \     || has('nvim') && !has('nvim-0.2.1'))
    let g:matchup_matchparen_deferred = 0
    echohl WarningMsg
    echom "match-up's deferred highlighting feature is "
          \ . 'not supported in your vim version'
    echohl None
  endif

  augroup matchup_matchparen
    autocmd!
    autocmd CursorMoved,CursorMovedI *
          \ call s:matchparen.highlight_deferred()
    autocmd WinEnter * call s:matchparen.highlight(1)
    autocmd TextChanged,TextChangedI *
          \ call s:matchparen.highlight_deferred()
    if has('patch-8.0.1494')
      autocmd TextChangedP * call s:matchparen.highlight_deferred()
    endif
    autocmd BufReadPost * call s:matchparen.transmute_reset()
    autocmd WinLeave,BufLeave * call s:matchparen.clear()
    autocmd InsertEnter,InsertChange * call s:matchparen.highlight(1, 1)
    autocmd InsertLeave * call s:matchparen.highlight(1)
  augroup END

  if has('vim_starting')
    " prevent this from autoloading during timer callback at startup
    if g:matchup_matchparen_deferred
      call matchup#pos#val(0,0)
    endif

    " prevent loading the delim module at vim startup
    let w:last_changedtick = 2
    let w:last_cursor = [0,1,1,0,1]
  endif
endfunction

" }}}1

function! s:pi_paren_sid() " {{{1
  if s:pi_paren_sid >= 0
    return s:pi_paren_sid
  endif

  let s:pi_paren_sid = 0
  if get(g:, 'loaded_matchparen')
    let l:pat = '\%#=1\V'.expand('$VIM').'\m.\+matchparen\.vim$'
    if v:version >= 800
      " execute() was added in 7.4.2008
      " :filter was introduced in 7.4.2244 but I have not tested it there
      let l:lines = split(execute("filter '".l:pat."' scriptnames"), '\n')
    else
      let l:lines = matchup#util#command('scriptnames')
      call filter(l:lines, 'v:val =~# l:pat')
    endif
    let s:pi_paren_sid = matchstr(get(l:lines, 0), '\d\+\ze: ')
    if !exists('*<SNR>'.s:pi_paren_sid.'_Highlight_Matching_Pair')
      let s:pi_paren_sid = 0
    endif
  endif
  if s:pi_paren_sid
    let s:pi_paren_fcn = function('<SNR>'.s:pi_paren_sid
      \ .'_Highlight_Matching_Pair')
  endif
  return s:pi_paren_sid
endfunction

let s:pi_paren_sid = -1

" }}}1

function! matchup#matchparen#disable() " {{{1
  let g:matchup_matchparen_enabled = 0
  call s:matchparen.clear()
  silent! autocmd! matchup_matchparen
endfunction

" }}}1
function! matchup#matchparen#toggle(...) " {{{1
  let g:matchup_matchparen_enabled = a:0 > 0
        \ ? a:1
        \ : !g:matchup_matchparen_enabled
  call matchup#matchparen#reload()
endfunction

" }}}1
function! matchup#matchparen#reload() " {{{1
  if g:matchup_matchparen_enabled
    call matchup#matchparen#enable()
    call s:matchparen.highlight(1)
  else
    call matchup#matchparen#disable()
  endif
endfunction

" }}}1
function! matchup#matchparen#update() " {{{1
  call s:matchparen.highlight(1)
endfunction

" }}}1

let s:matchparen = {}

function! s:matchparen.clear() abort dict " {{{1
  if exists('w:matchup_match_id_list')
    for l:id in w:matchup_match_id_list
      silent! call matchdelete(l:id)
    endfor
    unlet! w:matchup_match_id_list
  endif

  if exists('t:match_popup') && (exists('*win_gettype')
        \ ? win_gettype() !=# 'popup' : &buftype !=# 'terminal')
    call popup_hide(t:match_popup)
  elseif has('nvim')
    call s:close_floating_win()
  endif

  if exists('w:matchup_oldstatus')
    let &l:statusline = w:matchup_oldstatus
    unlet w:matchup_oldstatus
    if exists('#User#MatchupOffscreenLeave')
      doautocmd <nomodeline> User MatchupOffscreenLeave
    endif
  endif
  if exists('w:matchup_statusline')
    unlet w:matchup_statusline
  endif

  let w:matchup_need_clear = 0
endfunction

" }}}1

function! s:timer_callback(win_id, timer_id) abort " {{{1
  if a:win_id != win_getid()
    call timer_pause(a:timer_id, 1)
    return
  endif

  " if we timed out, do a highlight and pause the timer
  let l:elapsed = 1000*s:reltimefloat(reltime(w:matchup_pulse_time))
  if l:elapsed >= s:show_delay
    call timer_pause(a:timer_id, 1)
    if exists('#TextYankPost') && !has('patch-8.1.0192')
      " workaround crash with autocmd trigger during regex match (#3175)
      let l:save_ei = &eventignore
      try
        set eventignore+=TextYankPost
        call s:matchparen.highlight()
      finally
        let &eventignore = l:save_ei
      endtry
    else
      call s:matchparen.highlight()
    endif
  elseif w:matchup_need_clear && exists('w:matchup_hi_time')
    " if highlighting becomes too stale, clear it
    let l:elapsed = 1000*s:reltimefloat(reltime(w:matchup_hi_time))
    if l:elapsed >= s:hide_delay
      call s:matchparen.clear()
    endif
  endif
endfunction

" }}}1

function! s:matchparen.fade(level, pos, token) abort dict " {{{1
  ""
  " fade feature: remove highlights after a certain time
  " {level}
  "   =  0: prepare for possible loss of cursor support
  "   =  1: new highlights are coming (cancel prior fade)
  "   =  2: end of new highlights
  " {pos}     [lnum, column] of current match
  " {token}   in/out saves state between calls
  "
  " returns 1 if highlighting should be canceled

  if !g:matchup_matchparen_deferred || !exists('w:matchup_fade_timer')
    if a:level <= 0
      call s:matchparen.clear()
    endif
    return 0
  endif

  " jumping between windows
  if a:level == 0 && win_getid() != get(s:, 'save_win')
    call timer_pause(w:matchup_fade_timer, 1)
    if exists('w:matchup_fade_pos')
      unlet w:matchup_fade_pos
    endif
    call s:matchparen.clear()
    let s:save_win = win_getid()
  endif

  " highlighting might be stale
  if a:level == 0
    if exists('w:matchup_fade_pos')
      let a:token.save_pos = w:matchup_fade_pos
      unlet w:matchup_fade_pos
    endif
    if !w:matchup_need_clear
      call timer_pause(w:matchup_fade_timer, 1)
    endif
    return 0
  endif

  " prepare for new highlighting
  if a:level == 1
    " if token has no save_pos, cursor was previously off of a match
    if !has_key(a:token, 'save_pos') || a:pos != a:token.save_pos
      " clear immediately
      call timer_pause(w:matchup_fade_timer, 1)
      call s:matchparen.clear()
      return 0
    endif
    let w:matchup_fade_pos = a:token.save_pos
    return 1
  endif

  " new highlighting is active
  if a:level == 2 && a:pos != get(w:, 'matchup_fade_pos', [])
    " init fade request
    let w:matchup_fade_pos = a:pos
    let w:matchup_fade_start = reltime()
    call timer_pause(w:matchup_fade_timer, 0)
  endif

  return 0
endfunction

" }}}1

function! s:fade_timer_callback(win_id, timer_id) abort " {{{1
  if a:win_id != win_getid()
    call timer_pause(a:timer_id, 1)
    return
  endif

  if !exists('w:matchup_fade_start') || !w:matchup_need_clear
    call timer_pause(a:timer_id, 1)
    return
  endif

  let l:elapsed = 1000*s:reltimefloat(reltime(w:matchup_fade_start))
  if l:elapsed >= s:fade_time
    call s:matchparen.clear()
    call timer_pause(a:timer_id, 1)
  endif
endfunction

" }}}1

" function! s:reltimefloat(time) {{{1
if exists('*reltimefloat')
  function! s:reltimefloat(time)
    return reltimefloat(a:time)
  endfunction
else
  function! s:reltimefloat(time)
    return str2float(reltimestr(a:time))
  endfunction
endif

" }}}1

function! s:matchparen.highlight_deferred() abort dict " {{{1
  if !get(b:, 'matchup_matchparen_deferred',
        \ g:matchup_matchparen_deferred)
    return s:matchparen.highlight()
  endif

  if !exists('w:matchup_timer')
    let s:show_delay = g:matchup_matchparen_deferred_show_delay
    let s:hide_delay = g:matchup_matchparen_deferred_hide_delay
    let w:matchup_timer = timer_start(s:show_delay,
          \ function('s:timer_callback', [ win_getid() ]),
          \ {'repeat': -1})
    if !exists('w:matchup_need_clear')
      let w:matchup_need_clear = 0
    endif
    let s:fade_time = g:matchup_matchparen_deferred_fade_time
    if s:fade_time > 0
      let w:matchup_fade_timer = timer_start(s:fade_time,
            \ function('s:fade_timer_callback', [ win_getid() ]),
            \ {'repeat': -1})
      call timer_pause(w:matchup_fade_timer, 1)
    endif
  endif

  " keep the timer alive with a heartbeat
  let w:matchup_pulse_time = reltime()

  " if the timer is paused, some time has passed
  if timer_info(w:matchup_timer)[0].paused
    " unpause the timer
    call timer_pause(w:matchup_timer, 0)

    " set the hi time to the pulse time
    let w:matchup_hi_time = w:matchup_pulse_time
  endif
endfunction

" }}}1

function! s:matchparen.highlight(...) abort dict " {{{1
  if !g:matchup_matchparen_enabled | return | endif

  if has('vim_starting') | return | endif

  if !g:matchup_matchparen_pumvisible && pumvisible() | return | endif

  if !get(b:, 'matchup_matchparen_enabled', 1)
        \ && get(b:, 'matchup_matchparen_fallback', 1) && s:pi_paren_sid()
    return call(s:pi_paren_fcn, [])
  endif

  if !get(b:, 'matchup_matchparen_enabled', 1) | return | endif

  let l:force_update    = a:0 >= 1 ? a:1 : 0
  let l:changing_insert = a:0 >= 2 ? a:2 : 0
  let l:real_mode = l:changing_insert ? v:insertmode : mode()

  if !l:force_update
        \ && exists('w:last_changedtick') && exists('w:last_cursor')
        \ && matchup#pos#equal(w:last_cursor, matchup#pos#get_cursor())
        \ && w:last_changedtick == b:changedtick
    return
  endif
  let w:last_changedtick = b:changedtick
  let w:last_cursor = matchup#pos#get_cursor()

  call matchup#perf#tic('matchparen.highlight')

  " request eventual clearing of stale matches
  let l:token = {}
  call self.fade(0, [], l:token)

  let l:modes = g:matchup_matchparen_nomode
  if get(g:, 'matchup_matchparen_novisual', 0)  " deprecated option name
    let l:modes .= "vV\<c-v>"
  endif
  if stridx(l:modes, l:real_mode) >= 0
    return
  endif

  " prevent problems in visual block mode at the end of a line
  if get(matchup#pos#get_cursor(), 4, 0) == 2147483647
    return
  endif

  " don't get matches when inside a closed fold
  if foldclosed(line('.')) > -1
    return
  endif

  " give up when cursor is far into a very long line
  if &synmaxcol && col('.') > &synmaxcol
    return
  endif

  " in insert mode, cursor is treated as being one behind
  let l:insertmode = l:real_mode ==# 'i'

  " start the timeout period
  let l:timeout = l:insertmode
        \ ? get(b:, 'matchup_matchparen_insert_timeout',
        \           g:matchup_matchparen_insert_timeout)
        \ : get(b:, 'matchup_matchparen_timeout',
        \           g:matchup_matchparen_timeout)
  call matchup#perf#timeout_start(l:timeout)

  let l:current = matchup#delim#get_current('all', 'both_all',
        \ { 'insertmode': l:insertmode,
        \   'stopline': g:matchup_matchparen_stopline,
        \   'highlighting': 1, })
  call matchup#perf#toc('matchparen.highlight', 'get_current')
  if empty(l:current)
    if get(b:, 'matchup_matchparen_deferred',
          \ g:matchup_matchparen_deferred)
          \ && get(b:, 'matchup_matchparen_hi_surround_always',
          \        g:matchup_matchparen_hi_surround_always)
       call s:highlight_surrounding(l:insertmode)
    endif
    return
  endif

  let l:corrlist = matchup#delim#get_matching(l:current,
        \ { 'stopline': g:matchup_matchparen_stopline,
        \   'highlighting': 1, })
  call matchup#perf#toc('matchparen.highlight', 'get_matching')
  if empty(l:corrlist) | return | endif

  if g:matchup_transmute_enabled
    if !exists('w:matchup_matchparen_context')
      let w:matchup_matchparen_context = {
            \ 'normal': {
            \   'current':   {},
            \   'corrlist':  [],
            \  },
            \ 'prior': {},
            \ 'counter': 0,
            \}
    endif

    let w:matchup_matchparen_context.counter += 1

    if !l:insertmode
      let w:matchup_matchparen_context.prior
            \ = copy(w:matchup_matchparen_context.normal)

      let w:matchup_matchparen_context.normal.current = l:current
      let w:matchup_matchparen_context.normal.corrlist = l:corrlist
    endif

    " if transmuted, highlight again (will reset timeout)
    if matchup#transmute#tick(l:insertmode)
      " no force_update here because it would screw up prior
      return s:matchparen.highlight(0, l:changing_insert)
    endif
  endif

  if !has_key(l:current, 'match_index')
        \ || len(l:corrlist) <= (l:current.side ==# 'mid' ? 2 : 1)
        \ && !g:matchup_matchparen_singleton
    " TODO this doesn't catch every case, needs refactor
    " TODO singleton doesn't work right for mids
    return
  endif

  " prepare for (possibly) new highlights
  let l:pos = [l:current.lnum, l:current.cnum]
  if self.fade(1, l:pos, l:token)
    return
  endif

  " store flag meaning highlighting is active
  let w:matchup_need_clear = 1

  " disable off-screen when scrolling with j/k
  let l:scrolling = get(g:matchup_matchparen_offscreen, 'scrolloff', 0)
        \ && winheight(0) > 2*&scrolloff
        \ && (line('.') == line('w$')-&scrolloff
        \     && line('$') != line('w$')
        \     || line('.') == line('w0')+&scrolloff)

  " show off-screen matches
  let l:method = get(g:matchup_matchparen_offscreen, 'method', '')
  if !empty(l:method) && l:method !=# 'none'
        \ && !l:current.skip && !l:scrolling
        \ && winheight(0) > 0
    call s:do_offscreen(l:current, l:method)
  endif

  " add highlighting matches
  call s:add_matches(l:corrlist, l:current)

  " highlight the background between parentheses
  if g:matchup_matchparen_hi_background >= 1
    call s:highlight_background(l:corrlist)
  endif

  " new highlights done, request fade away
  call self.fade(2, l:pos, l:token)

  call matchup#perf#toc('matchparen.highlight', 'end')
endfunction

function s:matchparen.transmute_reset() abort dict
  if g:matchup_transmute_enabled
    call matchup#transmute#reset()
  endif
endfunction

" }}}1

function! s:do_offscreen(current, method) " {{{1
  let l:offscreen = {}

  if !has_key(a:current, 'links') | return | endif

  " prefer to show close
  if a:current.links.open.lnum < line('w0')
    let l:offscreen = a:current.links.open
  endif
  if a:current.links.close.lnum > line('w$')
    let l:offscreen = a:current.links.close
  endif

  if empty(l:offscreen) | return | endif

  if a:method ==# 'status'
    call s:do_offscreen_statusline(l:offscreen, 0)
  elseif a:method ==# 'status_manual'
    call s:do_offscreen_statusline(l:offscreen, 1)
  elseif a:method ==# 'popup' && winheight(0) > 1
    if has('nvim')
      call s:do_offscreen_popup_nvim(l:offscreen)
    elseif exists('*popup_create')
      call s:ensure_match_popup()
      call s:do_offscreen_popup(l:offscreen)
    endif
  endif
endfunction

" }}}1
function! s:do_offscreen_statusline(offscreen, manual) " {{{1
  let l:opts = {}
  if a:manual
    let l:opts.compact = 1
  endif
  let [l:sl, l:lnum] = matchup#matchparen#status_str(a:offscreen, l:opts)
  if s:ensure_scroll_timer() && !a:manual
    let l:sl .= '%{matchup#matchparen#scroll_update('.l:lnum.')}'
  endif

  let w:matchup_statusline = l:sl
  if !exists('w:matchup_oldstatus')
    let w:matchup_oldstatus = &l:statusline
  endif
  if !a:manual
    let &l:statusline =  w:matchup_statusline
  endif

  if exists('#User#MatchupOffscreenEnter')
    doautocmd <nomodeline> User MatchupOffscreenEnter
  endif
endfunction

" }}}1
function! s:ensure_match_popup() abort " {{{1
  if !exists('*popup_create') || exists('t:match_popup')
    return
  endif

  " create a popup and store its winid
  let l:opts = {'hidden': v:true}
  if has_key(g:matchup_matchparen_offscreen, 'highlight')
    let l:opts.highlight = g:matchup_matchparen_offscreen.highlight
  endif
  let t:match_popup = popup_create('', l:opts)

  if !has('patch-8.1.1406')
    " in case 'hidden' in popup_create-usage is unimplemented
    call popup_hide(t:match_popup)
  endif
endfunction

" }}}1
function! s:do_offscreen_popup(offscreen) " {{{1
  " screen position of top-left corner of current window
  let [l:row, l:col] = win_screenpos(winnr())
  let l:height = winheight(0) " height of current window
  let l:adjust = matchup#quirks#status_adjust(a:offscreen)
  let l:lnum = a:offscreen.lnum + l:adjust
  let l:line = l:lnum < line('.') ? l:row : l:row + l:height - 1

  " if popup would overlap with cursor
  if l:line == winline() | return | endif

  call popup_move(t:match_popup, {
        \ 'line': l:line,
        \ 'col': l:col,
        \ 'maxheight': 1,
        \})

  " set popup text
  let l:text = ''
  if &number || &relativenumber
    let l:text = printf('%*S ', wincol()-virtcol('.')-1, l:lnum)
  endif

  " replace tab indent with spaces
  " (popup window doesn't follow tabstop option of current buffer)
  let l:linestr = getline(l:lnum)
  let l:indent = repeat(' ', strdisplaywidth(matchstr(l:linestr, '^\s\+')))
  let l:linestr = substitute(l:linestr, '^\s\+', l:indent, '')

  let l:text .= l:linestr . ' '
  if l:adjust
    let l:text .= '… ' . a:offscreen.match . ' '
  endif
  call setbufline(winbufnr(t:match_popup), 1, l:text)
  call popup_show(t:match_popup)
endfunction

" }}}1
function! s:do_offscreen_popup_nvim(offscreen) " {{{1
  if exists('*nvim_open_win')
    " neovim floating window
    call s:close_floating_win()

    let l:lnum = a:offscreen.lnum
    let [l:row, l:anchor] = l:lnum < line('.')
          \ ? [0, 'NW'] : [winheight(0), 'SW']
    if l:row == winline() | return | endif

    " Set default width and height for now.
    let s:float_id = nvim_open_win(bufnr('%'), v:false, {
          \ 'relative': 'win',
          \ 'anchor': l:anchor,
          \ 'row': l:row,
          \ 'col': 0,
          \ 'width': 42,
          \ 'height': &previewheight,
          \ 'focusable': v:false,
          \})

    if has_key(g:matchup_matchparen_offscreen, 'highlight')
      call nvim_win_set_option(s:float_id, 'winhighlight',
            \ 'Normal:' . g:matchup_matchparen_offscreen.highlight)
    endif

    if &relativenumber
      call nvim_win_set_option(s:float_id, 'number', v:true)
      call nvim_win_set_option(s:float_id, 'relativenumber', v:false)
    endif

    call s:populate_floating_win(a:offscreen)
  endif
endfunction

" }}}1
function! s:populate_floating_win(offscreen) " {{{1
  let l:adjust = matchup#quirks#status_adjust(a:offscreen)
  let l:lnum = a:offscreen.lnum + l:adjust
  let l:body = getline(l:lnum, a:offscreen.lnum)
  let l:body_length = len(l:body)
  let l:height = min([l:body_length, &previewheight])

  if exists('*nvim_open_win')
    " neovim floating win
    let width = max(map(copy(l:body), 'strdisplaywidth(v:val)'))
    let l:width += wincol()-virtcol('.')
    call nvim_win_set_width(s:float_id, l:width + 1)
    if &winminheight != 1
      let l:save_wmh = &winminheight
      let &winminheight = 1
      call nvim_win_set_height(s:float_id, l:height)
      let &winminheight = l:save_wmh
    else
      call nvim_win_set_height(s:float_id, l:height)
    endif
    call nvim_win_set_cursor(s:float_id, [l:lnum, 0])
    call nvim_win_set_option(s:float_id, 'wrap', v:false)
  endif
endfunction

" }}}1
function! s:close_floating_win() " {{{1
  if !exists('s:float_id')
    return
  endif
  if win_id2win(s:float_id) > 0
    call nvim_win_close(s:float_id, 0)
  endif
  let s:float_id = 0
endfunction

" }}}1

function! MatchupStatusOffscreen() " {{{1
  return substitute(get(w:, 'matchup_statusline', ''),
        \ '%<\|%#\w*#', '', 'g')
endfunction

" }}}1

function! matchup#matchparen#highlight_surrounding() abort " {{{1
  call matchup#perf#timeout_start(500)
  call s:highlight_surrounding()
endfunction

" }}}1

function! s:highlight_surrounding(...) " {{{1
  let l:opts = { 'local': 0, 'matches': [] }
  let l:delims = matchup#delim#get_surrounding('delim_all', 1, l:opts)
  let l:open = l:delims[0]
  if empty(l:open) | return | endif

  let l:corrlist = l:opts.matches
  if empty(l:corrlist) | return | endif

  " store flag meaning highlighting is active
  let w:matchup_need_clear = 1

  " add highlighting matches
  call s:add_matches(l:corrlist)

  " highlight the background between parentheses
  if g:matchup_matchparen_hi_background >= 2
    call s:highlight_background(l:corrlist)
  endif
endfunction

" }}}1
function! s:highlight_background(corrlist) " {{{1
  let [l:lo1, l:lo2] = [a:corrlist[0], a:corrlist[-1]]

  let l:inclusive = 1
  if l:inclusive
    call s:add_background_matches_1(
          \ l:lo1.lnum,
          \ l:lo1.cnum,
          \ l:lo2.lnum,
          \ l:lo2.cnum + matchup#delim#end_offset(l:lo2))
  else
    call s:add_background_matches_1(
          \ l:lo1.lnum,
          \ l:lo1.cnum + matchup#delim#end_offset(l:lo1) + 1,
          \ l:lo2.lnum,
          \ l:lo2.cnum - 1)
  endif
endfunction

"}}}1

function! s:format_gutter(lnum, ...) " {{{1
  let l:opts = a:0 ? a:1 : {}
  let l:padding = wincol()-virtcol('.')
  let l:sl = ''

  let l:direction = a:lnum < line('.')
  if &number || &relativenumber
    let l:nw = max([strlen(line('$')), &numberwidth-1])
    let l:linenr = a:lnum     " distinct for relativenumber

    if &relativenumber
      let l:linenr = abs(l:linenr-line('.'))
    endif

    let l:sl = printf('%'.(l:nw).'s', l:linenr)
    if l:direction && !get(l:opts, 'noshowdir', 0)
      let l:sl = '%#Search#' . l:sl . '∆%#Normal#'
    else
      let l:sl = '%#CursorLineNr#' . l:sl . ' %#Normal#'
    endif
    let l:padding -= l:nw + 1
  endif

  if empty(l:sl) && l:direction && !get(l:opts, 'noshowdir', 0)
    let l:sl = '%#Search#∆%#Normal#'
    let l:padding -= 1    " OK if this is negative
    if l:padding == -1 && indent(a:lnum) == 0
      let l:padding = 0
    endif
  endif

  " possible fold column, up to &foldcolumn characters
  let l:fdcstr = ''
  if &foldcolumn
    let l:fdc = max([1, &foldcolumn-1])
    let l:fdl = foldlevel(a:lnum)
    let l:fdcstr = l:fdl <= l:fdc ? repeat('|', l:fdl)
          \ : join(range(l:fdl-l:fdc+1, l:fdl), '')
    let l:padding -= len(l:fdcstr)
    let l:fdcstr = '%#FoldColumn#' . l:fdcstr . '%#Normal#'
  elseif empty(l:sl)
    let l:sl = '%#Normal#'
  endif

  " add remaining padding (this handles rest of fdc and scl)
  let l:sl = l:fdcstr . repeat(' ', l:padding) . l:sl
  return l:sl
endfunction

" }}}1
function! matchup#matchparen#status_str(offscreen, ...) abort " {{{1
  let l:opts = a:0 ? a:1 : {}
  let l:adjust = matchup#quirks#status_adjust(a:offscreen)
  let l:lnum = a:offscreen.lnum + l:adjust
  let l:line = getline(l:lnum)

  let l:sl = ''
  let l:trimming = 0
  if get(l:opts, 'compact', 0)
    let l:trimming = 1
  else
    let l:sl = s:format_gutter(l:lnum, l:opts)
  endif

  if has_key(l:opts, 'width')
    " TODO subtract the gutter from above
    let l:room = l:opts.width
  else
    let l:room = min([300, winwidth(0)]) - (wincol()-virtcol('.'))
  endif
  let l:room -= l:adjust ? 3+strdisplaywidth(a:offscreen.match) : 0
  let l:lasthi = ''
  for l:c in range(min([l:room, strlen(l:line)]))
    if !l:adjust && a:offscreen.cnum <= l:c+1 && l:c+1 <= a:offscreen.cnum
          \ - 1 + strlen(a:offscreen.match)
      let l:wordish = a:offscreen.match !~? '^[[:punct:]]\{1,3\}$'
      " TODO: we can't overlap groups, this might not be totally correct
      let l:curhi = l:wordish ? 'MatchWord' : 'MatchParen'
    elseif char2nr(l:line[l:c]) < 32
      let l:curhi = 'SpecialKey'
    else
      let l:curhi = synIDattr(synID(l:lnum, l:c+1, 1), 'name')
      if empty(l:curhi)
        let l:curhi = 'Normal'
      endif
    endif
    let l:sl .= (l:curhi !=# l:lasthi ? '%#'.l:curhi.'#' : '')
    if l:trimming && l:line[l:c] !~ '\s'
      let l:trimming = 0
    endif
    if l:trimming
    elseif l:line[l:c] ==# "\t"
      let l:sl .= repeat(' ', strdisplaywidth(strpart(l:line, 0, 1+l:c))
            \ - strdisplaywidth(strpart(l:line, 0, l:c)))
    elseif char2nr(l:line[l:c]) < 32
      let l:sl .= strtrans(l:line[l:c])
    elseif l:line[l:c] == '%'
      let l:sl .= '%%'
    else
      let l:sl .= l:line[l:c]
    endif
    let l:lasthi = l:curhi
  endfor
  let l:sl = substitute(l:sl, '\s\+$', '', '') . '%<%#Normal#'
  if l:adjust
    let l:sl .= '%#LineNr# … %#Normal#'
          \ . '%#MatchParen#' . a:offscreen.match . '%#Normal#'
  endif

  return [l:sl, l:lnum]
endfunction

" }}}1

function! s:ensure_scroll_timer() " {{{1
  if has('timers') && exists('*timer_pause')
    if !exists('s:scroll_timer')
      let s:scroll_timer = timer_start(50,
            \ 'matchup#matchparen#scroll_callback',
            \ { 'repeat': -1 })
      call timer_pause(s:scroll_timer, 1)
    endif
  endif

  return exists('s:scroll_timer')
endfunction

" }}}1
function! matchup#matchparen#scroll_callback(tid) " {{{1
  call timer_pause(a:tid, 1)
  call s:matchparen.highlight(1)
endfunction

" }}}1
function! matchup#matchparen#scroll_update(lnum) " {{{1
  if line('w0') <= a:lnum && a:lnum <= line('w$')
        \ && exists('s:scroll_timer')
    call timer_pause(s:scroll_timer, 0)
  endif
  return ''
endfunction

" }}}1

function! s:add_matches(corrlist, ...) " {{{1
  if !exists('w:matchup_match_id_list')
    let w:matchup_match_id_list = []
  endif

  " if MatchwordCur is undefined and MatchWord links to MatchParen
  " (as default), behave like MatchWordCur is the same as MatchParenCur
  " otherwise, MatchWordCur is the same as MatchWord
  if a:0
    let l:mwc = hlexists('MatchWordCur') ? 'MatchWordCur'
          \ : (synIDtrans(hlID('MatchWord')) == hlID('MatchParen')
          \     ? 'MatchParenCur' : 'MatchWord')
  endif

  for l:corr in a:corrlist
    let l:wordish = l:corr.match !~? '^[[:punct:]]\{1,3\}$'

    if a:0 && l:corr.match_index == a:1.match_index
      let l:group = l:wordish ? l:mwc : 'MatchParenCur'
    else
      let l:group = l:wordish ? 'MatchWord' : 'MatchParen'
    endif

    if exists('*matchaddpos')
      call add(w:matchup_match_id_list, matchaddpos(l:group,
            \ [[l:corr.lnum, l:corr.cnum, strlen(l:corr.match)]], 0))
    else
      call add(w:matchup_match_id_list, matchadd(l:group,
            \ '\%'.(l:corr.lnum).'l\%'.(l:corr.cnum).'c'
            \ . '.\+\%<'.(l:corr.cnum+strlen(l:corr.match)+1).'c', 0))
    endif
  endfor
endfunction

" }}}1
function! s:add_background_matches_1(line1, col1, line2, col2) " {{{1
  if a:line1 == a:line2 && a:col1 > a:col2
    return
  endif

  let l:priority = -1

  if a:line1 == a:line2
    let l:match = '\%'.(a:line1).'l\&'
          \ . '\%'.(a:col1).'c.*\%'.(a:col2).'c.'
  else
    let l:match = '\%>'.(a:line1).'l\(.\+\|^$\)\%<'.(a:line2).'l'
          \ . '\|\%'.(a:line1).'l\%>'.(a:col1-1).'c.\+'
          \ . '\|\%'.(a:line2).'l.\+\%<'.(a:col2+1).'c.'
  endif

  call add(w:matchup_match_id_list,
        \  matchadd('MatchBackground', l:match, l:priority))
endfunction

" }}}1
function! s:add_background_matches_2(line1, col1, line2, col2) " {{{1
  if a:line1 == a:line2 && a:col1 > a:col2
    return
  endif

  let l:priority = -1

  let l:curline = a:line1
  while l:curline <= a:line2
    let l:endline = min([l:curline+7, a:line2])
    let l:list = range(l:curline, l:endline)
    if l:curline == a:line1
      let l:list[0] = [a:line1, a:col1,
            \ l:curline == a:line2 ? (a:col2-a:col1+1)
            \ : strlen(getline(a:line1))]
    endif
    if l:endline == a:line2 && l:curline != a:line2
      let l:list[-1] = [a:line2, 1, a:col2]
    endif

    call add(w:matchup_match_id_list,
          \ matchaddpos('MatchBackground', l:list, l:priority))
    let l:curline = l:endline+1
  endwhile
endfunction

" }}}1

let &cpo = s:save_cpo

" vim: fdm=marker sw=2

