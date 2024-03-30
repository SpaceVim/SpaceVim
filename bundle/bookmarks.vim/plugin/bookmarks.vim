""
" toggle bookmark of cursor position
command! BookmarkToggle call bookmarks#toggle()
""
" Add bookmark with annotation
command! BookmarkAnnotate call bookmarks#annotate()
""
" Jump to next bookmark in current buffer.
command! BookmarkNext call bookmarks#next()
""
" Jump to previous bookmark in current buffer.
command! BookmarkPrev call bookmarks#previous()
""
" clear all bookmarks in current buffer.
command! BookmarkClear call bookmarks#clear()
""
" show all bookmarks in quickfix windows.
command! BookmarkShowAll call bookmarks#showall()


augroup bookmarks
  autocmd!
  autocmd BufEnter * call bookmarks#on_enter_buffer()
  autocmd BufLeave,VimLeave * call bookmarks#on_leave_buffer()
augroup END
