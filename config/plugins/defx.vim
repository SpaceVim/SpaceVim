augroup vfinit
  au!
  autocmd FileType defx call s:defx_init()
  " auto close last defx windows
  " autocmd BufEnter * nested if (!has('vim_starting') && winnr('$') == 1 && &filetype ==# 'vimfiler') |
  " \ q | endif
augroup END

function! s:defx_init()
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

  nnoremap <silent><buffer> gr  :<C-u>Denite grep:<C-R>=<SID>selected()<CR> -buffer-name=grep<CR>
  nnoremap <silent><buffer> gf  :<C-u>Denite file_rec:<C-R>=<SID>selected()<CR><CR>
  nnoremap <silent><buffer> gd  :<C-u>call <SID>change_vim_current_dir()<CR>
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
  " Define mappings
  nnoremap <silent><buffer><expr> <CR>
        \ defx#do_action('call', 'Open_file_or_dir')
  nnoremap <silent><buffer><expr> c
        \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
        \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
        \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> l
        \ defx#do_action('open')
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
  nnoremap <silent><buffer><expr> h
        \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
        \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> <Space>
        \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
        \ defx#do_action('toggle_select_all')
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

function! Open_file_or_dir(content) abort
  close
  exe 'e' a:content.targets[0]
endfunction
