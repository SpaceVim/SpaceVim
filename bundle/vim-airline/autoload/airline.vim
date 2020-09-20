" MIT License. Copyright (c) 2013-2020 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let g:airline_statusline_funcrefs = get(g:, 'airline_statusline_funcrefs', [])

let s:sections = ['a','b','c','gutter','x','y','z', 'error', 'warning']
let s:inactive_funcrefs = []
let s:contexts = {}
let s:core_funcrefs = [
      \ function('airline#extensions#apply'),
      \ function('airline#extensions#default#apply') ]


function! airline#add_statusline_func(name)
  call airline#add_statusline_funcref(function(a:name))
endfunction

function! airline#add_statusline_funcref(function)
  if index(g:airline_statusline_funcrefs, a:function) >= 0
    call airline#util#warning(printf('The airline statusline funcref "%s" has already been added.', string(a:function)))
    return
  endif
  call add(g:airline_statusline_funcrefs, a:function)
endfunction

function! airline#remove_statusline_func(name)
  let i = index(g:airline_statusline_funcrefs, function(a:name))
  if i > -1
    call remove(g:airline_statusline_funcrefs, i)
  endif
endfunction

function! airline#add_inactive_statusline_func(name)
  call add(s:inactive_funcrefs, function(a:name))
endfunction

function! airline#load_theme()
  let g:airline_theme = get(g:, 'airline_theme', 'dark')
  if exists('*airline#themes#{g:airline_theme}#refresh')
    call airline#themes#{g:airline_theme}#refresh()
  endif

  let palette = g:airline#themes#{g:airline_theme}#palette
  call airline#themes#patch(palette)

  if exists('g:airline_theme_patch_func')
    let Fn = function(g:airline_theme_patch_func)
    call Fn(palette)
  endif

  call airline#highlighter#load_theme()
  call airline#extensions#load_theme()
  call airline#update_statusline()
endfunction

" Load an airline theme
function! airline#switch_theme(name, ...)
  let silent = get(a:000, '0', 0)
  " get all available themes
  let themes = airline#util#themes('')
  let err = 0
  try
    if index(themes, a:name) == -1
      " Theme not available
      if !silent
        call airline#util#warning(printf('The specified theme "%s" cannot be found.', a:name))
      endif
      throw "not-found"
      let err = 1
    else
      exe "ru autoload/airline/themes/". a:name. ".vim"
      let g:airline_theme = a:name
    endif
  catch /^Vim/
    " catch only Vim errors, not "not-found"
    call airline#util#warning(printf('There is an error in theme "%s".', a:name))
    if &vbs
      call airline#util#warning(v:exception)
    endif
    let err = 1
  endtry

  if err
    if exists('g:airline_theme')
      return
    else
      let g:airline_theme = 'dark'
    endif
  endif

  unlet! w:airline_lastmode
  call airline#load_theme()

  call airline#util#doautocmd('AirlineAfterTheme')

  " this is required to prevent clobbering the startup info message, i don't know why...
  call airline#check_mode(winnr())
endfunction

" Try to load the right theme for the current colorscheme
function! airline#switch_matching_theme()
  if exists('g:colors_name')
    let existing = g:airline_theme
    let theme = tr(tolower(g:colors_name), '-', '_')
    try
      call airline#switch_theme(theme, 1)
      return 1
    catch
      for map in items(g:airline_theme_map)
        if match(g:colors_name, map[0]) > -1
          try
            call airline#switch_theme(map[1], 1)
          catch
            call airline#switch_theme(existing)
          endtry
          return 1
        endif
      endfor
    endtry
  endif
  return 0
endfunction

" Update the statusline
function! airline#update_statusline()
  if airline#util#stl_disabled(winnr())
    return
  endif
  let range = filter(range(1, winnr('$')), 'v:val != winnr()')
  " create inactive statusline
  call airline#update_statusline_inactive(range)

  unlet! w:airline_render_left w:airline_render_right
  exe 'unlet! ' 'w:airline_section_'. join(s:sections, ' w:airline_section_')

  " Now create the active statusline
  let w:airline_active = 1
  let context = { 'winnr': winnr(), 'active': 1, 'bufnr': winbufnr(winnr()) }
  call s:invoke_funcrefs(context, g:airline_statusline_funcrefs)
endfunction

" Function to be called to make all statuslines inactive
" Triggered on FocusLost autocommand
function! airline#update_statusline_focuslost()
  if get(g:, 'airline_focuslost_inactive', 0)
    let bufnr=bufnr('%')
    call airline#highlighter#highlight_modified_inactive(bufnr)
    call airline#highlighter#highlight(['inactive'], bufnr)
    call airline#update_statusline_inactive(range(1, winnr('$')))
  endif
endfunction

" Function to draw inactive statuslines for inactive windows
function! airline#update_statusline_inactive(range)
  if airline#util#stl_disabled(winnr())
    return
  endif
  for nr in a:range
    if airline#util#stl_disabled(nr)
      continue
    endif
    call setwinvar(nr, 'airline_active', 0)
    let context = { 'winnr': nr, 'active': 0, 'bufnr': winbufnr(nr) }
    if get(g:, 'airline_inactive_alt_sep', 0)
      call extend(context, {
            \ 'left_sep': g:airline_left_alt_sep,
            \ 'right_sep': g:airline_right_alt_sep }, 'keep')
    endif
    call s:invoke_funcrefs(context, s:inactive_funcrefs)
  endfor
endfunction

" Gather output from all funcrefs which will later be returned by the
" airline#statusline() function
function! s:invoke_funcrefs(context, funcrefs)
  let builder = airline#builder#new(a:context)
  let err = airline#util#exec_funcrefs(a:funcrefs + s:core_funcrefs, builder, a:context)
  if err == 1
    let a:context.line = builder.build()
    let s:contexts[a:context.winnr] = a:context
    let option = get(g:, 'airline_statusline_ontop', 0) ? '&tabline' : '&statusline'
    call setwinvar(a:context.winnr, option, '%!airline#statusline('.a:context.winnr.')')
  endif
endfunction

" Main statusline function per window
" will be set to the statusline option
function! airline#statusline(winnr)
  if has_key(s:contexts, a:winnr)
    return '%{airline#check_mode('.a:winnr.')}'.s:contexts[a:winnr].line
  endif
  " in rare circumstances this happens...see #276
  return ''
endfunction

" Check if mode has changed
function! airline#check_mode(winnr)
  if !has_key(s:contexts, a:winnr)
    return ''
  endif
  let context = s:contexts[a:winnr]

  if get(w:, 'airline_active', 1)
    let l:m = mode(1)
    if l:m ==# "i"
      let l:mode = ['insert']
    elseif l:m[0] ==# "i"
      let l:mode = ['insert']
    elseif l:m ==# "Rv"
      let l:mode =['replace']
    elseif l:m[0] ==# "R"
      let l:mode = ['replace']
    elseif l:m[0] =~# '\v(v|V||s|S|)'
      let l:mode = ['visual']
    elseif l:m ==# "t"
      let l:mode = ['terminal']
    elseif l:m[0] ==# "c"
      let l:mode = ['commandline']
    elseif l:m ==# "no"   " does not work, most likely, Vim does not refresh the statusline in OP mode
      let l:mode = ['normal']
    elseif l:m[0:1] ==# 'ni'
      let l:mode = ['normal']
      let l:m = 'ni'
    else
      let l:mode = ['normal']
    endif
    if exists("*VMInfos") && !empty(VMInfos())
      " Vim plugin Multiple Cursors https://github.com/mg979/vim-visual-multi
      let l:m = 'multi'
    endif
    if index(['Rv', 'no', 'ni', 'ix', 'ic', 'multi'], l:m) == -1
      let l:m = l:m[0]
    endif
    let w:airline_current_mode = get(g:airline_mode_map, l:m, l:m)
  else
    let l:mode = ['inactive']
    let w:airline_current_mode = get(g:airline_mode_map, '__')
  endif

  if g:airline_detect_modified && &modified
    call add(l:mode, 'modified')
  endif

  if g:airline_detect_paste && &paste
    call add(l:mode, 'paste')
  endif

  if g:airline_detect_crypt && exists("+key") && !empty(&key)
    call add(l:mode, 'crypt')
  endif

  if g:airline_detect_spell && &spell
    call add(l:mode, 'spell')
  endif

  if &readonly || ! &modifiable
    call add(l:mode, 'readonly')
  endif

  let mode_string = join(l:mode)
  if get(w:, 'airline_lastmode', '') != mode_string
    call airline#highlighter#highlight_modified_inactive(context.bufnr)
    call airline#highlighter#highlight(l:mode, context.bufnr)
    call airline#util#doautocmd('AirlineModeChanged')
    let w:airline_lastmode = mode_string
  endif

  return ''
endfunction

function! airline#update_tabline()
  if get(g:, 'airline_statusline_ontop', 0)
    call airline#extensions#tabline#redraw()
  endif
endfunction

function! airline#mode_changed()
  " airline#visual_active
  " Boolean: for when to get visual wordcount
  " needed for the wordcount extension
  let g:airline#visual_active = (mode() =~? '[vs]')
  call airline#update_tabline()
endfunction
