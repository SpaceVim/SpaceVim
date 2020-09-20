" MIT License. Copyright (c) 2013-2020 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:taboo = get(g:, 'airline#extensions#taboo#enabled', 1) && get(g:, 'loaded_taboo', 0)
if s:taboo
  let g:taboo_tabline = 0
endif

let s:ctrlspace = get(g:, 'CtrlSpaceLoaded', 0)
let s:tabws = get(g:, 'tabws_loaded', 0)

function! airline#extensions#tabline#init(ext)
  if has('gui_running')
    set guioptions-=e
  endif

  autocmd User AirlineToggledOn call s:toggle_on()
  autocmd User AirlineToggledOff call s:toggle_off()

  call s:toggle_on()
  call a:ext.add_theme_func('airline#extensions#tabline#load_theme')
endfunction

function! s:toggle_off()
  call airline#extensions#tabline#autoshow#off()
  call airline#extensions#tabline#tabs#off()
  call airline#extensions#tabline#buffers#off()
  if s:ctrlspace
    call airline#extensions#tabline#ctrlspace#off()
  endif
  if s:tabws
    call airline#extensions#tabline#tabws#off()
  endif
endfunction

function! s:toggle_on()
  if get(g:, 'airline_statusline_ontop', 0)
    call airline#extensions#tabline#enable()
    let &tabline='%!airline#statusline('.winnr().')'
    return
  endif
  call airline#extensions#tabline#autoshow#on()
  call airline#extensions#tabline#tabs#on()
  call airline#extensions#tabline#buffers#on()
  if s:ctrlspace
    call airline#extensions#tabline#ctrlspace#on()
  endif
  if s:tabws
    call airline#extensions#tabline#tabws#on()
  endif

  set tabline=%!airline#extensions#tabline#get()
endfunction

function! s:update_tabline(forceit)
  if get(g:, 'airline#extensions#tabline#disable_refresh', 0)
    return
  endif
  " loading a session file
  " On SessionLoadPost, g:SessionLoad variable is still set :/
  if !a:forceit && get(g:, 'SessionLoad', 0)
    return
  endif
  let match = expand('<afile>')
  if pumvisible()
    return
  elseif !get(g:, 'airline#extensions#tabline#enabled', 0)
    return
  " return, if buffer matches ignore pattern or is directory (netrw)
  elseif empty(match) || airline#util#ignore_buf(match) || isdirectory(match)
    return
  endif
  call airline#util#doautocmd('BufMRUChange')
  call airline#extensions#tabline#redraw()
endfunction

function! airline#extensions#tabline#redraw()
  " sometimes, the tabline is not correctly updated see #1580
  " so force redraw here
  if exists(":redrawtabline") == 2
    redrawtabline
  else
  " Have to set a property equal to itself to get airline to re-eval.
  " Setting `let &tabline=&tabline` destroys the cursor position so we
  " need something less invasive.
    let &ro = &ro
  endif
endfunction

function! airline#extensions#tabline#enable()
  if &lines > 3
    set showtabline=2
  endif
endfunction

function! airline#extensions#tabline#load_theme(palette)
  if pumvisible()
    return
  endif
  let colors    = get(a:palette, 'tabline', {})
  let tablabel  = get(colors, 'airline_tablabel', a:palette.normal.airline_b)
  " Theme for tabs on the left
  let tab     = get(colors, 'airline_tab', a:palette.normal.airline_b)
  let tabsel  = get(colors, 'airline_tabsel', a:palette.normal.airline_a)
  let tabtype = get(colors, 'airline_tabtype', a:palette.visual.airline_a)
  let tabfill = get(colors, 'airline_tabfill', a:palette.normal.airline_c)
  let tabmod  = get(colors, 'airline_tabmod', a:palette.insert.airline_a)
  let tabhid  = get(colors, 'airline_tabhid', a:palette.normal.airline_c)
  if has_key(a:palette, 'normal_modified') && has_key(a:palette.normal_modified, 'airline_c')
    let tabmodu = get(colors, 'airline_tabmod_unsel', a:palette.normal_modified.airline_c)
  else
    "Fall back to normal airline_c if modified airline_c isn't present
    let tabmodu = get(colors, 'airline_tabmod_unsel', a:palette.normal.airline_c)
  endif
  call airline#highlighter#exec('airline_tablabel', tablabel)
  call airline#highlighter#exec('airline_tab', tab)
  call airline#highlighter#exec('airline_tabsel', tabsel)
  call airline#highlighter#exec('airline_tabtype', tabtype)
  call airline#highlighter#exec('airline_tabfill', tabfill)
  call airline#highlighter#exec('airline_tabmod', tabmod)
  call airline#highlighter#exec('airline_tabmod_unsel', tabmodu)
  call airline#highlighter#exec('airline_tabhid', tabhid)

  " Theme for tabs on the right
  " label on the right
  let tablabel_r  = get(colors, 'airline_tablabel', a:palette.normal.airline_b)
  let tabsel_right  = get(colors, 'airline_tabsel_right', a:palette.normal.airline_a)
  let tab_right     = get(colors, 'airline_tab_right',    a:palette.inactive.airline_c)
  let tabmod_right  = get(colors, 'airline_tabmod_right', a:palette.insert.airline_a)
  let tabhid_right  = get(colors, 'airline_tabhid_right', a:palette.normal.airline_c)
  if has_key(a:palette, 'normal_modified') && has_key(a:palette.normal_modified, 'airline_c')
    let tabmodu_right = get(colors, 'airline_tabmod_unsel_right', a:palette.normal_modified.airline_c)
  else
    "Fall back to normal airline_c if modified airline_c isn't present
    let tabmodu_right = get(colors, 'airline_tabmod_unsel_right', a:palette.normal.airline_c)
  endif
  call airline#highlighter#exec('airline_tablabel_right', tablabel_r)
  call airline#highlighter#exec('airline_tab_right',    tab_right)
  call airline#highlighter#exec('airline_tabsel_right', tabsel_right)
  call airline#highlighter#exec('airline_tabmod_right', tabmod_right)
  call airline#highlighter#exec('airline_tabhid_right', tabhid_right)
  call airline#highlighter#exec('airline_tabmod_unsel_right', tabmodu_right)
endfunction

let s:current_tabcnt = -1

function! airline#extensions#tabline#get()
  let show_buffers = get(g:, 'airline#extensions#tabline#show_buffers', 1)
  let show_tabs = get(g:, 'airline#extensions#tabline#show_tabs', 1)

  let curtabcnt = tabpagenr('$')
  if curtabcnt != s:current_tabcnt
    let s:current_tabcnt = curtabcnt
    call airline#extensions#tabline#tabs#invalidate()
    call airline#extensions#tabline#buffers#invalidate()
    call airline#extensions#tabline#ctrlspace#invalidate()
    call airline#extensions#tabline#tabws#invalidate()
  endif

  if !exists('#airline#BufAdd#*')
    autocmd airline BufAdd * call <sid>update_tabline(0)
  endif
  if !exists('#airline#SessionLoadPost')
    autocmd airline SessionLoadPost * call <sid>update_tabline(1)
  endif
  if s:ctrlspace
    return airline#extensions#tabline#ctrlspace#get()
  elseif s:tabws
    return airline#extensions#tabline#tabws#get()
  elseif show_buffers && curtabcnt == 1 || !show_tabs
    return airline#extensions#tabline#buffers#get()
  else
    return airline#extensions#tabline#tabs#get()
  endif
endfunction

function! airline#extensions#tabline#title(n)
  let title = ''
  if s:taboo
    let title = TabooTabTitle(a:n)
  endif

  if empty(title) && exists('*gettabvar')
    let title = gettabvar(a:n, 'title')
  endif

  if empty(title)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let all_buffers = airline#extensions#tabline#buflist#list()
    return airline#extensions#tabline#get_buffer_name(
          \ buflist[winnr - 1],
          \ filter(buflist, 'index(all_buffers, v:val) != -1'))
  endif

  return title
endfunction

function! airline#extensions#tabline#get_buffer_name(nr, ...)
  let buffers = a:0 ? a:1 : airline#extensions#tabline#buflist#list()
  let formatter = get(g:, 'airline#extensions#tabline#formatter', 'default')
  return airline#extensions#tabline#formatters#{formatter}#format(a:nr, buffers)
endfunction

function! airline#extensions#tabline#new_builder()
  let builder_context = {
        \ 'active'        : 1,
        \ 'tabline'       : 1,
        \ 'right_sep'     : get(g:, 'airline#extensions#tabline#right_sep'    , g:airline_right_sep),
        \ 'right_alt_sep' : get(g:, 'airline#extensions#tabline#right_alt_sep', g:airline_right_alt_sep),
        \ }
  if get(g:, 'airline_powerline_fonts', 0)
    let builder_context.left_sep     = get(g:, 'airline#extensions#tabline#left_sep'     , g:airline_left_sep)
    let builder_context.left_alt_sep = get(g:, 'airline#extensions#tabline#left_alt_sep' , g:airline_left_alt_sep)
  else
    let builder_context.left_sep     = get(g:, 'airline#extensions#tabline#left_sep'     , ' ')
    let builder_context.left_alt_sep = get(g:, 'airline#extensions#tabline#left_alt_sep' , '|')
  endif

  return airline#extensions#tabline#builder#new(builder_context)
endfunction

function! airline#extensions#tabline#group_of_bufnr(tab_bufs, bufnr)
  let cur = bufnr('%')
  if cur == a:bufnr
    if g:airline_detect_modified && getbufvar(a:bufnr, '&modified')
      let group = 'airline_tabmod'
    else
      let group = 'airline_tabsel'
    endif
  else
    if g:airline_detect_modified && getbufvar(a:bufnr, '&modified')
      let group = 'airline_tabmod_unsel'
    elseif index(a:tab_bufs, a:bufnr) > -1
      let group = 'airline_tab'
    else
      let group = 'airline_tabhid'
    endif
  endif
  return group
endfunction

function! airline#extensions#tabline#add_label(dict, type, right)
  if get(g:, 'airline#extensions#tabline#show_tab_type', 1)
    call a:dict.add_section_spaced('airline_tablabel'.
          \ (a:right ? '_right' : ''),
          \ get(g:, 'airline#extensions#tabline#'.a:type.'_label', a:type))
  endif
endfunction

function! airline#extensions#tabline#add_tab_label(dict)
  let show_tab_count = get(g:, 'airline#extensions#tabline#show_tab_count', 1)
  if show_tab_count == 2
    call a:dict.add_section_spaced('airline_tabmod', printf('%s %d/%d', "tab", tabpagenr(), tabpagenr('$')))
  elseif show_tab_count == 1 && tabpagenr('$') > 1
    call a:dict.add_section_spaced('airline_tabmod', printf('%s %d/%d', "tab", tabpagenr(), tabpagenr('$')))
  endif
endfunction
