"=============================================================================
" FILE: view.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#view#_redraw_prompt() abort "{{{
  let unite = unite#get_current_unite()
  if unite.prompt_linenr < 0
    return
  endif

  let modifiable_save = &l:modifiable
  try
    setlocal modifiable
    silent! call setline(unite.prompt_linenr,
          \ unite.context.prompt . unite.context.input)

    silent! syntax clear uniteInputLine
    silent! syntax clear uniteInputPrompt
    execute 'syntax match uniteInputLine'
          \ '/\%'.unite.prompt_linenr.'l.*/'
          \ 'contains=uniteInputCommand,uniteInputPrompt'
    execute 'syntax match uniteInputPrompt'
          \ '/\%'.unite.prompt_linenr.'l.*\%'.len(unite.context.prompt).'c/'
  finally
    let &l:modifiable = modifiable_save
  endtry
endfunction"}}}
function! unite#view#_redraw_candidates(...) abort "{{{
  let is_gather_all = get(a:000, 0, 0)

  call unite#view#_resize_window()

  let unite = unite#get_current_unite()
  let context = unite.context

  let candidates = unite#candidates#gather(is_gather_all)
  if context.prompt_direction ==# 'below'
    let unite.init_prompt_linenr = len(candidates) + 1
  endif

  let pos = getpos('.')
  let modifiable_save = &l:modifiable
  try
    setlocal modifiable

    if context.prompt_direction !=# 'below'
      call unite#view#_redraw_prompt()
    endif

    call unite#view#_set_candidates_lines(
          \ unite#view#_convert_lines(candidates))

    if context.prompt_direction ==# 'below' && unite.prompt_linenr != 0
      if empty(candidates)
        let unite.prompt_linenr = 1
      else
        call append(unite.prompt_linenr, '')
        let unite.prompt_linenr += 1
      endif
      call unite#view#_redraw_prompt()
    endif

    let unite.current_candidates = candidates
  finally
    let &l:modifiable = l:modifiable_save
    if pos != getpos('.')
      call setpos('.', pos)
    endif
  endtry

  if context.input == '' && context.log
        \ || context.prompt_direction ==# 'below'
    " Move to bottom.
    call cursor(line('$'), 0)
  endif

  if context.prompt_direction ==# 'below' && mode() ==# 'i'
    call unite#view#_bottom_cursor()
  endif

  " Set syntax.
  call s:set_syntax()
endfunction"}}}
function! unite#view#_redraw_line(...) abort "{{{
  let prompt_linenr = unite#get_current_unite().prompt_linenr
  let linenr = a:0 > 0 ? a:1 : line('.')
  if linenr ==# prompt_linenr
    let linenr += 1
  endif

  if &filetype !=# 'unite'
    " Ignore.
    return
  endif

  let modifiable_save = &l:modifiable
  setlocal modifiable

  let candidate = unite#helper#get_current_candidate(linenr)
  call setline(linenr, unite#view#_convert_lines([candidate])[0])

  let &l:modifiable = modifiable_save
endfunction"}}}
function! unite#view#_quick_match_redraw(quick_match_table, is_define) abort "{{{
  for [key, number] in items(a:quick_match_table)
    if a:is_define
      execute printf(
            \ 'silent! sign define unite_quick_match_%d text=%s texthl=uniteQuickMatchText',
            \ number, key)
      execute printf(
            \ 'silent! sign place %d name=unite_quick_match_%d line=%d buffer=%d',
            \ 2000 + number, number, number, bufnr('%'))
    else
      execute printf(
            \ 'silent! sign unplace %d buffer=%d',
            \ 2000 + number, bufnr('%'))
    endif
  endfor
endfunction"}}}
function! unite#view#_set_candidates_lines(lines) abort "{{{
  let unite = unite#get_current_unite()
  let modifiable_save = &l:modifiable
  try
    let pos = getpos('.')
    setlocal modifiable

    " Clear candidates
    if unite.context.prompt_direction ==# 'below'
      silent! execute '1,'.(unite.prompt_linenr-1).'$delete _'
      call setline(1, a:lines)
      let start = (unite.prompt_linenr == 0) ?
            \ len(a:lines)+1 : unite.prompt_linenr+1
      silent! execute start.',$delete _'
    else
      silent! execute (unite.prompt_linenr+1).',$delete _'
      call setline(unite.prompt_linenr+1, a:lines)
    endif
  finally
    call setpos('.', pos)
    let &l:modifiable = modifiable_save
  endtry
endfunction"}}}

function! unite#view#_redraw(is_force, winnr, is_gather_all) abort "{{{
  if unite#util#is_cmdwin()
    return
  endif

  let unite_save = unite#variables#current_unite()
  let winnr_save = winnr()
  if a:winnr > 0
    " Set current unite.
    let unite = getbufvar(winbufnr(a:winnr), 'unite')

    execute a:winnr 'wincmd w'
  endif

  let pos = getpos('.')
  let unite = unite#get_current_unite()
  let context = unite.context
  let current_candidate = (line('.') == unite.prompt_linenr) ?
        \ {} : unite#helper#get_current_candidate()

  try
    if &filetype !=# 'unite' || !unite.is_initialized
      return
    endif

    if !context.is_redraw
      let context.is_redraw = a:is_force
    endif

    if context.is_redraw
      call unite#clear_message()
    endif

    let input = unite#helper#get_input(1)
    if !context.is_redraw
          \ && input ==# unite.last_input
          \ && context.path ==# unite.last_path
          \ && !unite.is_async
          \ && !context.unite__is_resize
          \ && !a:is_gather_all
      return
    endif

    let is_gather_all = a:is_gather_all || context.log

    if context.is_redraw
          \ || input !=# unite.last_input
          \ || context.path !=# unite.last_path
          \ || unite.is_async
          \ || empty(unite.args)
      " Recaching.
      call unite#candidates#_recache(input, a:is_force)
    endif

    let unite.last_input = input
    let unite.last_path = context.path

    " Redraw.
    call unite#view#_redraw_candidates(is_gather_all)
    call unite#view#_change_highlight()
    let unite.context.is_redraw = 0
  finally
    if empty(unite.args) && getpos('.') !=# pos
      call setpos('.', pos)

      if context.prompt_direction ==# 'below'
        call cursor(line('$'), 0)
        call unite#view#_bottom_cursor()
      endif
    elseif !context.log
      call unite#view#_search_cursor(current_candidate)
    endif

    if a:winnr > 0
      " Restore current unite.
      call unite#set_current_unite(unite_save)
      execute winnr_save 'wincmd w'
    endif
  endtry

  if context.auto_preview
    call unite#view#_do_auto_preview()
  endif
  if context.auto_highlight
    call unite#view#_do_auto_highlight()
  endif
endfunction"}}}
function! unite#view#_redraw_all_candidates() abort "{{{
  let unite = unite#get_current_unite()
  if len(unite.candidates) != len(unite.current_candidates)
    call unite#redraw(0, 1)
  endif
endfunction"}}}

function! unite#view#_set_syntax() abort "{{{
  syntax clear

  syntax match uniteInputCommand /\\\@<! :\S\+/ contained

  let unite = unite#get_current_unite()
  let context = unite.context

  let candidate_icon = unite#util#escape_pattern(
        \ context.candidate_icon)
  execute 'syntax region uniteNonMarkedLine start=/^'.
        \ candidate_icon.'/ end=''$'' keepend'.
        \ ' contains=uniteCandidateIcon,'.
        \ 'uniteCandidateSourceName'
  execute 'syntax match uniteCandidateIcon /^'.
        \ candidate_icon.'/ contained '
        \ . (context.hide_icon ? 'conceal' : '')

  let marked_icon = unite#util#escape_pattern(
        \ context.marked_icon)
  execute 'syntax region uniteMarkedLine start=/^'.
        \ marked_icon.'/ end=''$'' keepend'
        \ ' contains=uniteMarkedIcon'
  execute 'syntax match uniteMarkedIcon /^'.
        \ marked_icon.'/ contained '
        \ . (context.hide_icon ? 'conceal' : '')

  silent! syntax clear uniteCandidateSourceName
  if unite.max_source_name > 0
    execute 'syntax match uniteCandidateSourceName
          \ /\%'.(2+strwidth(unite.context.prompt)).'c[[:alnum:]_\/-]\+/ contained'
  endif

  " Set syntax.
  let syntax = {}
  for source in filter(copy(unite.sources), 'v:val.syntax != ""')
    " Skip previous syntax
    if has_key(syntax, source.name)
      continue
    endif
    let syntax[source.name] = 1

    let name = unite.max_source_name > 0 ?
          \ unite#helper#convert_source_name(source.name) : ''

    execute 'highlight default link'
          \ source.syntax unite.context.abbr_highlight

    execute printf('syntax match %s "^['.
          \ unite.context.candidate_icon.' ]\+%s" '.
          \ 'nextgroup='.source.syntax. ' keepend
          \ contains=uniteCandidateIcon,%s',
          \ 'uniteSourceLine__'.source.syntax,
          \ (name == '' ? '' : name . '\>'),
          \ (name == '' ? '' : 'uniteCandidateSourceName')
          \ )

    call unite#helper#call_hook([source], 'on_syntax')
  endfor

  call s:set_syntax()

  call unite#view#_redraw_prompt()

  let b:current_syntax = 'unite'
endfunction"}}}
function! unite#view#_change_highlight() abort  "{{{
  if &filetype !=# 'unite'
        \ || !exists('b:current_syntax')
    return
  endif

  let unite = unite#get_current_unite()
  if empty(unite)
    return
  endif

  call unite#view#_set_cursor_line()

  let context = unite.context
  if !context.match_input
    return
  endif

  silent! syntax clear uniteCandidateInputKeyword

  syntax case ignore

  for input_str in unite#helper#get_substitute_input(
        \ unite#helper#get_input())
    if input_str == ''
      continue
    endif

    let input_list = unite#helper#get_input_list(input_str)

    for source in filter(copy(unite.sources), "v:val.syntax != ''")
      for matcher in filter(copy(map(filter(
            \ copy(source.matchers),
            \ "type(v:val) == type('')"), 'unite#get_filters(v:val)')),
            \ "has_key(v:val, 'pattern')")
        let patterns = map(copy(input_list),
              \ "escape(matcher.pattern(v:val), '/~')")

        silent! execute 'syntax match uniteCandidateInputKeyword'
              \ '/'.join(patterns, '\|').'/'
              \ 'containedin='.source.syntax.' contained'
      endfor
    endfor
  endfor

  syntax case match
endfunction"}}}

function! unite#view#_resize_window() abort "{{{
  if &filetype !=# 'unite'
    return
  endif

  let context = unite#get_context()
  let unite = unite#get_current_unite()

  if (winheight(0) + &cmdheight + 2 >= &lines
        \ && !context.vertical)
        \ || !context.resize
        \ || !context.split
    " Cannot resize.
    let context.unite__is_resize = 0
    return
  endif

  if context.unite__old_winwidth != 0
        \ && context.unite__old_winheight != 0
        \ && winwidth(0) != context.unite__old_winwidth
        \ && winheight(0) != context.unite__old_winheight
    " Disabled resize.
    let context.winwidth = 0
    let context.winheight = 0
    let context.unite__is_resize = 1
    return
  endif

  if context.auto_resize
    " Auto resize.
    let max_len = unite.candidates_len
    if unite.prompt_linenr > 0
      let max_len += 1
    endif

    let winheight = winheight(0)

    silent! execute 'resize' min([max_len, context.winheight])

    if line('.') == unite.prompt_linenr
          \ || line('$') < winheight
      call unite#view#_bottom_cursor()
    endif

    let context.unite__is_resize = winheight != winheight(0)
  elseif context.vertical
        \ && context.unite__old_winwidth == 0
    silent! execute 'vertical resize' context.winwidth

    let context.unite__is_resize = 1
  elseif !context.vertical
        \ && (context.unite__old_winheight == 0 || context.auto_preview)
    silent! execute 'resize' context.winheight

    let context.unite__is_resize = 1
  else
    let context.unite__is_resize = 0
  endif

  let context.unite__old_winheight = winheight(winnr())
  let context.unite__old_winwidth = winwidth(winnr())
endfunction"}}}

function! unite#view#_do_auto_preview() abort "{{{
  let unite = unite#get_current_unite()

  if unite.preview_candidate == unite#helper#get_current_candidate()
    return
  endif

  let unite.preview_candidate = unite#helper#get_current_candidate()

  call unite#action#do('preview', [], {})

  " Restore window size.
  if s:has_preview_window()
    call unite#view#_resize_window()
  endif
endfunction"}}}
function! unite#view#_do_auto_highlight() abort "{{{
  let unite = unite#get_current_unite()

  if unite.highlight_candidate == unite#helper#get_current_candidate()
    return
  endif
  let unite.highlight_candidate = unite#helper#get_current_candidate()

  call unite#action#do('highlight', [], {})
endfunction"}}}

function! unite#view#_switch_unite_buffer(buffer_name, context) abort "{{{
  " Search unite window.
  let winnr = unite#helper#get_unite_winnr(a:buffer_name)
  if a:context.split && winnr > 0
    silent execute winnr 'wincmd w'
    return
  endif

  " Search unite buffer.
  let bufnr = unite#helper#get_unite_bufnr(a:buffer_name)

  if a:context.split && !a:context.unite__direct_switch
    " Split window.
    silent doautocmd WinLeave
    execute s:get_buffer_direction(a:context) ((bufnr > 0) ?
          \ ((a:context.vertical) ? 'vsplit' : 'split') :
          \ ((a:context.vertical) ? 'vnew' : 'new'))
  endif

  if bufnr > 0
    silent execute bufnr 'buffer'
  else
    if bufname('%') == ''
      noautocmd silent enew
    endif
    silent! execute 'edit' fnameescape(a:context.real_buffer_name)
  endif

  call unite#handlers#_on_bufwin_enter(bufnr('%'))
  silent doautocmd WinEnter
  silent doautocmd BufWinEnter
endfunction"}}}

function! unite#view#_close(buffer_name) abort  "{{{
  let buffer_name = a:buffer_name

  if buffer_name == ''
    " Use last unite buffer.
    if !exists('t:unite') ||
          \ !bufexists(t:unite.last_unite_bufnr)
      call unite#util#print_error('No unite buffer.')
      return
    endif

    let buffer_name = getbufvar(
          \ t:unite.last_unite_bufnr, 'unite').buffer_name
  endif

  " Search unite window.
  let quit_winnr = unite#helper#get_unite_winnr(buffer_name)

  if buffer_name !~ '@\d\+$'
    " Add postfix.
    let prefix = '[unite] - '
    let prefix .= buffer_name
    let buffer_name .= unite#helper#get_postfix(
          \ prefix, 0, tabpagebuflist(tabpagenr()))
  endif

  if quit_winnr > 0
    " Quit unite buffer.
    silent execute quit_winnr 'wincmd w'
    call unite#force_quit_session()
  endif

  return quit_winnr > 0
endfunction"}}}

function! unite#view#_init_cursor() abort "{{{
  let unite = unite#get_current_unite()
  let context = unite.context

  let positions = unite#custom#get_profile(
        \ unite.profile_name, 'unite__save_pos')
  let position = get(positions, unite#loaded_source_names_string(), {})
  let is_restore = context.restore
        \ && !empty(position) && context.select <= 0
        \ && (context.resume || position.candidate ==#
        \       unite#helper#get_current_candidate(position.pos[1]))

  if context.start_insert && !context.auto_quit
    let unite.is_insert = 1

    if is_restore && position.pos[1] != unite.prompt_linenr
      call s:restore_position(position)
      startinsert
    else
      call unite#helper#cursor_prompt()
      startinsert!
    endif
  else
    let unite.is_insert = 0

    if is_restore
      call s:restore_position(position)
    else
      call unite#helper#cursor_prompt()
    endif

    call cursor(0, 1)
    stopinsert
  endif

  if context.select > 0
    " Select specified candidate.
    call cursor(unite#helper#get_current_candidate_linenr(
          \ context.select), 0)
  elseif context.input == '' && context.log
    call unite#view#_redraw_candidates(1)
  endif

  if !is_restore &&
        \ (line('.') <= winheight(0)
        \ || (context.prompt_direction ==# 'below'
        \     && (line('$') - line('.')) <= winheight(0)))
    call unite#view#_bottom_cursor()
  endif

  if !context.focus
    if winbufnr(winnr('#')) > 0
      wincmd p
    else
      execute bufwinnr(unite.prev_bufnr).'wincmd w'
    endif
  endif

  let unite.prev_line = line('.')
  call unite#view#_set_cursor_line()
  call unite#handlers#_on_cursor_moved()

  if context.quick_match
    call unite#helper#cursor_prompt()
    call unite#view#_bottom_cursor()

    call unite#mappings#_quick_match(0)
  endif
endfunction"}}}

function! unite#view#_quit(is_force, ...) abort  "{{{
  if &filetype !=# 'unite'
    return
  endif

  let is_all = get(a:000, 0, 0)

  " Save unite value.
  let unite_save = unite#variables#current_unite()
  call unite#set_current_unite(b:unite)
  let unite = b:unite
  let context = unite.context

  " Clear mark.
  for source in unite#loaded_sources_list()
    for candidate in source.unite__cached_candidates
      let candidate.unite__is_marked = 0
    endfor
  endfor

  if unite.context.unite__is_manual
    call unite#sources#history_unite#add(unite)
  endif

  call unite#view#_save_position()

  if a:is_force || context.quit
    let bufname = bufname('%')

    if winnr('$') == 1 || !context.split
      call unite#util#alternate_buffer()

      if g:unite_restore_alternate_file
            \ && bufexists(unite.alternate_bufnr)
            \ && bufnr('%') != unite.alternate_bufnr
            \ && unite.alternate_bufnr > 0
        silent! execute 'buffer!' unite.alternate_bufnr
        silent! buffer! #
      endif
    elseif is_all || !context.temporary
      close!
      if unite.winnr != winnr() && unite.winnr <= winnr('$')
        execute unite.winnr . 'wincmd w'
      endif
      call unite#view#_resize_window()
    endif

    call unite#handlers#_on_buf_unload(bufname)

    call unite#view#_close_preview_window()

    if winnr('$') != 1 && winnr('$') == unite.winmax
          \ && !context.temporary
      execute unite.win_rest_cmd
      noautocmd execute unite.prev_winnr 'wincmd w'
    endif
    if context.quit
      call setpos('.', unite.prev_pos)
    endif
  else
    call unite#view#_close_preview_window()

    let winnr = get(filter(range(1, winnr('$')),
          \ "winbufnr(v:val) == unite.prev_bufnr"), 0, unite.prev_winnr)

    if winnr == winnr()
      new
    else
      execute winnr 'wincmd w'
    endif

    let unite.prev_winnr = winnr()

    " Resize window.
    try
      execute bufwinnr(unite.bufnr) 'wincmd w'

      call unite#view#_resize_window()
    finally
      execute unite.prev_winnr 'wincmd w'
    endtry
  endif

  if context.complete
    if context.col < col('$')
      startinsert
    else
      startinsert!
    endif
  else
    redraw
    stopinsert
  endif

  " Restore unite.
  call unite#set_current_unite(unite_save)
endfunction"}}}

function! unite#view#_set_cursor_line() abort "{{{
  if !exists('b:current_syntax') || &filetype !=# 'unite'
    return
  endif

  let unite = unite#get_current_unite()
  let context = unite.context
  if !context.cursor_line
    return
  endif

  let prompt_linenr = unite.prompt_linenr

  if line('.') != prompt_linenr
    call unite#view#_match_line(context.cursor_line_highlight, line('.'))
  endif
  let unite.cursor_line_time = reltime()
endfunction"}}}

function! unite#view#_bottom_cursor() abort "{{{
  let pos = getpos('.')
  try
    normal! zb
  finally
    call setpos('.', pos)
  endtry
endfunction"}}}
function! unite#view#_clear_match() abort "{{{
  if &filetype ==# 'unite'
    setlocal nocursorline
  endif
endfunction"}}}

function! unite#view#_save_position() abort "{{{
  let unite = b:unite
  let context = unite.context

  let key = unite#loaded_source_names_string()
  if key == ''
    return
  endif

  " Save position.
  let positions = unite#custom#get_profile(
        \ unite.profile_name, 'unite__save_pos')

  let positions[key] = {
        \ 'pos' : getpos('.'),
        \ 'winline' : winline(),
        \ 'candidate' : unite#helper#get_current_candidate(),
        \ }

  if context.input == ''
    return
  endif

  " Save input.
  let inputs = unite#custom#get_profile(
        \ unite.profile_name, 'unite__inputs')
  if !has_key(inputs, key)
    let inputs[key] = []
  endif
  call insert(filter(inputs[key],
        \ 'v:val !=# unite.context.input'), context.input)
endfunction"}}}

" Message output.
function! unite#view#_print_error(message) abort "{{{
  let message = map(s:msg2list(a:message), '"[unite.vim] " . v:val')
  let unite = unite#get_current_unite()
  if !empty(unite)
    let unite.err_msgs += message
  endif
  for mes in message
    echohl WarningMsg | echomsg mes | echohl None
  endfor
endfunction"}}}
function! unite#view#_print_warning(message) abort "{{{
  let message = map(s:msg2list(a:message), '"[unite.vim] " . v:val')
  for mes in message
    echohl WarningMsg | echon mes | echohl None
  endfor
endfunction"}}}
function! unite#view#_print_source_error(message, source_name) abort "{{{
  call unite#view#_print_error(
        \ map(copy(s:msg2list(a:message)),
        \   "printf('[%s] %s', a:source_name, v:val)"))
endfunction"}}}
function! unite#view#_print_message(message, ...) abort "{{{
  let context = unite#get_context()
  let unite = unite#get_current_unite()
  let message = s:msg2list(a:message)
  let is_silent = get(a:000, 0, get(context, 'silent', 0))
  if !empty(unite)
    let unite.msgs += message
  endif

  if !is_silent
    echohl Comment | call unite#view#_redraw_echo(message[: &cmdheight-1]) | echohl None
  endif
endfunction"}}}
function! unite#view#_print_source_message(message, source_name) abort "{{{
  call unite#view#_print_message(
        \ map(copy(s:msg2list(a:message)),
        \    "printf('[%s] %s', a:source_name, v:val)"))
endfunction"}}}
function! unite#view#_add_source_message(message, source_name) abort "{{{
  call unite#view#_print_message(
        \ map(copy(s:msg2list(a:message)),
        \    "printf('[%s] %s', a:source_name, v:val)"), 1)
endfunction"}}}
function! unite#view#_clear_message() abort "{{{
  let unite = unite#get_current_unite()
  let unite.msgs = []
  redraw
endfunction"}}}
function! unite#view#_redraw_echo(expr) abort "{{{
  if has('vim_starting')
    echo join(s:msg2list(a:expr), "\n")
    return
  endif

  let more_save = &more
  let showcmd_save = &showcmd
  let ruler_save = &ruler
  try
    set nomore
    set noshowcmd
    set noruler

    let msg = map(s:msg2list(a:expr), "unite#util#truncate_smart(
          \ v:val, &columns - 1 + len(v:val) - strdisplaywidth(v:val),
          \ &columns/2, '...')")
    let height = max([1, &cmdheight])
    for i in range(0, len(msg)-1, height)
      redraw
      echo join(msg[i : i+height-1], "\n")
    endfor
  finally
    let &more = more_save
    let &showcmd = showcmd_save
    let &ruler = ruler_save
  endtry
endfunction"}}}

function! unite#view#_match_line(highlight, line) abort "{{{
  call unite#view#_clear_match()

  if &filetype ==# 'unite'
    setlocal cursorline
    return
  endif

  call unite#view#_clear_match_highlight()

  " For compatibility
  let w:unite_match_id = exists('*matchaddpos') ?
        \ matchaddpos(a:highlight, [a:line], 10) :
        \ matchadd(a:highlight, '^\%'.a:line.'l.*', 10)
endfunction"}}}
function! unite#view#_clear_match_highlight() abort "{{{
  if exists('w:unite_match_id')
    call matchdelete(w:unite_match_id)
    unlet w:unite_match_id
  endif
endfunction"}}}

function! unite#view#_get_status_plane_string() abort "{{{
  return (b:unite.is_async ? '[async] ' : '') .
        \ join(map(copy(unite#loaded_sources_list()), "
        \ (v:val.unite__len_candidates == 0) ? '_' :
        \ join(insert(filter(copy(v:val.args),
        \  'type(v:val) <= 1'),
        \   unite#helper#convert_source_name(v:val.name)), ':')
        \ . (v:val.unite__len_candidates == 0 ? '' :
        \      v:val.unite__orig_len_candidates ==
        \            v:val.unite__len_candidates ?
        \            '(' .  v:val.unite__len_candidates . ')' :
        \      printf('(%s/%s)', v:val.unite__len_candidates,
        \      v:val.unite__orig_len_candidates))
        \ "))
endfunction"}}}

function! unite#view#_get_status_head_string() abort "{{{
  if !exists('b:unite')
    return ''
  endif

  return b:unite.is_async ? '[async] ' : ''
endfunction"}}}
function! unite#view#_get_status_tail_string() abort "{{{
  if !exists('b:unite')
    return ''
  endif

  return b:unite.context.path != '' ? '['. b:unite.context.path.']' :
        \    (get(b:unite.msgs, 0, '') == '') ? '' :
        \    substitute(get(b:unite.msgs, 0, ''), '^\[.\{-}\]\s*', '', '')
endfunction"}}}

function! unite#view#_get_source_name_string(source) abort "{{{
  return (a:source.unite__orig_len_candidates == 0) ? '_' :
        \ join(insert(filter(copy(a:source.args),
        \  'type(v:val) <= 1'),
        \   unite#helper#convert_source_name(a:source.name)), ':')
endfunction"}}}
function! unite#view#_get_source_candidates_string(source) abort "{{{
  return a:source.unite__orig_len_candidates == 0 ? '' :
        \      a:source.unite__orig_len_candidates ==
        \            a:source.unite__len_candidates ?
        \            '(' . a:source.unite__len_candidates . ')' :
        \      printf('(%s/%s)', a:source.unite__len_candidates,
        \      a:source.unite__orig_len_candidates)
endfunction"}}}

function! unite#view#_get_status_string(unite) abort "{{{
  let statusline = "%#uniteStatusHead# %{unite#view#_get_status_head_string()}%*"
  let cnt = 0
  if empty(a:unite.sources)
    let statusline .= "%#uniteStatusSourceNames#interactive%*"
    let statusline .= "%#uniteStatusSourceCandidates#%{"
    let statusline .= "unite#view#_get_source_candidates_string("
    let statusline .= "unite#loaded_sources_list()[0])} %*"
  else
    for cnt in range(0, len(a:unite.sources)-1)
      let statusline .= "%#uniteStatusSourceNames#%{"
      let statusline .= "unite#view#_get_source_name_string("
      let statusline .= "b:unite.sources[".cnt."])}"
      let statusline .= "%#uniteStatusSourceCandidates#%{"
      let statusline .= "unite#view#_get_source_candidates_string("
      let statusline .= "b:unite.sources[".cnt."])} %*"
    endfor
  endif

  let statusline .= "%=%#uniteStatusMessage# %{unite#view#_get_status_tail_string()} %*"
  let statusline .= "%#uniteStatusLineNR#%{printf('%'.len(b:unite.candidates_len"
  let statusline .= "+b:unite.prompt_linenr).'d/%d',line('.'),"
  let statusline .= "b:unite.candidates_len+b:unite.prompt_linenr)}%*"
  return statusline
endfunction"}}}

function! unite#view#_add_previewed_buffer_list(bufnr) abort "{{{
  call s:clear_previewed_buffer_list()

  let unite = unite#get_current_unite()
  call add(unite.previewed_buffer_list, a:bufnr)
endfunction"}}}
function! unite#view#_remove_previewed_buffer_list(bufnr) abort "{{{
  let unite = unite#get_current_unite()
  call filter(unite.previewed_buffer_list, 'v:val != a:bufnr')
endfunction"}}}

function! unite#view#_preview_file(filename) abort "{{{
  let context = unite#get_context()
  if context.vertical_preview
    let unite_winwidth = winwidth(0)
    silent execute 'vertical pedit!' fnameescape(a:filename)
    wincmd P
    let target_winwidth = (unite_winwidth + winwidth(0)) / 2
    execute 'wincmd p | vert resize ' . target_winwidth
  else
    let previewheight_save = &previewheight
    try
      let &previewheight = context.previewheight
      silent execute 'pedit!' fnameescape(a:filename)
    finally
      let &previewheight = previewheight_save
    endtry
  endif
endfunction"}}}

function! unite#view#_close_preview_window() abort "{{{
  let unite = unite#get_current_unite()

  if !unite.has_preview_window
    let preview_windows = filter(range(1, winnr('$')),
          \ 'getwinvar(v:val, "&previewwindow") != 0')
    if !empty(preview_windows)
      " Close preview window.
      if winnr('$') == 1
        new
      endif
      noautocmd pclose!
    endif
  endif

  call s:clear_previewed_buffer_list()

  let unite.preview_candidate = {}
endfunction"}}}
function! s:clear_previewed_buffer_list() abort "{{{
  let unite = unite#get_current_unite()

  " Clear previewed buffer list
  for bufnr in unite.previewed_buffer_list
    if buflisted(bufnr)
      if bufnr == bufnr('%')
        call unite#util#alternate_buffer()
      endif
      silent! execute 'bdelete!' bufnr
    endif
  endfor

  let unite.previewed_buffer_list = []
endfunction"}}}

" @vimlint(EVL102, 1, l:max_source_name)
" @vimlint(EVL102, 1, l:context)
" @vimlint(EVL102, 1, l:padding)
function! unite#view#_convert_lines(candidates) abort "{{{
  let unite = unite#get_current_unite()
  let context = unite#get_context()
  let [max_width, max_source_name] = unite#helper#adjustments(
        \ winwidth(0), unite.max_source_name, 4)

  let padding_width = strwidth(context.prompt)
  if !unite.context.hide_icon
    let padding_width -= strwidth(context.candidate_icon)
  endif
  let padding = repeat(' ', padding_width)

  let truncate_width = (max_width*context.truncate_width) / 100

  return map(copy(a:candidates),
        \ "(v:val.is_dummy ? ' ' :
        \   v:val.unite__is_marked ? context.marked_icon :
        \   context.candidate_icon) . padding
        \ . (unite.max_source_name == 0 ? ''
        \   : unite#util#truncate(unite#helper#convert_source_name(
        \     (v:val.is_dummy ? '' : v:val.source)), max_source_name))
        \ . ((strwidth(v:val.unite__abbr) < max_width || !context.truncate) ?
        \     v:val.unite__abbr
        \   : unite#util#truncate_wrap(v:val.unite__abbr, max_width
        \    , truncate_width, '..'))")
endfunction"}}}
" @vimlint(EVL102, 0, l:max_source_name)
" @vimlint(EVL102, 0, l:context)
" @vimlint(EVL102, 0, l:padding)

function! unite#view#_search_cursor(candidate) abort "{{{
  " Optimized
  if empty(a:candidate) ||
        \ unite#helper#get_current_candidate() ==# a:candidate
    return
  endif

  call unite#view#_redraw_all_candidates()

  let max = line('$')
  let cnt = 1
  while cnt <= max
    let candidate = unite#helper#get_current_candidate(cnt)

    if candidate ==# a:candidate
      " Move cursor.
      call cursor(cnt, 0)
      return
    endif

    let cnt += 1
  endwhile
endfunction"}}}

function! s:set_syntax() abort "{{{
  let unite = unite#get_current_unite()

  " Set syntax.
  for source in filter(copy(unite.sources), 'v:val.syntax != ""')
    silent! execute 'syntax clear' source.syntax
    execute 'syntax region' source.syntax
          \ 'start=// end=/$/ keepend contained'
  endfor

  call unite#view#_change_highlight()
endfunction"}}}

function! s:has_preview_window() abort "{{{
  return len(filter(range(1, winnr('$')),
        \    'getwinvar(v:val, "&previewwindow")')) > 0
endfunction"}}}

function! s:msg2list(expr) abort "{{{
  return type(a:expr) ==# type([]) ? a:expr : split(a:expr, '\n')
endfunction"}}}

function! s:get_buffer_direction(context) abort "{{{
  let direction = a:context.direction
  if direction ==# 'dynamictop' || direction ==# 'dynamicbottom'
    " Use dynamic direction calculation
    let unite = unite#get_current_unite()
    let [max_width, _] = unite#helper#adjustments(
          \ winwidth(0), unite.max_source_name, 4)
    let is_fit = empty(filter(copy(unite#candidates#gather()),
          \ 'strwidth(v:val.unite__abbr) > max_width'))

    if direction ==# 'dynamictop'
      let direction = is_fit ? 'aboveleft' : 'topleft'
    else
      let direction = is_fit ? 'belowright' : 'botright'
    endif
  endif
  return direction
endfunction"}}}

function! s:restore_position(position) abort "{{{
  call setpos('.', a:position.pos)
  if winline() < a:position.winline
    execute 'normal!' (a:position.winline - winline())."\<C-y>"
  elseif winline() > a:position.winline
    execute 'normal!' (winline() - a:position.winline)."\<C-e>"
  endif
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
