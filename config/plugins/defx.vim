"=============================================================================
" defx.vim --- defx configuration
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8


let s:SYS = SpaceVim#api#import('system')
let s:FILE = SpaceVim#api#import('file')
let s:VCOP = SpaceVim#api#import('vim#compatible')

if g:spacevim_filetree_direction ==# 'right'
  let s:direction = 'rightbelow'
else
  let s:direction = 'leftabove'
endif

function! s:setcolum() abort
  if g:_spacevim_enable_filetree_filetypeicon && !g:_spacevim_enable_filetree_gitstatus
    return 'indent:icons:filename:type'
  elseif !g:_spacevim_enable_filetree_filetypeicon && g:_spacevim_enable_filetree_gitstatus
    return 'indent:git:filename:type'
  elseif g:_spacevim_enable_filetree_filetypeicon && g:_spacevim_enable_filetree_gitstatus
    return 'indent:git:icons:filename:type'
  else
    return 'mark:indent:icon:filename:type'
  endif
endfunction

call defx#custom#option('_', {
      \ 'columns': s:setcolum(),
      \ 'winwidth': g:spacevim_sidebar_width,
      \ 'split': 'vertical',
      \ 'direction': s:direction,
      \ 'show_ignored_files': g:_spacevim_filetree_show_hidden_files,
      \ 'buffer_name': '',
      \ 'toggle': 1,
      \ 'resume': 1
      \ })

call defx#custom#column('mark', {
      \ 'readonly_icon': '',
      \ 'selected_icon': '',
      \ })

call defx#custom#column('icon', {
      \ 'directory_icon': '▶',
      \ 'opened_icon': '▼',
      \ 'root_icon': ' ',
      \ })

call defx#custom#column('filename', {
      \ 'max_width': -90,
      \ })

augroup vfinit
  au!
  autocmd FileType defx call s:defx_init()
  " auto close last defx windows
  autocmd BufEnter * nested if
        \ (!has('vim_starting') && s:win_count() == 1  && g:_spacevim_autoclose_filetree
        \ && &filetype ==# 'defx') |
        \ call s:close_last_vimfiler_windows() | endif
augroup END

function! s:win_count() abort
  if has('nvim') && exists('*nvim_win_get_config')
    return len(filter(range(1, winnr('$')), '!has_key(nvim_win_get_config(win_getid(v:val)), "col")'))
  elseif exists('*popup_getoptions')
    return len(filter(range(1, winnr('$')), '!has_key(popup_getoptions(win_getid(v:val)), "col")'))
  else
    return winnr('$')
  endif
endfunction

" in this function, we should check if shell terminal still exists,
" then close the terminal job before close vimfiler
function! s:close_last_vimfiler_windows() abort
  call SpaceVim#layers#shell#close_terminal()
  q
endfunction

function! s:defx_init()
  setl nonumber
  setl norelativenumber
  setl listchars=
  setl nofoldenable
  setl foldmethod=manual

  " disable this mappings
  nnoremap <silent><buffer> <3-LeftMouse> <Nop>
  nnoremap <silent><buffer> <4-LeftMouse> <Nop>
  nnoremap <silent><buffer> <LeftMouse> <LeftMouse><Home>

  silent! nunmap <buffer> <Space>
  silent! nunmap <buffer> <C-l>
  silent! nunmap <buffer> <C-j>
  silent! nunmap <buffer> E
  silent! nunmap <buffer> gr
  silent! nunmap <buffer> gf
  silent! nunmap <buffer> -
  silent! nunmap <buffer> s

  " nnoremap <silent><buffer><expr> st  vimfiler#do_action('tabswitch')
  " nnoremap <silent><buffer> yY  :<C-u>call <SID>copy_to_system_clipboard()<CR>
  nnoremap <silent><buffer><expr> '
        \ defx#do_action('toggle_select') . 'j'
  " TODO: we need an action to clear all selections
  nnoremap <silent><buffer><expr> V
        \ defx#do_action('toggle_select_all')
  " nmap <buffer> v       <Plug>(vimfiler_quick_look)
  " nmap <buffer> p       <Plug>(vimfiler_preview_file)
  " nmap <buffer> i       <Plug>(vimfiler_switch_to_history_directory)

  " Define mappings
  nnoremap <silent><buffer><expr> gx
        \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> c
        \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> q
        \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> m
        \ defx#do_action('move')
  nnoremap <silent><buffer><expr> P
        \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> h defx#do_action('call', g:defx_config_sid . 'DefxSmartH')
  nnoremap <silent><buffer><expr> <Left> defx#do_action('call', g:defx_config_sid . 'DefxSmartH')
  nnoremap <silent><buffer><expr> l defx#do_action('call', g:defx_config_sid . 'DefxSmartL')
  nnoremap <silent><buffer><expr> <Right> defx#do_action('call', g:defx_config_sid . 'DefxSmartL')
  nnoremap <silent><buffer><expr> o defx#do_action('call', g:defx_config_sid . 'DefxSmartL')
  nnoremap <silent><buffer><expr> <Cr>
        \ defx#is_directory() ?
        \ defx#do_action('open_directory') : defx#do_action('drop')
  nnoremap <silent><buffer><expr> <2-LeftMouse>
        \ defx#is_directory() ? 
        \     (
        \     defx#is_opened_tree() ?
        \     defx#do_action('close_tree') :
        \     defx#do_action('open_tree')
        \     )
        \ : defx#do_action('drop')
  nnoremap <silent><buffer><expr> sg
        \ defx#do_action('drop', 'vsplit')
  nnoremap <silent><buffer><expr> sv
        \ defx#do_action('drop', 'split')
  nnoremap <silent><buffer><expr> st
        \ defx#do_action('drop', 'tabedit')
  nnoremap <silent><buffer><expr> p
        \ defx#do_action('open', 'pedit')
  nnoremap <silent><buffer><expr> K
        \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N
        \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> d
        \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
        \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> yy defx#do_action('call', g:defx_config_sid . 'DefxYarkPath')
  nnoremap <silent><buffer><expr> yY defx#do_action('call', g:defx_config_sid . 'DefxCopyFile')
  nnoremap <silent><buffer><expr> P defx#do_action('call', g:defx_config_sid . 'DefxPasteFile')
  nnoremap <silent><buffer><expr> .
        \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> <C-f>
        \ defx#do_action('change_filtered_files')
  nnoremap <silent><buffer><expr> ~
        \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> j
        \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
        \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-r>
        \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>
        \ defx#do_action('print')
  nnoremap <silent><buffer> <Home> :call cursor(2, 1)<cr>
  nnoremap <silent><buffer> <End>  :call cursor(line('$'), 1)<cr>
  nnoremap <silent><buffer><expr> <C-Home>
        \ defx#do_action('cd', SpaceVim#plugins#projectmanager#current_root())
  nnoremap <silent><buffer><expr> > defx#do_action('resize',
        \ defx#get_context().winwidth + 10)
  nnoremap <silent><buffer><expr> < defx#do_action('resize',
        \ defx#get_context().winwidth - 10)
endf

" in this function we should vim-choosewin if possible
function! s:DefxSmartL(_)
  if defx#is_directory()
    call defx#call_action('open_tree')
    normal! j
  else
    let filepath = defx#get_candidate()['action__path']
    if tabpagewinnr(tabpagenr(), '$') >= 3    " if there are more than 2 normal windows
      if exists(':ChooseWin') == 2
        ChooseWin
      else
        let input = input('ChooseWin No./Cancel(n): ')
        if input ==# 'n' | return | endif
        if input == winnr() | return | endif
        exec input . 'wincmd w'
      endif
      exec 'e' filepath
    else
      exec 'wincmd w'
      exec 'e' filepath
    endif
  endif
endfunction

function! s:DefxSmartH(_)
  " if cursor line is first line, or in empty dir
  if line('.') ==# 1 || line('$') ==# 1
    return defx#call_action('cd', ['..'])
  endif

  " candidate is opend tree?
  if defx#is_opened_tree()
    return defx#call_action('close_tree')
  endif

  " parent is root?
  let s:candidate = defx#get_candidate()
  let s:parent = fnamemodify(s:candidate['action__path'], s:candidate['is_directory'] ? ':p:h:h' : ':p:h')
  let sep = s:SYS.isWindows ? '\\' :  '/'
  if s:trim_right(s:parent, sep) == s:trim_right(b:defx.paths[0], sep)
    return defx#call_action('cd', ['..'])
  endif

  " move to parent.
  call defx#call_action('search', s:parent)

  " if you want close_tree immediately, enable below line.
  call defx#call_action('close_tree')
endfunction

function! s:DefxYarkPath(_) abort
  let candidate = defx#get_candidate()
  let @+ = candidate['action__path']
  echo 'yanked path: ' . @+
endfunction


let s:copyed_file_path = ''

function! s:DefxCopyFile(_) abort
  if !executable('xclip-copyfile') &&  !s:SYS.isWindows
    echohl WarningMsg
    echo 'you need to have xclip-copyfile in your PATH'
    echohl NONE
    return
  endif
  let candidate = defx#get_candidate()
  let filename = candidate['action__path']

  if executable('xclip-copyfile')
    call s:VCOP.systemlist(['xclip-copyfile', filename])
    if v:shell_error
      echohl WarningMsg
      echo 'failed to copy file!'
      echohl NONE
    else
      echo 'Yanked:' . filename
    endif
  elseif s:SYS.isWindows
    let s:copyed_file_path = filename
    echo 'Yanked:' . filename
  endif
endfunction

function! s:DefxPasteFile(_) abort
  if !executable('xclip-pastefile') && !s:SYS.isWindows
    echohl WarningMsg
    echo 'you need to have xclip-copyfile in your PATH'
    echohl NONE
    return
  endif
  let candidate = defx#get_candidate()
  let path = candidate['action__path']
  if !isdirectory(path)
    let path = fnamemodify(path, ':p:h')
  endif

  " If you have xclip-pastefile in your PATH.
  " this command will be run on action directory
  " support paste file which is copied outside of vim.
  if executable('xclip-pastefile')
    let old_wd = getcwd()
    if old_wd == path
      call s:VCOP.systemlist(['xclip-pastefile'])
    else
      noautocmd exe 'cd' fnameescape(path)
      call s:VCOP.systemlist(['xclip-pastefile'])
      noautocmd exe 'cd' fnameescape(old_wd)
    endif
    return
  endif

  if s:SYS.isWindows && !empty(s:copyed_file_path)
    " in windows, use copy command for paste file.
    let destination = path . s:FILE.separator . fnamemodify(s:copyed_file_path, ':t')
    let cmd = 'cmd /c copy ' . shellescape(s:copyed_file_path) . ' ' . shellescape(destination)
    call s:VCOP.systemlist(cmd)
  elseif !s:SYS.isWindows && !empty(s:copyed_file_path)
    " in Linux or MacOS, use cp command for paste file.
    let destination = path . s:FILE.separator . fnamemodify(s:copyed_file_path, ':t')
    let cmd = 'cp -r ' . shellescape(s:copyed_file_path) . ' ' . shellescape(destination)
    call s:VCOP.systemlist(cmd)
  endif
  if v:shell_error
    echohl WarningMsg
    echo 'failed to paste file!'
    echohl NONE
  else
    echo 'Pasted:' . destination
  endif
endfunction

function! s:trim_right(str, trim)
  return substitute(a:str, printf('%s$', a:trim), '', 'g')
endfunction

function! s:SID_PREFIX() abort
  return matchstr(expand('<sfile>'),
        \ '<SNR>\d\+_\zeSID_PREFIX$')
endfunction
let g:defx_config_sid = s:SID_PREFIX()
