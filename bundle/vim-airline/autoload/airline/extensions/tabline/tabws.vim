" MIT License. Copyright (c) 2016-2019 Kevin Sapper et al.
" PLugin: https://github.com/s1341/vim-tabws
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:current_bufnr = -1
let s:current_modified = 0
let s:current_tabnr = -1
let s:current_tabline = ''
let s:highlight_groups = ['hid', 0, '', 'sel', 'mod_unsel', 0, 'mod_unsel', 'mod']

function! airline#extensions#tabline#tabws#off()
  augroup airline_tabline_tabws
    autocmd!
  augroup END
endfunction

function! airline#extensions#tabline#tabws#on()
  augroup airline_tabline_tabws
    autocmd!
    autocmd BufDelete * call airline#extensions#tabline#tabws#invalidate()
  augroup END
endfunction

function! airline#extensions#tabline#tabws#invalidate()
  let s:current_bufnr = -1
  let s:current_tabnr = -1
endfunction

function! airline#extensions#tabline#tabws#add_buffer_section(builder, cur_tab, cur_buf, pull_right)
  let pos_extension = (a:pull_right ? '_right' : '')
  let bufnr_list = tabws#getbuffersfortab(a:cur_tab)

  if index(bufnr_list, a:cur_buf) == -1 && a:cur_tab == s:current_tabnr
    return 0
  endif

  let s:current_modified = getbufvar(a:cur_buf, '&modified')
  let visible_list = tabpagebuflist(a:cur_tab)

  for buffer in bufnr_list
    let group = 'airline_tab'
          \ .s:highlight_groups[(4 * getbufvar(buffer, '&modified')) + (2 * (index(visible_list, buffer) != -1)) + (a:cur_buf == buffer)]
          \ .pos_extension

    let buf_name = '%(%{airline#extensions#tabline#get_buffer_name('.buffer.')}%)'

    if has("tablineat")
      let buf_name = '%'.buffer.'@airline#extensions#tabline#buffers#clickbuf@'.buf_name.'%X'
    endif

    call a:builder.add_section_spaced(group, buf_name)
  endfor

  " add by tenfy(tenfyzhong@qq.com)
  " if the selected buffer was updated
  " return true
  return 1
endfunction

function! airline#extensions#tabline#tabws#add_tab_section(builder, pull_right)
  let pos_extension = (a:pull_right ? '_right' : '')

  for tab in range(1, tabpagenr('$'))
    let current = tab == tabpagenr()
    let group = 'airline_tab'
          \ .s:highlight_groups[(3 * current)]
          \ .pos_extension

    if get(g:, 'airline#extensions#tabline#tabws_show_tab_nr', 0) == 0
      call a:builder.add_section_spaced(group, '%'.tab.'T'.tabws#gettabname(tab).'%T')
    else
      call a:builder.add_section_spaced(group, '%'.tab.'T'.tab.(g:airline_symbols.space).tabws#gettabname(tab).'%T')
    endif
  endfor
endfunction

function! airline#extensions#tabline#tabws#get()
  let cur_buf = bufnr('%')
  let buffer_label = get(g:, 'airline#extensions#tabline#buffers_label', 'buffers')
  let tab_label = get(g:, 'airline#extensions#tabline#tabs_label', 'tabs')
  let switch_buffers_and_tabs = get(g:, 'airline#extensions#tabline#switch_buffers_and_tabs', 0)

  try
    call airline#extensions#tabline#tabs#map_keys()
  endtry

  let cur_tab = tabpagenr()

  if cur_buf == s:current_bufnr && cur_tab == s:current_tabnr
    if !g:airline_detect_modified || getbufvar(cur_buf, '&modified') == s:current_modified
      return s:current_tabline
    endif
  endif

  let builder = airline#extensions#tabline#new_builder()

  let show_buffers = get(g:, 'airline#extensions#tabline#show_buffers', 1)
  let show_tabs = get(g:, 'airline#extensions#tabline#show_tabs', 1)

  let AppendBuffers = function('airline#extensions#tabline#tabws#add_buffer_section', [builder, cur_tab, cur_buf])
  let AppendTabs = function('airline#extensions#tabline#tabws#add_tab_section', [builder])
  let AppendLabel = function(builder.add_section_spaced, ['airline_tabtype'], builder)

  " <= 1: |{Tabs}                      <tab|
  " == 2: |{Buffers}               <buffers|
  " == 3: |buffers> {Buffers}  {Tabs} <tabs|
  let showing_mode = (2 * show_buffers) + (show_tabs)
  let ignore_update = 0

  " Add left tabline content
  if showing_mode <= 1 " Tabs only mode
    call AppendTabs(0)
  elseif showing_mode == 2 " Buffers only mode
    let ignore_update = !AppendBuffers(0)
  else
    if !switch_buffers_and_tabs
      call AppendLabel(buffer_label)
      let ignore_update = !AppendBuffers(0)
    else
      call AppendLabel(tab_label)
      call AppendTabs(0)
    endif
  endif

  if ignore_update | return s:current_tabline | endif

  call builder.add_section('airline_tabfill', '')
  call builder.split()
  call builder.add_section('airline_tabfill', '')

  " Add right tabline content
  if showing_mode <= 1 " Tabs only mode
    call AppendLabel(tab_label)
  elseif showing_mode == 2 " Buffers only mode
    call AppendLabel(buffer_label)
  else
    if !switch_buffers_and_tabs
      call AppendTabs(1)
      call AppendLabel(tab_label)
    else
      let ignore_update = AppendBuffers(1)
      call AppendLabel(buffer_label)
    endif
  endif

  if ignore_update | return s:current_tabline | endif

  let s:current_bufnr = cur_buf
  let s:current_tabnr = cur_tab
  let s:current_tabline = builder.build()
  return s:current_tabline
endfunction
