"=============================================================================
" tabline.vim --- SpaceVim tabline
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section core#tabline, layer-core-tabline
" @parentsection layers
" This layer provides default tabline for SpaceVim
" If you want to use airline's tabline, just disable this layer
" >
"   [[layers]]
"     name = "core#tabline"
"     enable = false
" <

scriptencoding utf-8

" loadding APIs {{{
let s:MESSLETTERS = SpaceVim#api#import('messletters')
let s:FILE = SpaceVim#api#import('file')
let s:BUFFER = SpaceVim#api#import('vim#buffer')
let s:HI = SpaceVim#api#import('vim#highlight')
let s:LOG = SpaceVim#logger#derive('tabline')
" }}}


let g:_spacevim_tabline_loaded = 1
let s:buffers = s:BUFFER.listed_buffers()

" init
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
      \ 'bar' : ['|', '|'],
      \ 'nil' : ['', ''],
      \ }


" each iterm should be :
" {
"  'bufnr': '',
"  'len' : '',
"  'istab' : '',
"  'bufname' : ''
" }
let s:tabline_items = []

function! s:scroll_left() abort
  let nr = s:tabline_items[0].bufnr
  if nr > s:buffers[0]
    call remove(s:tabline_items, -1)
    let bufnr = s:buffers[index(s:buffers, nr) - 1]
    let name = s:tabname(bufnr)
    let item = [{
          \ 'bufnr' : bufnr,
          \ 'len' :  strlen(name),
          \ 'bufname' : name,
          \     }]
    let s:tabline_items = item + s:tabline_items
  endif
endfunction


function! s:scroll_right() abort
  let nr = s:tabline_items[-1].bufnr
  if nr < s:buffers[-1]
    call remove(s:tabline_items, 0)
    let bufnr = s:buffers[index(s:buffers, nr) + 1]
    let name = s:tabname(bufnr)
    let item = [{
          \ 'bufnr' : bufnr,
          \ 'len' :  strlen(name),
          \ 'bufname' : name,
          \     }]
    let s:tabline_items = s:tabline_items + item
  endif
endfunction

function! s:switch_index(idx) abort
  let bufnr = s:tabline_items[a:idx + 1].bufnr 
  exe 'b' . bufnr
endfunction

function! s:enter_new_buffer(bufnr) abort
  let bufnr = a:bufnr
  call s:LOG.info('enter new buffer: ' . a:bufnr)
  if getbufvar(a:bufnr, '&buflisted')
    let name = s:tabname(bufnr)
    let item = [{
          \ 'bufnr' : bufnr,
          \ 'len' :  strlen(name),
          \ 'bufname' : name,
          \     }]
    let s:tabline_items = s:tabline_items + item
    while s:check_len()
      call remove(s:tabline_items, 0)
    endwhile
  endif
endfunction


function! s:delete_buffer(bufnr) abort
  let index = index(s:tabline_items, 'v:val.bufnr == a:bufnr')
  call remove(s:tabline_items, index)
endfunction

function! s:check_len() abort
  let len = 0
  for item in s:tabline_items
    let len += item.len
  endfor
  return len > &columns
endfunction


function! s:tabname(id) abort
  if g:spacevim_buffer_index_type == 3
    let id = s:MESSLETTERS.index_num(a:id)
  elseif g:spacevim_buffer_index_type == 4
    let id = a:id
  else
    let id = s:MESSLETTERS.bubble_num(a:id, g:spacevim_buffer_index_type) . ' '
  endif
  let fn = fnamemodify(bufname(a:id), ':t')
  if g:spacevim_enable_tabline_filetype_icon
    let icon = s:FILE.fticon(fn)
    if !empty(icon)
      let fn = fn . ' ' . icon
    endif
  endif
  if empty(fn)
    return 'No Name'
  else
    return id . fn
  endif
endfunction

function! s:need_show_bfname(stack, nr) abort
  let dupbufs = filter(a:stack, "fnamemodify(bufname(v:val), ':t') ==# fnamemodify(bufname(a:nr), ':t')")
  if len(dupbufs) >= 2
    for i in dupbufs
      call setbufvar(i, '_spacevim_statusline_showbfname', 1)
    endfor
  endif
endfunction

function! s:is_modified(nr) abort
  return getbufvar(a:nr, '&modified', 0)
endfunction

function! Test() abort
  return s:
endfunction


func! TablineGet() abort
  let nr = tabpagenr('$')
  let t = ''
  " the stack should be the bufnr stack of tabline
  let stack = []
  if len(s:tabline_items) == 0
    return ''
  endif
  let ct = bufnr('%')
  let ct_idex = index(s:tabline_items, 'v:val.bufnr ==# ct')
  let pt = ct_idex > 0 ? s:tabline_items[ct_idex - 1] : -1
  if ct == get(s:tabline_items, 0, {'bufnr' : -1})['bufnr']
    if getbufvar(ct, '&modified', 0)
      let t = '%#SpaceVim_tabline_m# '
    else
      let t = '%#SpaceVim_tabline_a# '
    endif
  else
    let t = '%#SpaceVim_tabline_b# '
  endif
  let index = 1
  for i in map(deepcopy(s:tabline_items), 'v:val.bufnr')
    if getbufvar(i, '&modified', 0) && i != ct
      let t .= '%#SpaceVim_tabline_m_i#'
    elseif i == ct
      if s:is_modified(i)
        let t .= '%#SpaceVim_tabline_m#'
      else
        let t .= '%#SpaceVim_tabline_a#'
      endif
    else
      let t .= '%#SpaceVim_tabline_b#'
    endif
    let name = fnamemodify(bufname(i), ':t')
    if empty(name)
      let name = 'No Name'
    endif
    call add(stack, i)
    call s:need_show_bfname(stack, i)
    " here is the begin of a tab name
    if has('tablineat')
      let t .=  '%' . index . '@SpaceVim#layers#core#tabline#jump@'
    endif
    if g:spacevim_buffer_index_type == 3
      let id = s:MESSLETTERS.index_num(index)
    elseif g:spacevim_buffer_index_type == 4
      let id = index
    else
      let id = s:MESSLETTERS.circled_num(index, g:spacevim_buffer_index_type)
    endif
    if g:spacevim_enable_tabline_filetype_icon
      let icon = s:FILE.fticon(name)
      if !empty(icon)
        let name = name . ' ' . icon
      endif
    endif
    let t .= id . ' ' . name
    " here is the end of a tabname
    if has('tablineat')
      let t .= '%X'
    endif
    if i == ct
      if s:is_modified(i)
        let t .= ' %#SpaceVim_tabline_m_SpaceVim_tabline_b#' . s:lsep . ' '
      else
        let t .= ' %#SpaceVim_tabline_a_SpaceVim_tabline_b#' . s:lsep . ' '
      endif
    elseif i == pt
      if getbufvar(ct, '&modified', 0)
        let t .= ' %#SpaceVim_tabline_b_SpaceVim_tabline_m#' . s:lsep . ' '
      else
        let t .= ' %#SpaceVim_tabline_b_SpaceVim_tabline_a#' . s:lsep . ' '
      endif
    else
      let t .= ' %#SpaceVim_tabline_b#' . s:ilsep . ' '
    endif
    let index += 1
  endfor
  let t .= '%=%#SpaceVim_tabline_a_SpaceVim_tabline_b#' . s:rsep
  let t .= '%#SpaceVim_tabline_a# Buffers '
  return t
endf

function! SpaceVim#layers#core#tabline#get() abort
  let nr = tabpagenr('$')
  let t = ''
  " the stack should be the bufnr stack of tabline
  let stack = []
  if nr > 1
    let ct = tabpagenr()
    if ct == 1
      let t = '%#SpaceVim_tabline_a#  '
    else
      let t = '%#SpaceVim_tabline_b#  '
    endif
    let index = 1
    for i in range(1, nr)
      if i == ct
        let t .= '%#SpaceVim_tabline_a#'
      endif
      let buflist = tabpagebuflist(i)
      let winnr = tabpagewinnr(i)
      let name = fnamemodify(bufname(buflist[winnr - 1]), ':t')
      let tabname = gettabvar(i, '_spacevim_tab_name', '')
      if has('tablineat')
        let t .=  '%' . index . '@SpaceVim#layers#core#tabline#jump@'
      elseif !has('nvim')
        let t .= '%' . index . 'T'
      endif
      if g:spacevim_buffer_index_type == 3
        let id = s:MESSLETTERS.index_num(i)
      elseif g:spacevim_buffer_index_type == 4
        let id = i
      else
        let id = s:MESSLETTERS.circled_num(i, g:spacevim_buffer_index_type)
      endif
      if empty(tabname)
        if empty(name)
          let name = 'No Name'
        endif
        call add(stack, buflist[winnr - 1])
        call s:need_show_bfname(stack, buflist[winnr - 1])
        if g:spacevim_enable_tabline_filetype_icon
          let icon = s:FILE.fticon(name)
          if !empty(icon)
            let name = name . ' ' . icon
          endif
        endif
        let t .= id . ' ' . name
      else
        let t .= id . ' T:' . tabname
      endif
      if i == ct - 1
        let t .= ' %#SpaceVim_tabline_b_SpaceVim_tabline_a#' . s:lsep . ' '
      elseif i == ct
        let t .= ' %#SpaceVim_tabline_a_SpaceVim_tabline_b#' . s:lsep . ' '
      else
        let t .= ' ' . s:ilsep . ' '
      endif
      let index += 1
    endfor
    let t .= '%=%#SpaceVim_tabline_a_SpaceVim_tabline_b#' . s:rsep
    let t .= '%#SpaceVim_tabline_a# Tabs '
  else
    let s:buffers = s:BUFFER.listed_buffers()
    let g:_spacevim_list_buffers = s:buffers
    if len(s:buffers) == 0
      return ''
    endif
    let ct = bufnr('%')
    let pt = index(s:buffers, ct) > 0 ? s:buffers[index(s:buffers, ct) - 1] : -1
    if ct == get(s:buffers, 0, -1)
      if getbufvar(ct, '&modified', 0)
        let t = '%#SpaceVim_tabline_m# '
      else
        let t = '%#SpaceVim_tabline_a# '
      endif
    else
      let t = '%#SpaceVim_tabline_b# '
    endif
    let index = 1
    for i in s:buffers
      if getbufvar(i, '&modified', 0) && i != ct
        let t .= '%#SpaceVim_tabline_m_i#'
      elseif i == ct
        if s:is_modified(i)
          let t .= '%#SpaceVim_tabline_m#'
        else
          let t .= '%#SpaceVim_tabline_a#'
        endif
      else
        let t .= '%#SpaceVim_tabline_b#'
      endif
      let name = fnamemodify(bufname(i), ':t')
      if empty(name)
        let name = 'No Name'
      endif
      call add(stack, i)
      call s:need_show_bfname(stack, i)
      " here is the begin of a tab name
      if has('tablineat')
        let t .=  '%' . index . '@SpaceVim#layers#core#tabline#jump@'
      endif
      if g:spacevim_buffer_index_type == 3
        let id = s:MESSLETTERS.index_num(index(s:buffers, i) + 1)
      elseif g:spacevim_buffer_index_type == 4
        let id = index(s:buffers, i) + 1
      else
        let id = s:MESSLETTERS.circled_num(index(s:buffers, i) + 1, g:spacevim_buffer_index_type)
      endif
      if g:spacevim_enable_tabline_filetype_icon
        let icon = s:FILE.fticon(name)
        if !empty(icon)
          let name = name . ' ' . icon
        endif
      endif
      let t .= id . ' ' . name
      " here is the end of a tabname
      if has('tablineat')
        let t .= '%X'
      endif
      if i == ct
        if s:is_modified(i)
          let t .= ' %#SpaceVim_tabline_m_SpaceVim_tabline_b#' . s:lsep . ' '
        else
          let t .= ' %#SpaceVim_tabline_a_SpaceVim_tabline_b#' . s:lsep . ' '
        endif
      elseif i == pt
        if getbufvar(ct, '&modified', 0)
          let t .= ' %#SpaceVim_tabline_b_SpaceVim_tabline_m#' . s:lsep . ' '
        else
          let t .= ' %#SpaceVim_tabline_b_SpaceVim_tabline_a#' . s:lsep . ' '
        endif
      else
        let t .= ' %#SpaceVim_tabline_b#' . s:ilsep . ' '
      endif
      let index += 1
    endfor
    let t .= '%=%#SpaceVim_tabline_a_SpaceVim_tabline_b#' . s:rsep
    let t .= '%#SpaceVim_tabline_a# Buffers '
  endif
  return t
endfunction

function! SpaceVim#layers#core#tabline#config() abort
  let [s:lsep , s:rsep] = get(s:separators, g:spacevim_statusline_separator, s:separators['arrow'])
  let [s:ilsep , s:irsep] = get(s:i_separators, g:spacevim_statusline_inactive_separator, s:separators['arrow'])
  set tabline=%!SpaceVim#layers#core#tabline#get()
  augroup SpaceVim_tabline
    autocmd!
    autocmd ColorScheme * call SpaceVim#layers#core#tabline#def_colors()
    autocmd BufNew * call s:enter_new_buffer(expand("<abuf>")+0)
    autocmd BufDelete,BufWipeout * call s:delete_buffer(expand("<abuf>")+0)
  augroup END

  " when load or create new buffer, add buffer nr to shown list, and update
  " tabline
  "
  " when switch to a buffer, update the shown list
  for i in range(1, 9)
    exe "call SpaceVim#mapping#def('nmap <silent>', '<leader>" . i
          \ . "', ':call SpaceVim#layers#core#tabline#jump("
          \ . i . ")<cr>', 'Switch to airline tab " . i
          \ . "', '', 'tabline index " . i . "')"
  endfor
  call SpaceVim#mapping#def('nmap', '<leader>-', ':bprevious<cr>', 'Switch to previous airline tag', '', 'window previous')
  call SpaceVim#mapping#def('nmap', '<leader>+', ':bnext<cr>', 'Switch to next airline tag', '', 'window next')
  "call SpaceVim#mapping#space#def('nmap', ['-'], 'bprevious', 'window previous', 1)
  "call SpaceVim#mapping#space#def('nmap', ['+'], 'bnext', 'window next', 1)
endfunction

function! SpaceVim#layers#core#tabline#jump(id, ...) abort
  if get(a:000, 2, '') ==# 'm'
    if tabpagenr('$') > 1
      exe 'tabnext' . a:id
      quit
    else
      if len(s:buffers) >= a:id
        let bid = s:buffers[a:id - 1]
        exe 'silent b' . bid
        bd
      endif
    endif
  elseif get(a:000, 2, '') ==# 'l'
    if tabpagenr('$') > 1
      exe 'tabnext' . a:id
    else
      if len(s:buffers) >= a:id
        let bid = s:buffers[a:id - 1]
        exe 'silent b' . bid
      endif
    endif
  else
    if tabpagenr('$') > 1
      exe 'tabnext' . a:id
    else
      if len(s:buffers) >= a:id
        let bid = s:buffers[a:id - 1]
        exe 'silent b' . bid
      endif
    endif
  endif
endfunction

function! SpaceVim#layers#core#tabline#def_colors() abort
  if !empty(g:spacevim_custom_color_palette)
    let t = g:spacevim_custom_color_palette
  else
    let name = get(g:, 'colors_name', 'gruvbox')
    try
      let t = SpaceVim#mapping#guide#theme#{name}#palette()
    catch /^Vim\%((\a\+)\)\=:E117/
      let t = SpaceVim#mapping#guide#theme#gruvbox#palette()
    endtry
  endif
  exe 'hi! SpaceVim_tabline_a ctermbg=' . t[0][2] . ' ctermfg=' . t[0][3] . ' guibg=' . t[0][1] . ' guifg=' . t[0][0]
  exe 'hi! SpaceVim_tabline_b ctermbg=' . t[1][2] . ' ctermfg=' . t[1][3] . ' guibg=' . t[1][1] . ' guifg=' . t[1][0]
  " SpaceVim_tabline_c is for modified buffers
  exe 'hi! SpaceVim_tabline_m ctermbg=' . t[4][3] . ' ctermfg=' . t[4][2] . ' guibg=' . t[4][1] . ' guifg=' . t[4][0]
  exe 'hi! SpaceVim_tabline_m_i ctermbg=' . t[1][2] . ' ctermfg=' . t[4][3] . ' guibg=' . t[1][1] . ' guifg=' . t[4][1]
  call s:HI.hi_separator('SpaceVim_tabline_a', 'SpaceVim_tabline_b')
  call s:HI.hi_separator('SpaceVim_tabline_m', 'SpaceVim_tabline_b')
  call s:HI.hi_separator('SpaceVim_tabline_m', 'SpaceVim_tabline_a')
endfunction
