scriptencoding utf-8

let s:VCOP = SpaceVim#api#import('vim#compatible')

let g:vimfiler_as_default_explorer = get(g:, 'vimfiler_as_default_explorer', 1)
let g:vimfiler_restore_alternate_file = get(g:, 'vimfiler_restore_alternate_file', 1)
let g:vimfiler_tree_indentation = get(g:, 'vimfiler_tree_indentation', 1)
let g:vimfiler_tree_leaf_icon = get(g:, 'vimfiler_tree_leaf_icon', '')
let g:vimfiler_tree_opened_icon = get(g:, 'vimfiler_tree_opened_icon', '')
let g:vimfiler_tree_closed_icon = get(g:, 'vimfiler_tree_closed_icon', '')
let g:vimfiler_file_icon = get(g:, 'vimfiler_file_icon', '')
let g:vimfiler_readonly_file_icon = get(g:, 'vimfiler_readonly_file_icon', '*')
let g:vimfiler_marked_file_icon = get(g:, 'vimfiler_marked_file_icon', '√')
if g:spacevim_filetree_direction ==# 'right'
  let g:vimfiler_direction = get(g:, 'vimfiler_direction', 'rightbelow')
else
  let g:vimfiler_direction = 'leftabove'
endif
"let g:vimfiler_preview_action = 'auto_preview'
let g:vimfiler_ignore_pattern = get(g:, 'vimfiler_ignore_pattern', [
      \ '^\.git$',
      \ '^\.DS_Store$',
      \ '^\.init\.vim-rplugin\~$',
      \ '^\.netrwhist$',
      \ '\.class$',
      \ '^\.'
      \])

if has('mac') 
  let g:vimfiler_quick_look_command = 
        \ get(g:, 'vimfiler_quick_look_command', 'qlmanage -p') 
else 
  let g:vimfiler_quick_look_command = 
        \ get(g:, 'vimfiler_quick_look_command', 'gloobus-preview') 
endif

function! s:setcolum() abort
  if g:spacevim_enable_vimfiler_filetypeicon && !g:spacevim_enable_vimfiler_gitstatus
    return 'filetypeicon'
  elseif !g:spacevim_enable_vimfiler_filetypeicon && g:spacevim_enable_vimfiler_gitstatus
    return 'gitstatus'
  elseif g:spacevim_enable_vimfiler_filetypeicon && g:spacevim_enable_vimfiler_gitstatus
    return 'filetypeicon:gitstatus'
  else
    return ''
  endif
endfunction
"try
call vimfiler#custom#profile('default', 'context', {
      \ 'explorer' : 1,
      \ 'winwidth' : g:spacevim_sidebar_width,
      \ 'winminwidth' : 30,
      \ 'toggle' : 1,
      \ 'auto_expand': 1,
      \ 'direction' : g:vimfiler_direction,
      \ 'explorer_columns' : s:setcolum(),
      \ 'parent': 0,
      \ 'status' : 1,
      \ 'safe' : 0,
      \ 'split' : 1,
      \ 'hidden': g:_spacevim_filetree_show_hidden_files,
      \ 'no_quit' : 1,
      \ 'force_hide' : 0,
      \ })

"catch
"endtry
augroup vfinit
  au!
  autocmd FileType vimfiler call s:vimfilerinit()
  autocmd BufEnter * nested if (!has('vim_starting') && winnr('$') == 1 && &filetype ==# 'vimfiler'   && g:_spacevim_autoclose_filetree) |
        \ call s:close_last_vimfiler_windows() | endif
augroup END

" in this function, we should check if shell terminal still exists,
" then close the terminal job before close vimfiler
function! s:close_last_vimfiler_windows() abort
  call SpaceVim#layers#shell#close_terminal()
  q
endfunction

function! s:vimfilerinit()
  setl nonumber
  setl norelativenumber

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
  nmap <buffer> gx      <Plug>(vimfiler_execute_vimfiler_associated)
  nmap <buffer> '       <Plug>(vimfiler_toggle_mark_current_line)
  nmap <buffer> v       <Plug>(vimfiler_quick_look)
  nmap <buffer> p       <Plug>(vimfiler_preview_file)
  nmap <buffer> V       <Plug>(vimfiler_clear_mark_all_lines)
  nmap <buffer> i       <Plug>(vimfiler_switch_to_history_directory)
  nmap <buffer> <Tab>   <Plug>(vimfiler_switch_to_other_window)
  nmap <buffer> <C-r>   <Plug>(vimfiler_redraw_screen)
  nmap <buffer> <Left>  <Plug>(vimfiler_smart_h)
  nmap <buffer> <Right> <Plug>(vimfiler_smart_l)
  nmap <buffer> <2-LeftMouse> <Plug>(vimfiler_expand_or_edit)
endf

function! s:vimfiler_vsplit() abort
  let path = vimfiler#get_filename()
  if !isdirectory(path)
    wincmd w
    exe 'vsplit' path
  else
    echohl ModeMsg
    echo path . ' is a directory!'
    echohl NONE
  endif
endfunction
function! s:vimfiler_split() abort
  let path = vimfiler#get_filename()
  if !isdirectory(path)
    wincmd w
    exe 'split' path
  else
    echohl ModeMsg
    echo path . ' is a directory!'
    echohl NONE
  endif
endfunction

function! s:paste_to_file_manager() abort
  let path = vimfiler#get_filename()
  if !isdirectory(path)
    let path = fnamemodify(path, ':p:h')
  endif
  let old_wd = getcwd()
  if old_wd == path
    call s:VCOP.systemlist(['xclip-pastefile'])
  else
    noautocmd exe 'cd' fnameescape(path)
    call s:VCOP.systemlist(['xclip-pastefile'])
    noautocmd exe 'cd' fnameescape(old_wd)
  endif
endfunction

function! s:copy_to_system_clipboard() abort
  let filename = vimfiler#get_marked_filenames(b:vimfiler)

  if empty(filename)
    " Use cursor filename.
    let filename = vimfiler#get_filename()
    if filename ==# '..' || empty(vimfiler#get_file(b:vimfiler))
      let filename = b:vimfiler.current_dir
    else
      let filename = vimfiler#get_file(b:vimfiler).action__path
    endif
    call s:VCOP.systemlist(['xclip-copyfile', filename])
  else
    call s:VCOP.systemlist(['xclip-copyfile'] + filename)
  endif
  echo 'Yanked:' . (type(filename) == 3 ? len(filename) : 1 ) . ' files'
endfunction

" vim:set et sw=2:
