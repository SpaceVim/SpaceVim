"
" Note:
"   Original 'exrename.vim' has been moved into 'unite.vim'
"   This 'exrename.vim' exists for backward-compatibility
"
function! s:post_rename_callback(exrename) abort
  call vimfiler#force_redraw_all_vimfiler()
endfunction

function! vimfiler#exrename#create_buffer(files) " {{{
  let buffer_name = b:vimfiler.context.buffer_name
  let options = {
        \ 'buffer_name': buffer_name,
        \ 'post_rename_callback': function('s:post_rename_callback'),
        \}
  call unite#exrename#create_buffer(a:files, options)
endfunction " }}}
" vim: foldmethod=marker
