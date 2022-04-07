"=============================================================================
" tabline.vim --- SpaceVim tabline
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section core#tabline, layers-core-tabline
" @parentsection layers
" This layer provides default tabline for SpaceVim
" If you want to use airline's tabline, just disable this layer
" >
"   [[layers]]
"     name = "core#tabline"
"     enable = false
" <
" @subsection Layer options
"
" 1. `enable_default_mappings`: Enable/disable default key bindings. This is
" enabled by default.
"
" @subsection Key bindings
" >
"   Key binding          Description
"   Ctrl-Shift-Right     Move current tabpage to the right
"   Ctrl-Shift-Left      Move current tabpage to the left
" <

scriptencoding utf-8

if exists('g:_spacevim_tabline_loaded')
  finish
endif

let g:_spacevim_tabline_loaded = 1

" loadding APIs {{{
let s:MESSLETTERS = SpaceVim#api#import('messletters')
let s:FILE = SpaceVim#api#import('file')
let s:BUFFER = SpaceVim#api#import('vim#buffer')
let s:HI = SpaceVim#api#import('vim#highlight')
let s:LOG = SpaceVim#logger#derive('tabline ')
let s:SYS = SpaceVim#api#import('system')
let s:TAB = SpaceVim#api#import('vim#tab')
" }}}


" init
let s:buffers = s:BUFFER.listed_buffers()

let s:separators = {
      \ 'arrow' : ["\ue0b0", "\ue0b2"],
      \ 'curve' : ["\ue0b4", "\ue0b6"],
      \ 'slant' : ["\ue0b8", "\ue0ba"],
      \ 'brace' : ["\ue0d2", "\ue0d4"],
      \ 'fire' : ["\ue0c0", "\ue0c2"],
      \ 'nil' : ['', ''],
      \ }
let s:i_separators = {
      \ 'arrow' : ["\ue0b1", "\ue0b3"],
      \ 'slant' : ["\ue0b9", "\ue0bb"],
      \ 'bar' : ['|', '|'],
      \ 'nil' : ['', ''],
      \ }

let s:enable_default_mappings = 1

function! s:get_no_empty(a, b) abort
  if empty(a:a)
    return a:b
  else
    return a:a
  endif
endfunction

function! s:move_tabpage(direction)
  " get number of tab pages.
  let ntp = tabpagenr("$")

  if ntp > 1
    " get number of current tab page.
    let ctpn = tabpagenr()
    if a:direction > 0
      let index = (ctpn + a:direction) % ntp
      if index == 0
        let index = ntp
      elseif index == 1
        let index = 0
      endif
    else
      let index = (ctpn + a:direction) % ntp
      if index < 0
        let index = ntp + index
      endif
      if index == 0
        let index = ntp
      elseif index == 1
        let index = 0
      else
        let index -= 1
      endif
    endif
    " move tab page.
    execute "tabmove ".index
  endif
endfunction

function! s:tabname(bufnr) abort
  let name = bufname(a:bufnr)
  if name ==# '\[Vader\]'
    let fn = '[Vader]'
  else
    let fn = fnamemodify(name, ':t')
  endif
  if g:spacevim_enable_tabline_ft_icon || get(g:, 'spacevim_enable_tabline_filetype_icon', 0)
    let icon = s:FILE.fticon(fn)
    if !empty(icon)
      let fn = fn . ' ' . icon
    endif
  endif
  if empty(fn)
    return 'No Name'
  else
    return fn
  endif
endfunction

function! s:wrap_id(id) abort
  if g:spacevim_buffer_index_type == 3
    let id = s:MESSLETTERS.index_num(a:id)
  elseif g:spacevim_buffer_index_type == 4
    let id = a:id
  else
    let id = s:MESSLETTERS.bubble_num(a:id, g:spacevim_buffer_index_type)
  endif
  return id . ' '
endfunction

" build the tab item, the first argv is bufnr, and the second argv is tabnr
function! s:buffer_item(bufnr, ...) abort
  let name = s:tabname(a:bufnr)
  let tabnr = get(a:000, 0, -1)
  if tabnr != -1
    let tabname = gettabvar(tabnr, '_spacevim_tab_name', '')
    let len = strlen(tabname) + 3
  else
    let tabname = ''
    let len = strlen(name) + 3
  endif
  let item = {
        \ 'bufnr' : a:bufnr,
        \ 'len' :  len,
        \ 'bufname' : name,
        \ 'tabname' : tabname,
        \ 'tabnr' : tabnr,
        \ }
  return item
endfunction

" check if the items len longer than &columns
" the check_len function should also check the tab name.
function! s:check_len(items) abort
  let len = 0
  for item in a:items
    let len += item.len
  endfor
  return len > &columns - 25
endfunction

function! s:is_modified(nr) abort
  return getbufvar(a:nr, '&modified', 0)
endfunction

" cache shown_items
let s:shown_items = []
function! SpaceVim#layers#core#tabline#get() abort
  let tabpage_counts = tabpagenr('$')
  let all_tabline_items = []
  let shown_items = []

  if tabpage_counts > 1
    let current_tabnr = tabpagenr()
    let previous_tabnr = s:TAB.previous_tabpagenr()
    let matched_len = 0
    for i in range(1, tabpage_counts)
      call add(all_tabline_items, s:buffer_item(tabpagebuflist(i)[tabpagewinnr(i) - 1], i))
    endfor
    if previous_tabnr < current_tabnr
      for i in range(previous_tabnr == 0 ? 1 : previous_tabnr, current_tabnr)
        call add(shown_items, all_tabline_items[i - 1])
        if s:check_len(shown_items)
          let matched_len = 1
          call remove(shown_items, 0)
        endif
      endfor
      if !matched_len && current_tabnr < tabpage_counts
        for i in range(current_tabnr + 1, tabpage_counts)
          call add(shown_items, all_tabline_items[i - 1])
          if s:check_len(shown_items)
            let matched_len = 1
            call remove(shown_items, -1)
            break
          endif
        endfor
      endif
      if !matched_len && previous_tabnr > 1
        for i in reverse(range(1, previous_tabnr - 1))
          call insert(shown_items, all_tabline_items[i - 1])
          if s:check_len(shown_items)
            call remove(shown_items, 0)
            break
          endif
        endfor
      endif
    else
      for i in range(current_tabnr, previous_tabnr > tabpage_counts ? tabpage_counts : previous_tabnr)
        call add(shown_items, all_tabline_items[i - 1])
        if s:check_len(shown_items)
          let matched_len = 1
          call remove(shown_items, -1)
          break
        endif
      endfor
      if !matched_len && current_tabnr > 1
        for i in reverse(range(1, current_tabnr - 1))
          call insert(shown_items, all_tabline_items[i - 1])
          if s:check_len(shown_items)
            let matched_len = 1
            call remove(shown_items, 0)
            break
          endif
        endfor
      endif
      if !matched_len && previous_tabnr < tabpage_counts
        for i in range(previous_tabnr + 1, tabpage_counts)
          call add(shown_items, all_tabline_items[i - 1])
          if s:check_len(shown_items)
            call remove(shown_items, -1)
            break
          endif
        endfor
      endif
    endif
    " get the list of displayed items
    let s:shown_items = shown_items
    if empty(shown_items)
      return ''
    endif
    let t = ''
    let right_hidden_tab_number = shown_items[0].tabnr - 1
    let left_hidden_tab_number = tabpage_counts - shown_items[-1].tabnr
    if right_hidden_tab_number > 0
      let t .= '%#SpaceVim_tabline_a#'  .  ' << '. right_hidden_tab_number
    endif
    if current_tabnr == shown_items[0].tabnr
      if s:is_modified(shown_items[0].bufnr)
        if right_hidden_tab_number > 0
          let t .= ' %#SpaceVim_tabline_a_SpaceVim_tabline_m#' . s:lsep 
        endif
        let t .= '%#SpaceVim_tabline_m# '
      else
        if right_hidden_tab_number > 0
          let t .= ' ' . s:ilsep 
        endif
        let t .= '%#SpaceVim_tabline_a# '
      endif
    else
      if right_hidden_tab_number > 0
        let t .= ' %#SpaceVim_tabline_a_SpaceVim_tabline_b#' . s:lsep 
      endif
      let t .= s:is_modified(shown_items[0].bufnr) ? '%#SpaceVim_tabline_m_i# ' : '%#SpaceVim_tabline_b# '
    endif
    let index = 1
    for item in shown_items[:-2]
      if has('tablineat')
        let t .=  '%' . index . '@SpaceVim#layers#core#tabline#jump@'
      endif
      let t .= s:wrap_id(index)
      let t .= s:get_no_empty(gettabvar(item.tabnr, '_spacevim_tab_name'), item.bufname)
      let index += 1
      if item.tabnr == current_tabnr
        if s:is_modified(item.bufnr)
          let t .= ' %#SpaceVim_tabline_m_SpaceVim_tabline_b#' . s:lsep 
        else
          let t .= ' %#SpaceVim_tabline_a_SpaceVim_tabline_b#' . s:lsep 
        endif
        let t .= s:is_modified(shown_items[index-1].bufnr) ? '%#SpaceVim_tabline_m_i# ' : '%#SpaceVim_tabline_b# '
      elseif item.tabnr == current_tabnr - 1
        " check if current_tabnr is modified
        if s:is_modified(s:BUFFER.bufnr())
          let t .= ' %#SpaceVim_tabline_b_SpaceVim_tabline_m#' . s:lsep . '%#SpaceVim_tabline_m# '
        else
          let t .= ' %#SpaceVim_tabline_b_SpaceVim_tabline_a#' . s:lsep . '%#SpaceVim_tabline_a# '
        endif
      else
        let t .= s:is_modified(shown_items[index-1].bufnr) ? '%#SpaceVim_tabline_m_i# ' : '%#SpaceVim_tabline_b# '
        let t .= s:ilsep . ' '
      endif
    endfor
    let item = shown_items[-1]
    if has('tablineat')
      let t .=  '%' . index . '@SpaceVim#layers#core#tabline#jump@'
    endif
    let t .= s:wrap_id(index) . s:get_no_empty(gettabvar(item.tabnr, '_spacevim_tab_name'), item.bufname)
    if item.tabnr == current_tabnr
      if left_hidden_tab_number > 0 
        if s:is_modified(item.bufnr)
          let t .= ' %#SpaceVim_tabline_m_SpaceVim_tabline_a#' . s:lsep
          let t .= ' %#SpaceVim_tabline_a#'  . left_hidden_tab_number . ' >>'
          let t .= ' %#SpaceVim_tabline_a_SpaceVim_tabline_b#' . s:lsep . '%#SpaceVim_tabline_b#'
        else
          let t .= ' ' . s:ilsep
          let t .= ' ' . left_hidden_tab_number . ' >>'
          let t .= ' %#SpaceVim_tabline_a_SpaceVim_tabline_b#' . s:lsep . '%#SpaceVim_tabline_b#'
        endif
      else
        if s:is_modified(item.bufnr)
          let t .= ' %#SpaceVim_tabline_m_SpaceVim_tabline_b#' . s:lsep . '%#SpaceVim_tabline_b#'
        else
          let t .= ' %#SpaceVim_tabline_a_SpaceVim_tabline_b#' . s:lsep . '%#SpaceVim_tabline_b#'
        endif
      endif
    else
      if left_hidden_tab_number > 0 
        let t .= ' %#SpaceVim_tabline_b_SpaceVim_tabline_a#' . s:lsep
        let t .= ' %#SpaceVim_tabline_a#'  . left_hidden_tab_number . ' >>'
        let t .= ' %#SpaceVim_tabline_a_SpaceVim_tabline_b#' . s:lsep . '%#SpaceVim_tabline_b#'
      else
        let t .= ' ' . s:ilsep
      endif
    endif
    " how many buffers after the last item are hidden?
    let t .= '%=%#SpaceVim_tabline_a_SpaceVim_tabline_b#' . s:rsep
    let t .= '%#SpaceVim_tabline_a# Tabs '
    return t
  else
    let s:buffers = s:BUFFER.listed_buffers()
    if empty(s:buffers)
      return ''
    endif
    for i in range(len(s:buffers))
      call add(all_tabline_items, s:buffer_item(s:buffers[i]))
    endfor
    let current_buf_index = index(s:buffers, s:BUFFER.bufnr())
    let previous_buf_index =  index(s:buffers, s:BUFFER.bufnr('#'))
    let matched_len = 0
    if current_buf_index ==# -1
      let shown_items = filter(s:shown_items, 'buflisted(v:val.bufnr)')
    else
      if previous_buf_index < current_buf_index
        if previous_buf_index == -1
          let previous_buf_index = 0
        endif
        for i in range(previous_buf_index, current_buf_index)
          call add(shown_items, all_tabline_items[i])
          if s:check_len(shown_items)
            let matched_len = 1
            call remove(shown_items, 0)
          endif
        endfor
        if !matched_len && current_buf_index < len(s:buffers) - 1
          for i in range(current_buf_index + 1, len(s:buffers) - 1)
            call add(shown_items, all_tabline_items[i])
            if s:check_len(shown_items)
              let matched_len = 1
              call remove(shown_items, -1)
              break
            endif
          endfor
        endif
        if !matched_len && previous_buf_index > 0
          for i in reverse(range(0, previous_buf_index - 1))
            call insert(shown_items, all_tabline_items[i])
            if s:check_len(shown_items)
              call remove(shown_items, 0)
              break
            endif
          endfor
        endif
      else
        if previous_buf_index == -1
          let previous_buf_index = len(s:buffers) - 1
        endif
        for i in range(current_buf_index, previous_buf_index)
          call add(shown_items, all_tabline_items[i])
          if s:check_len(shown_items)
            let matched_len = 1
            call remove(shown_items, -1)
            break
          endif
        endfor
        if !matched_len && current_buf_index > 0
          for i in reverse(range(0, current_buf_index - 1))
            call insert(shown_items, all_tabline_items[i])
            if s:check_len(shown_items)
              let matched_len = 1
              call remove(shown_items, 0)
              break
            endif
          endfor
        endif
        if !matched_len && previous_buf_index < len(s:buffers) - 1
          for i in range(previous_buf_index + 1, len(s:buffers) - 1)
            call add(shown_items, all_tabline_items[i])
            if s:check_len(shown_items)
              call remove(shown_items, -1)
              break
            endif
          endfor
        endif
      endif
      let s:shown_items = shown_items
      let g:_spacevim_list_buffers = map(deepcopy(s:shown_items), 'v:val.bufnr')
    endif
    if empty(shown_items)
      return ''
    endif
    let t = ''
    " how many buffers before the first item are hidden.
    let right_hidden_buffer_number = index(s:buffers, shown_items[0].bufnr)
    let left_hidden_buffer_number = len(s:buffers) - 1 - index(s:buffers, shown_items[-1].bufnr)
    if right_hidden_buffer_number > 0
      let t .= '%#SpaceVim_tabline_a#'  .  ' << '. right_hidden_buffer_number
    endif
    if s:BUFFER.bufnr() == shown_items[0].bufnr
      if s:is_modified(shown_items[0].bufnr)
        if right_hidden_buffer_number > 0
          let t .= ' %#SpaceVim_tabline_a_SpaceVim_tabline_m#' . s:lsep 
        endif
        let t .= '%#SpaceVim_tabline_m# '
      else
        if right_hidden_buffer_number > 0
          let t .= ' ' . s:ilsep 
        endif
        let t .= '%#SpaceVim_tabline_a# '
      endif
    else
      if right_hidden_buffer_number > 0
        let t .= ' %#SpaceVim_tabline_a_SpaceVim_tabline_b#' . s:lsep 
      endif
      let t .= s:is_modified(shown_items[0].bufnr) ? '%#SpaceVim_tabline_m_i# ' : '%#SpaceVim_tabline_b# '
    endif
    let index = 1
    for item in shown_items[:-2]
      if has('tablineat')
        let t .=  '%' . index . '@SpaceVim#layers#core#tabline#jump@'
      endif
      let t .= s:wrap_id(index) . item.bufname
      let index += 1
      if item.bufnr == s:BUFFER.bufnr()
        if s:is_modified(item.bufnr)
          let t .= ' %#SpaceVim_tabline_m_SpaceVim_tabline_b#' . s:lsep
        else
          let t .= ' %#SpaceVim_tabline_a_SpaceVim_tabline_b#' . s:lsep
        endif
        let t .= s:is_modified(s:buffers[index(s:buffers, item.bufnr) + 1]) ? '%#SpaceVim_tabline_m_i# ' : '%#SpaceVim_tabline_b# '
      elseif index(s:buffers, s:BUFFER.bufnr()) > 0 && item.bufnr == s:buffers[index(s:buffers, s:BUFFER.bufnr()) - 1]
        if s:is_modified(s:BUFFER.bufnr())
          let t .= ' %#SpaceVim_tabline_b_SpaceVim_tabline_m#' . s:lsep . '%#SpaceVim_tabline_m# '
        else
          let t .= ' %#SpaceVim_tabline_b_SpaceVim_tabline_a#' . s:lsep . '%#SpaceVim_tabline_a# '
        endif
      else
        let t .= s:is_modified(s:buffers[index(s:buffers, item.bufnr) + 1]) ? '%#SpaceVim_tabline_m_i# ' : '%#SpaceVim_tabline_b# '
        let t .= s:ilsep . ' '
      endif
    endfor
    let item = shown_items[-1]
    if has('tablineat')
      let t .=  '%' . index . '@SpaceVim#layers#core#tabline#jump@'
    endif
    let t .= s:wrap_id(index) . item.bufname
    if item.bufnr == s:BUFFER.bufnr()
      if left_hidden_buffer_number > 0 
        if s:is_modified(item.bufnr)
          let t .= ' %#SpaceVim_tabline_m_SpaceVim_tabline_a#' . s:lsep
          let t .= ' %#SpaceVim_tabline_a#'  . left_hidden_buffer_number . ' >>'
          let t .= ' %#SpaceVim_tabline_a_SpaceVim_tabline_b#' . s:lsep . '%#SpaceVim_tabline_b#'
        else
          let t .= ' ' . s:ilsep
          let t .= ' ' . left_hidden_buffer_number . ' >>'
          let t .= ' %#SpaceVim_tabline_a_SpaceVim_tabline_b#' . s:lsep . '%#SpaceVim_tabline_b#'
        endif
      else
        if s:is_modified(item.bufnr)
          let t .= ' %#SpaceVim_tabline_m_SpaceVim_tabline_b#' . s:lsep . '%#SpaceVim_tabline_b#'
        else
          let t .= ' %#SpaceVim_tabline_a_SpaceVim_tabline_b#' . s:lsep . '%#SpaceVim_tabline_b#'
        endif
      endif
    else
      if left_hidden_buffer_number > 0 
        let t .= ' %#SpaceVim_tabline_b_SpaceVim_tabline_a#' . s:lsep
        let t .= ' %#SpaceVim_tabline_a#'  . left_hidden_buffer_number . ' >>'
        let t .= ' %#SpaceVim_tabline_a_SpaceVim_tabline_b#' . s:lsep . '%#SpaceVim_tabline_b#'
      else
        let t .= ' ' . s:ilsep
      endif
    endif
    " how many buffers after the last item are hidden?
    let t .= '%=%#SpaceVim_tabline_a_SpaceVim_tabline_b#' . s:rsep
    let t .= '%#SpaceVim_tabline_a# Buffers '
    return t
  endif
endfunction

function! SpaceVim#layers#core#tabline#config() abort
  let [s:lsep , s:rsep] = get(s:separators, g:spacevim_statusline_separator, s:separators['arrow'])
  let [s:ilsep , s:irsep] = get(s:i_separators, g:spacevim_statusline_iseparator, s:separators['arrow'])
  set tabline=%!SpaceVim#layers#core#tabline#get()
  augroup SpaceVim_tabline
    autocmd!
    autocmd ColorScheme * call SpaceVim#layers#core#tabline#def_colors()
  augroup END

  if s:enable_default_mappings
    nnoremap <silent> <C-S-Left> :call <SID>move_tabpage(-1)<CR>
    nnoremap <silent> <C-S-Right> :call <SID>move_tabpage(1)<CR>
  endif

  let shift_keys = {
        \  '1': '!',
        \  '2': '@',
        \  '3': '#',
        \  '4': '$',
        \  '5': '%',
        \  '6': '^',
        \  '7': '&',
        \  '8': '*',
        \  '9': '(',
        \  '0': ')'
        \}

  for i in range(1, 20)
    let key = i % 10

    if i > 10
      let key = shift_keys[string(key)]
    endif

    exe "call SpaceVim#mapping#def('nmap <silent>', '<leader>" . key
          \ . "', ':call SpaceVim#layers#core#tabline#jump("
          \ . i . ")<cr>', 'Switch to airline tab " . i
          \ . "', '', 'tabline index " . i . "')"
  endfor
endfunction

function! SpaceVim#layers#core#tabline#jump(id, ...) abort
  if len(s:shown_items) >= a:id
    let item = s:shown_items[a:id - 1]
    let mouse = get(a:000, 1, '')
    if tabpagenr('$') > 1
      if mouse ==# 'm'
        exe 'tabclose ' . item.tabnr
      elseif mouse ==# 'l'
        exe 'tabnext' . item.tabnr
      else
        exe 'tabnext' . item.tabnr
      endif
    else
      if mouse ==# 'm'
        exe 'bd ' . item.bufnr
      elseif mouse ==# 'l'
        exe 'silent b ' . item.bufnr
      else
        exe 'silent b ' . item.bufnr
      endif
    endif
  endif
endfunction

function! SpaceVim#layers#core#tabline#def_colors() abort
  let name = get(g:, 'colors_name', 'gruvbox')
  if !empty(g:spacevim_custom_color_palette)
    let t = g:spacevim_custom_color_palette
  else
    try
      let t = SpaceVim#mapping#guide#theme#{name}#palette()
    catch /^Vim\%((\a\+)\)\=:E117/
      let t = SpaceVim#mapping#guide#theme#gruvbox#palette()
    endtry
  endif
  exe 'hi! SpaceVim_tabline_a ctermbg=' . t[0][2] . ' ctermfg=' . t[0][3] . ' guibg=' . t[0][1] . ' guifg=' . t[0][0]
  if name ==# 'palenight'
    exe 'hi! SpaceVim_tabline_b ctermbg=' . '236'   . ' ctermfg=' . t[1][3] . ' guibg=' .'#44475a'. ' guifg=' . t[1][0]
  else
    exe 'hi! SpaceVim_tabline_b ctermbg=' . t[1][2] . ' ctermfg=' . t[1][3] . ' guibg=' . t[1][1] . ' guifg=' . t[1][0]
  endif
  " SpaceVim_tabline_c is for modified buffers
  exe 'hi! SpaceVim_tabline_m ctermbg=' . t[4][3] . ' ctermfg=' . t[4][2] . ' guibg=' . t[4][1] . ' guifg=' . t[4][0]
  if name ==# 'palenight'
    exe 'hi! SpaceVim_tabline_m_i ctermbg=' . '236' . ' ctermfg=' . t[4][3] . ' guibg=' . '#44475a' . ' guifg=' . t[4][1]
  else
    exe 'hi! SpaceVim_tabline_m_i ctermbg=' . t[1][2] . ' ctermfg=' . t[4][3] . ' guibg=' . t[1][1] . ' guifg=' . t[4][1]
  endif
  call s:HI.hi_separator('SpaceVim_tabline_a', 'SpaceVim_tabline_b')
  call s:HI.hi_separator('SpaceVim_tabline_m', 'SpaceVim_tabline_b')
  call s:HI.hi_separator('SpaceVim_tabline_m', 'SpaceVim_tabline_a')
endfunction

function! SpaceVim#layers#core#tabline#health() abort
  call SpaceVim#layers#core#tabline#config()
  return 1
endfunction

function! SpaceVim#layers#core#tabline#set_variable(var) abort
  let s:enable_default_mappings = get(a:var, 'enable_default_mappings', s:enable_default_mappings)
endfunction

function! SpaceVim#layers#core#tabline#get_options() abort

  return ['enable_default_mappings']

endfunction
