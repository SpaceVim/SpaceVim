let s:autoload_roots = []
let s:last_root = ''
let s:last_file = ''

function! AddBookmarkRoot(root)
  call add(s:autoload_roots, a:root)
endfunction!

function! AutoloadBookmarks(file_name)
  let root_is_found = 0
  let found_root = 0
  let name_len = strlen(a:file_name)

  for root in s:autoload_roots
    let root_len = strlen(root)
    if (name_len > root_len && strpart(a:file_name, 0, root_len) == root)
      let root_is_found = 1
      let found_root = root
      break
    endif
  endfor

  if (root_is_found && found_root != s:last_root)
    let s:last_file = found_root . '/.bookmarks'
    let s:last_root = found_root
    call BookmarkLoad(s:last_file, 0, 1)

    augroup AutoSaveBookmarks
      autocmd!
      autocmd BufLeave * call s:remove_group()
    augroup END
  else
    let s:last_root = ''
  endif
endfunction

augroup AutoLoadBookmarks
  autocmd!
  autocmd BufEnter * call AutoloadBookmarks(expand("<afile>:p"))
augroup END

function! s:remove_group()
  call BookmarkSave(s:last_file, 1)
  augroup AutoSaveBookmarks
    autocmd!
  augroup END
endfunction
