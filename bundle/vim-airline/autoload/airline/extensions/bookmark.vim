" MIT License. Copyright (c) 2019 Bjoern Petri <bjoern.petri@sundevil.de>
" Plugin: https://github.com/MattesGroeger/vim-bookmarks
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists(':BookmarkToggle')
  finish
endif

function! airline#extensions#bookmark#currentbookmark()
  if get(w:, 'airline_active', 0)
	let file = expand("%:p")
	if file ==# ""
		return
	endif

	let current_line = line('.')
	let has_bm = bm#has_bookmark_at_line(file, current_line)
	let bm = has_bm ? bm#get_bookmark_by_line(file, current_line) : 0
	let annotation = has_bm ? bm['annotation'] : ""

	return annotation
	endif
  return ''
endfunction

function! airline#extensions#bookmark#init(ext)
  call airline#parts#define_function('bookmark', 'airline#extensions#bookmark#currentbookmark')
endfunction
