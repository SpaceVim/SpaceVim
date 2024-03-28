
if exists('*nvim_create_namespace')
  let s:ns_id = nvim_create_namespace('bookmarks')
endif



function! bookmarks#vtext#add(file, lnum, text) abort
  if exists('*nvim_buf_set_extmark')
    return nvim_buf_set_extmark(bufnr(a:file), s:ns_id, a:lnum - 1, 0, {'virt_text' : [[a:text, 'Comment']]})
  endif
endfunction

function! bookmarks#vtext#delete(file, id) abort
  if exists('*nvim_buf_del_extmark')
    call nvim_buf_del_extmark(bufnr(a:file), s:ns_id, a:id)
  endif
endfunction

