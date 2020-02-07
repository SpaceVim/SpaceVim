"=============================================================================
" tabline.vim --- SpaceVim tabline
" Copyright (c) 2016-2019 Wang Shidong & Contributors
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
let s:messletters = SpaceVim#api#import('messletters')
let s:file = SpaceVim#api#import('file')
let s:BUFFER = SpaceVim#api#import('vim#buffer')
let s:HI = SpaceVim#api#import('vim#highlight')
let s:SYS = SpaceVim#api#import('system')

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

function! s:tabname(id) abort
  if g:spacevim_buffer_index_type == 3
    let id = s:messletters.index_num(a:id)
  elseif g:spacevim_buffer_index_type == 4
    let id = a:id
  else
    let id = s:messletters.bubble_num(a:id, g:spacevim_buffer_index_type) . ' '
  endif
  let fn = fnamemodify(bufname(a:id), ':t')
  if g:spacevim_enable_tabline_ft_icon || get(g:, 'spacevim_enable_tabline_filetype_icon', 0)
    let icon = s:file.fticon(fn)
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
      let bufname = bufname(buflist[winnr - 1])
      " let bufname = bufname(tabpagebuflist(i)[tabpagewinnr(i) - 1])
      if s:SYS.isWindows
        let bufname = substitute(bufname, '\\[', '[', 'g')
        let bufname = substitute(bufname, '\\]', ']', 'g')
      endif
      let name = fnamemodify(bufname, ':t')
      let tabname = gettabvar(i, '_spacevim_tab_name', '')
      if has('tablineat')
        let t .=  '%' . index . '@SpaceVim#layers#core#tabline#jump@'
      elseif !has('nvim')
        let t .= '%' . index . 'T'
      endif
      if g:spacevim_buffer_index_type == 3
        let id = s:messletters.index_num(i)
      elseif g:spacevim_buffer_index_type == 4
        let id = i
      else
        let id = s:messletters.circled_num(i, g:spacevim_buffer_index_type)
      endif
      if empty(tabname)
        if empty(name)
          let name = 'No Name'
        endif
        call add(stack, buflist[winnr - 1])
        call s:need_show_bfname(stack, buflist[winnr - 1])
        if g:spacevim_enable_tabline_ft_icon || get(g:, 'spacevim_enable_tabline_filetype_icon', 0)
          let icon = s:file.fticon(name)
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
        let id = s:messletters.index_num(index(s:buffers, i) + 1)
      elseif g:spacevim_buffer_index_type == 4
        let id = index(s:buffers, i) + 1
      else
        let id = s:messletters.circled_num(index(s:buffers, i) + 1, g:spacevim_buffer_index_type)
      endif
      if g:spacevim_enable_tabline_ft_icon || get(g:, 'spacevim_enable_tabline_filetype_icon', 0)
        let icon = s:file.fticon(name)
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
  let [s:ilsep , s:irsep] = get(s:i_separators, g:spacevim_statusline_iseparator, s:separators['arrow'])
  set tabline=%!SpaceVim#layers#core#tabline#get()
  augroup SpaceVim_tabline
    autocmd!
    autocmd ColorScheme * call SpaceVim#layers#core#tabline#def_colors()
  augroup END
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
