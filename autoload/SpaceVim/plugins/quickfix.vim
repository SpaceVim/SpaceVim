let s:qflist = []

" Create or replace or add to the quickfix list using the items
" in {list}.  Each item in {list} is a dictionary.
" Non-dictionary items in {list} are ignored.  Each dictionary
" item can contain the following entries:
"
" bufnr	buffer number; must be the number of a valid
" buffer
" filename	name of a file; only used when "bufnr" is not
" present or it is invalid.
" lnum	line number in the file
" pattern	search pattern used to locate the error
" col		column number
" vcol	when non-zero: "col" is visual column
" when zero: "col" is byte index
" nr		error number
" text	description of the error
" type	single-character error type, 'E', 'W', etc.
"
" The "col", "vcol", "nr", "type" and "text" entries are
" optional.  Either "lnum" or "pattern" entry can be used to
" locate a matching error line.
" If the "filename" and "bufnr" entries are not present or
" neither the "lnum" or "pattern" entries are present, then the
" item will not be handled as an error line.
" If both "pattern" and "lnum" are present then "pattern" will
" be used.
" If you supply an empty {list}, the quickfix list will be
" cleared.
" Note that the list is not exactly the same as what
" |getqflist()| returns.
"
" *E927*
" If {action} is set to 'a', then the items from {list} are
" added to the existing quickfix list. If there is no existing
" list, then a new list is created.
"
" If {action} is set to 'r', then the items from the current
" quickfix list are replaced with the items from {list}.  This
" can also be used to clear the list: >
" :call setqflist([], 'r')
" <
" If {action} is not present or is set to ' ', then a new list
" is created.
"
" If {title} is given, it will be used to set |w:quickfix_title|
" after opening the quickfix window.
"
" If the optional {what} dictionary argument is supplied, then
" only the items listed in {what} are set. The first {list}
" argument is ignored.  The following items can be specified in
" {what}:
" nr		list number in the quickfix stack
" title	quickfix list title text
" Unsupported keys in {what} are ignored.
" If the "nr" item is not present, then the current quickfix list
" is modified.
"
" Examples: >
" :call setqflist([], 'r', {'title': 'My search'})
" :call setqflist([], 'r', {'nr': 2, 'title': 'Errors'})
" <
" Returns zero for success, -1 for failure.
"
" This function can be used to create a quickfix list
" independent of the 'errorformat' setting.  Use a command like
":cc 1" to jump to the first position.

function! SpaceVim#plugins#quickfix#setqflist(list, ...)

endfunction


function! SpaceVim#plugins#quickfix#getqflist()

  return s:qflist

endfunction


function! SpaceVim#plugins#quickfix#next()



endfunction


function! SpaceVim#plugins#quickfix#pre()



endfunction


function! SpaceVim#plugins#quickfix#enter()



endfunction

let s:BUFFER = SpaceVim#api#import('vim#buffer')
function! SpaceVim#plugins#quickfix#openwin()
  call s:BUFFER.open({
        \ 'bufname' : '__quickfix__',
        \ 'cmd' : 'setl buftype=nofile bufhidden=wipe filetype=SpaceVimQuickFix nomodifiable',
        \ 'mode' : 'rightbelow split ',
        \ })
  call s:BUFFER.resize(10, '')

endfunction
