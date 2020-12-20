" MIT License. Copyright (c) 2013-2019 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:spc = g:airline_symbols.space

let s:current_bufnr = -1
let s:current_modified = 0
let s:current_tabline = ''
let s:current_visible_buffers = []

let s:number_map = {
      \ '0': '⁰',
      \ '1': '¹',
      \ '2': '²',
      \ '3': '³',
      \ '4': '⁴',
      \ '5': '⁵',
      \ '6': '⁶',
      \ '7': '⁷',
      \ '8': '⁸',
      \ '9': '⁹'
      \ }
let s:number_map = &encoding == 'utf-8'
      \ ? get(g:, 'airline#extensions#tabline#buffer_idx_format', s:number_map)
      \ : {}

function! airline#extensions#tabline#buffers#off()
  augroup airline_tabline_buffers
    autocmd!
  augroup END
endfunction

function! airline#extensions#tabline#buffers#on()
  let terminal_event = has("nvim") ? 'TermOpen' : 'TerminalOpen'
  augroup airline_tabline_buffers
    autocmd!
    autocmd BufDelete * call airline#extensions#tabline#buflist#clean()
    if exists("##".terminal_event)
      exe 'autocmd '. terminal_event. ' * call airline#extensions#tabline#buflist#clean()'
    endif
    autocmd User BufMRUChange call airline#extensions#tabline#buflist#clean()
  augroup END
endfunction

function! airline#extensions#tabline#buffers#invalidate()
  let s:current_bufnr = -1
endfunction

function! airline#extensions#tabline#buffers#get()
  try
    call <sid>map_keys()
  catch
    " no-op
  endtry
  let cur = bufnr('%')
  if cur == s:current_bufnr && &columns == s:column_width
    if !g:airline_detect_modified || getbufvar(cur, '&modified') == s:current_modified
      return s:current_tabline
    endif
  endif

  let b = airline#extensions#tabline#new_builder()
  let tab_bufs = tabpagebuflist(tabpagenr())
  let show_buf_label_first = 0

  if get(g:, 'airline#extensions#tabline#buf_label_first', 0)
    let show_buf_label_first = 1
  endif
  if show_buf_label_first
    call airline#extensions#tabline#add_label(b, 'buffers', 0)
  endif

  let b.tab_bufs = tabpagebuflist(tabpagenr())

  let b.overflow_group = 'airline_tabhid'
  let b.buffers = airline#extensions#tabline#buflist#list()
  if get(g:, 'airline#extensions#tabline#current_first', 0)
    if index(b.buffers, cur) > -1
      call remove(b.buffers, index(b.buffers, cur))
    endif
    let b.buffers = [cur] + b.buffers
  endif

  function! b.get_group(i) dict
    let bufnum = get(self.buffers, a:i, -1)
    if bufnum == -1
      return ''
    endif
    let group = airline#extensions#tabline#group_of_bufnr(self.tab_bufs, bufnum)
    if bufnum == bufnr('%')
      let s:current_modified = (group == 'airline_tabmod') ? 1 : 0
    endif
    return group
  endfunction

  if has("tablineat")
    function! b.get_pretitle(i) dict
      let bufnum = get(self.buffers, a:i, -1)
      return '%'.bufnum.'@airline#extensions#tabline#buffers#clickbuf@'
    endfunction

    function! b.get_posttitle(i) dict
      return '%X'
    endfunction
  endif

  function! b.get_title(i) dict
    let bufnum = get(self.buffers, a:i, -1)
    let group = self.get_group(a:i)
    let pgroup = self.get_group(a:i - 1)
    " always add a space when powerline_fonts are used
    " or for the very first item
    if get(g:, 'airline_powerline_fonts', 0) || a:i == 0
      let space = s:spc
    else
      let space= (pgroup == group ? s:spc : '')
    endif

    if get(g:, 'airline#extensions#tabline#buffer_idx_mode', 0)
      if len(s:number_map) > 0
        return space. s:get_number(a:i) . '%(%{airline#extensions#tabline#get_buffer_name('.bufnum.')}%)' . s:spc
      else
        return '['.(a:i+1).s:spc.'%(%{airline#extensions#tabline#get_buffer_name('.bufnum.')}%)'.']'
      endif
    else
      return space.'%(%{airline#extensions#tabline#get_buffer_name('.bufnum.')}%)'.s:spc
    endif
  endfunction

  let current_buffer = max([index(b.buffers, cur), 0])
  let last_buffer = len(b.buffers) - 1
  call b.insert_titles(current_buffer, 0, last_buffer)

  call b.add_section('airline_tabfill', '')
  call b.split()
  call b.add_section('airline_tabfill', '')
  if !show_buf_label_first
    call airline#extensions#tabline#add_label(b, 'buffers', 1)
  endif

  call airline#extensions#tabline#add_tab_label(b)

  let s:current_bufnr = cur
  let s:column_width = &columns
  let s:current_tabline = b.build()
  let s:current_visible_buffers = copy(b.buffers)
  " Do not remove from s:current_visible_buffers, this breaks s:select_tab()
  "if b._right_title <= last_buffer
  "  call remove(s:current_visible_buffers, b._right_title, last_buffer)
  "endif
  "if b._left_title > 0
  "  call remove(s:current_visible_buffers, 0, b._left_title)
  "endif
  return s:current_tabline
endfunction

function! s:get_number(index)
  if len(s:number_map) == 0
    return a:index
  endif
  let bidx_mode = get(g:, 'airline#extensions#tabline#buffer_idx_mode', 0)
  if bidx_mode > 1
    let l:count = bidx_mode == 2 ? a:index+11 : a:index+1
    return join(map(split(printf('%02d', l:count), '\zs'),
          \ 'get(s:number_map, v:val, "")'), '')
  else
    return get(s:number_map, a:index+1, '')
  endif
endfunction

function! s:select_tab(buf_index)
  " no-op when called in 'keymap_ignored_filetypes'
  if count(get(g:, 'airline#extensions#tabline#keymap_ignored_filetypes',
        \ ['vimfiler', 'nerdtree']), &ft)
    return
  endif
  let idx = a:buf_index
  if s:current_visible_buffers[0] == -1
    let idx = idx + 1
  endif

  let buf = get(s:current_visible_buffers, idx, 0)
  if buf != 0
     exec 'b!' . buf
   endif
endfunction

function! s:jump_to_tab(offset)
    let l = airline#extensions#tabline#buflist#list()
    let i = index(l, bufnr('%'))
    if i > -1
        exec 'b!' . l[(i + a:offset) % len(l)]
    endif
endfunction

function! s:map_keys()
  let bidx_mode = get(g:, 'airline#extensions#tabline#buffer_idx_mode', 1)
  if bidx_mode > 0
    if bidx_mode == 1
      for i in range(1, 9)
        exe printf('noremap <silent> <Plug>AirlineSelectTab%d :call <SID>select_tab(%d)<CR>', i, i-1)
      endfor
    else
      let start_idx = bidx_mode == 2 ? 11 : 1
      for i in range(start_idx, 99)
        exe printf('noremap <silent> <Plug>AirlineSelectTab%02d :call <SID>select_tab(%d)<CR>', i, i-start_idx)
      endfor
    endif
    noremap <silent> <Plug>AirlineSelectPrevTab :<C-u>call <SID>jump_to_tab(-v:count1)<CR>
    noremap <silent> <Plug>AirlineSelectNextTab :<C-u>call <SID>jump_to_tab(v:count1)<CR>
    " Enable this for debugging
    " com! AirlineBufferList :echo map(copy(s:current_visible_buffers), {i,k -> k.": ".bufname(k)})
  endif
endfunction

function! airline#extensions#tabline#buffers#clickbuf(minwid, clicks, button, modifiers) abort
    " Clickable buffers
    " works only in recent NeoVim with has('tablineat')

    " single mouse button click without modifiers pressed
    if a:clicks == 1 && a:modifiers !~# '[^ ]'
      if a:button is# 'l'
        " left button - switch to buffer
        silent execute 'buffer' a:minwid
      elseif a:button is# 'm'
        " middle button - delete buffer

        if get(g:, 'airline#extensions#tabline#middle_click_preserves_windows', 0) == 0 || winnr('$') == 1
          " just simply delete the clicked buffer. This will cause windows
          " associated with the clicked buffer to be closed.
          silent execute 'bdelete' a:minwid
        else
          " find windows displaying the clicked buffer and open an new
          " buffer in them.
          let current_window = bufwinnr("%")
          let window_number = bufwinnr(a:minwid)
          let last_window_visited = -1

          " Set to 1 if the clicked buffer was open in any windows.
          let buffer_in_window = 0

          " Find the next window with the clicked buffer open. If bufwinnr()
          " returns the same window number, this is because we clicked a new
          " buffer, and then tried editing a new buffer. Vim won't create a
          " new empty buffer for the same window, so we get the same window
          " number from bufwinnr(). In this case we just give up and don't
          " delete the buffer.
          " This could be made cleaner if we could check if the clicked buffer
          " is a new buffer, but I don't know if there is a way to do that.
          while window_number != -1 && window_number != last_window_visited
            let buffer_in_window = 1
            silent execute window_number . 'wincmd w'
            silent execute 'enew'
            let last_window_visited = window_number
            let window_number = bufwinnr(a:minwid)
          endwhile
          silent execute current_window . 'wincmd w'
          if window_number != last_window_visited || buffer_in_window == 0
            silent execute 'bdelete' a:minwid
          endif
        endif
      endif
    endif
endfunction
