"=============================================================================
" defx.vim --- defx config
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" defx supported is added in https://github.com/SpaceVim/SpaceVim/pull/2282

let s:SYS = SpaceVim#api#import('system')

call defx#custom#option('_', {
      \ 'winwidth': g:spacevim_sidebar_width,
      \ 'split': 'vertical',
      \ 'direction': 'botright',
      \ 'show_ignored_files': 0,
      \ 'buffer_name': '',
      \ 'toggle': 1,
      \ 'resume': 1
      \ })

call defx#custom#column('mark', {
      \ 'readonly_icon': '',
      \ 'selected_icon': '',
      \ })

call defx#custom#column('filename', {
      \ 'directory_icon': '',
      \ 'opened_icon': '',
      \ })

augroup vfinit
  au!
  autocmd FileType defx call s:defx_init()
  " auto close last defx windows
  " autocmd BufEnter * nested if (!has('vim_starting')
  " \ && winnr('$') == 1 && &filetype ==# 'vimfiler') |
  " \ q | endif
augroup END

function! s:defx_init()
  setl nonumber
  setl norelativenumber
  setl listchars=

  silent! nunmap <buffer> <Space>
  silent! nunmap <buffer> <C-l>
  silent! nunmap <buffer> <C-j>
  silent! nunmap <buffer> E
  silent! nunmap <buffer> gr
  silent! nunmap <buffer> gf
  silent! nunmap <buffer> -
  silent! nunmap <buffer> s

  nnoremap <silent><buffer> sg  :<C-u>call <SID>vimfiler_vsplit()<CR>
  nnoremap <silent><buffer> sv  :<C-u>call <SID>vimfiler_split()<CR>
  nnoremap <silent><buffer><expr> st  vimfiler#do_action('tabswitch')
  nnoremap <silent><buffer> yY  :<C-u>call <SID>copy_to_system_clipboard()<CR>
  nnoremap <silent><buffer> P  :<C-u>call <SID>paste_to_file_manager()<CR>
  nnoremap <silent><buffer><expr> '
        \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> V
        \ defx#do_action('toggle_select_all')
  nmap <buffer> v       <Plug>(vimfiler_quick_look)
  nmap <buffer> p       <Plug>(vimfiler_preview_file)
  nmap <buffer> i       <Plug>(vimfiler_switch_to_history_directory)
  nmap <buffer> <Tab>   <Plug>(vimfiler_switch_to_other_window)
  nmap <buffer> <C-r>   <Plug>(vimfiler_redraw_screen)
  nmap <buffer> <Left>  <Plug>(vimfiler_smart_h)
  nmap <buffer> <Right> <Plug>(vimfiler_smart_l)

  " Define mappings
  nnoremap <silent><buffer><expr> gx
        \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy
        \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> q
        \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> m
        \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
        \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> h defx#do_action('call', 'DefxSmartH')
  nnoremap <silent><buffer><expr> <Left> defx#do_action('call', 'DefxSmartH')
  nnoremap <silent><buffer><expr> l
        \ defx#is_directory() ?
        \ defx#do_action('open_tree') . 'j' : defx#do_action('open')
  nnoremap <silent><buffer><expr> <Right>
        \ defx#is_directory() ?
        \ defx#do_action('open_tree') . 'j' : defx#do_action('open')
  nnoremap <silent><buffer><expr> <Cr>
        \ defx#is_directory() ?
        \ defx#do_action('open_directory') : defx#do_action('drop')
  nnoremap <silent><buffer><expr> <2-LeftMouse>
        \ defx#is_directory() ?
        \ defx#do_action('open_tree') : defx#do_action('drop')
  nnoremap <silent><buffer><expr> E
        \ defx#do_action('open', 'vsplit')
  nnoremap <silent><buffer><expr> P
        \ defx#do_action('open', 'pedit')
  nnoremap <silent><buffer><expr> K
        \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N
        \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> d
        \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
        \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> x
        \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy
        \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> .
        \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> ~
        \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> j
        \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
        \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-l>
        \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>
        \ defx#do_action('print')
  nnoremap <silent><buffer><expr> cd
        \ defx#do_action('change_vim_cwd')
endf

function! DefxSmartH(_)
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

function! s:trim_right(str, trim)
  return substitute(a:str, printf('%s$', a:trim), '', 'g')
endfunction
