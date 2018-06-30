"=============================================================================
" tabmanager.vim --- tab manager for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8
" APIs
let s:BUFFER = SpaceVim#api#import('vim#buffer')
let s:TABs = SpaceVim#api#import('vim#tab')
let s:bufferid = -1
let s:bufname = '__TabManager__'

" init val

let s:open_tabs = []


" Interface
function! SpaceVim#plugins#tabmanager#open() abort
  if bufexists(s:bufferid)
    if index(tabpagebuflist(), s:bufferid) == -1
      let s:bufferid =  s:BUFFER.open(
            \ {
            \ 'bufname' : s:bufname,
            \ 'initfunc' : function('s:init_buffer'),
            \ }
            \ )
      call s:BUFFER.resize(30)
      call s:update_context()
    else
      let winnr = bufwinnr(bufname(s:bufferid))
      exe winnr .  'wincmd w'
    endif
  else
    let s:bufferid =  s:BUFFER.open(
          \ {
          \ 'bufname' : s:bufname,
          \ 'initfunc' : function('s:init_buffer'),
          \ }
          \ )
    call s:BUFFER.resize(30)
    call s:update_context()
  endif

endfunction

" local functions
function! s:init_buffer() abort
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nomodifiable nospell number norelativenumber
  setf SpaceVimTabsManager
  nnoremap <silent> <buffer> q :bd<CR>
  nnoremap <silent> <buffer> <CR> <esc>:<c-u>cal <SID>jump()<CR>
  nnoremap <silent> <buffer> o :call <SID>toggle()<CR>
  nnoremap <silent> <buffer> r :call <SID>rename_tab()<CR>
  nnoremap <silent> <buffer> n :call <SID>create_new_named_tab()<CR>
  nnoremap <silent> <buffer> N :call <SID>create_new_unnamed_tab()<CR>
  nnoremap <silent> <buffer> x :call <SID>delete_tab()<CR>
  nnoremap <silent> <buffer> yy :call <SID>copy_tab()<CR>
  nnoremap <silent> <buffer> p :call <SID>paste_tab()<CR>
  nnoremap <silent> <buffer> <C-S-Up> :call <SID>move_tab_backward()<CR>
  nnoremap <silent> <buffer> <C-S-Down> :call <SID>move_tab_forward()<CR>

endfunction

function! s:update_context() abort
  setl modifiable
  normal! gg"_dG
  let tree = s:TABs.get_tree()
  let ctx = []
  for page in sort(keys(tree), 'N')
    if index(s:open_tabs, page) != -1
      call add(ctx,
            \ '▼ ' . (page == tabpagenr() ? '*' : ' ')
            \ . 'Tab ' . page 
            \ . ' ' . gettabvar(page, '_spacevim_tab_name', '')
            \ )
      for _buf in tree[page]
        if getbufvar(_buf, '&buflisted')
          call add(ctx, '    ' . _buf . ':' . fnamemodify(empty(bufname(_buf))? 'No Name' : bufname(_buf), ':t'))
        endif
      endfor
    else
      call add(ctx,
            \ '▷ ' . (page == tabpagenr() ? '*' : ' ')
            \ . 'Tab ' . page 
            \ . ' ' . gettabvar(page, '_spacevim_tab_name', '')
            \ )
    endif
  endfor
  call setline(1, ctx)
  setl nomodifiable
endfunction

function! s:jump() abort
  if v:prevcount
    exe 'keepj' v:prevcount
  en
  let t = s:tabid()
  let b = s:bufid()
  q
  call s:TABs._jump(t,b)
endfunction

function! s:tabid() abort
  let line = line('.')
  if getline('.') =~# '^[▷▼] [ *]Tab '
    let tabid = matchstr(getline(line), '\d\+')
  else
    let line = search('^[▷▼] [ *]Tab ','bWnc')
    let tabid = matchstr(getline(line), '\d\+')
  endif
  return tabid
endfunction

function! s:bufid() abort
  let id = str2nr(split(getline('.'), ':')[0])
  return id
endfunction

function! s:toggle() abort
  let line = line('.')
  if getline('.') =~# '^[▷▼] [ *]Tab '
    let tabid = matchstr(getline(line), '\d\+')
    if index(s:open_tabs, tabid) != -1
      call remove(s:open_tabs, index(s:open_tabs, tabid))
    else
      call add(s:open_tabs, tabid)
    endif
  endif
  call s:update_context()
  exe line
endfunction

function! s:rename_tab() abort
  let tabid = s:get_cursor_tabnr()
  let line = search('^[▷▼] [ *]Tab ' . (tabid),'wc')
  let tabname = input('Tab name:', '')
  if !empty(tabname)
    call settabvar(tabid, '_spacevim_tab_name', tabname)
    set tabline=%!SpaceVim#layers#core#tabline#get()
  endif
  call s:update_context()
  exe line
endfunction

function! s:create_new_named_tab() abort
  let tabid = s:get_cursor_tabnr()
  let current_tab = tabpagenr()
  let tabname = input('Tab name:', '')
  if !empty(tabname)
    exe tabid . 'tabnew'
    let t:_spacevim_tab_name = tabname
    set tabline=%!SpaceVim#layers#core#tabline#get()
  else
    exe tabid . 'tabnew'
  endif
  if tabid >= current_tab
    exe 'tabnext ' . current_tab
  else
    exe 'tabnext ' . (current_tab + 1)
  endif
  call s:update_context()
  let line = search('^[▷▼] [ *]Tab ' . (tabid + 1),'wc')
  exe line
endfunction

function! s:create_new_unnamed_tab() abort
  let tabid = s:get_cursor_tabnr()
  let current_tab = tabpagenr()
  exe tabid . 'tabnew'
  if tabid >= current_tab
    exe 'tabnext ' . current_tab
  else
    exe 'tabnext ' . (current_tab + 1)
  endif
  call s:update_context()
  let line = search('^[▷▼] [ *]Tab ' . (tabid + 1),'wc')
  exe line
endfunction

function! s:delete_tab() abort
  let line = line('.')
  if getline('.') =~# '^[▷▼] [ *]Tab '
    let tabid = matchstr(getline(line), '\d\+')
    if tabid ==# tabpagenr()
      call s:close_tab(tabid)
    else
      call s:close_tab(tabid)
      call s:update_context()
    endif
    set tabline=%!SpaceVim#layers#core#tabline#get()
  endif
  exe line
endfunction

function! s:close_tab(nr) abort
  if tabpagenr('$') == 1
    echohl WarningMsg
    echon 'can not close the last tab'
    echohl NONE
  else
    exe 'tabclose' a:nr
  endif
endfunction


" 1. switch to the tab under cursor
" 2. make session of current tab
" 3. switch to previous tab
function! s:copy_tab() abort
  let current_tab = tabpagenr()
  let cursor_tab = s:get_cursor_tabnr()
  exe 'tabnext ' . cursor_tab
  let save_sessionopts = &sessionoptions
  let tabsession = '~/.cache/SpaceVim/tabmanager_session.vim'
  let &sessionoptions = 'winsize'
  exe 'mksession! ' . tabsession
  exe 'tabnext ' . current_tab
endfunction

function! s:get_cursor_tabnr() abort
  let line = line('.')
  if getline('.') =~# '^[▷▼] [ *]Tab '
    let tabid = matchstr(getline(line), '\d\+')
  else
    let line = search('^[▷▼] [ *]Tab ','bWnc')
    let tabid = matchstr(getline(line), '\d\+')
  endif
  return tabid
endfunction


function! s:paste_tab() abort
  let t = s:tabid()
  let b = s:bufid()
  let cursor_tab = s:get_cursor_tabnr()
  exe 'tabnew ' . cursor_tab
  exe 'so ~/.cache/SpaceVim/tabmanager_session.vim' 
  if index(s:open_tabs, t) != -1
    call add(s:open_tabs, tabpagenr())
  endif
  call s:TABs._jump(t,b)
  call s:update_context()
endfunction


function! s:move_tab_backward() abort
  let tabid = s:get_cursor_tabnr()
  if tabid == 1
    return
  endif
  let ct = tabpagenr()
  exe tabid . 'tabdo tabmove -'
  if ct == tabid
    call s:update_context()
  endif
  let line = search('^[▷▼] [ *]Tab ' . (tabid - 1),'wc')
  exe line
endfunction


function! s:move_tab_forward() abort
  let tabid = s:get_cursor_tabnr()
  if tabid == tabpagenr('$')
    return
  endif
  let ct = tabpagenr()
  exe tabid . 'tabdo tabmove +'
  if ct == tabid
    call s:update_context()
  endif
  let line = search('^[▷▼] [ *]Tab ' . (tabid + 1),'wc')
  exe line
endfunction
