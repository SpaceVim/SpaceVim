if exists('s:bookmarks')
  finish
endif


let s:FILE = SpaceVim#api#import('file')
let s:NT = SpaceVim#api#import('notify')


let s:bookmarks = bookmarks#cache#read()

function! bookmarks#toggle() abort
  let file = s:FILE.unify_path(expand('%'), ':p')
  let lnum = line('.')
  if has_key(s:bookmarks, file) && has_key(s:bookmarks[file], lnum)
    call bookmarks#delete(file, lnum)
  else
    call bookmarks#add(file, lnum, getline('.'))
  endif
endfunction

function! bookmarks#annotate() abort

  let annotation = input('Annotation:')

  if !empty(annotation)
    let file = s:FILE.unify_path(expand('%'), ':p')
    let lnum = line('.')
    call bookmarks#add(file, lnum, annotation)
  else
    call s:NT.notify('empty annotation, skipped!')
  endif
  
endfunction

function! bookmarks#get_all_bookmarks() abort
  return deepcopy(s:bookmarks)
endfunction


function! bookmarks#add(file, lnum, text, ...) abort
  if !has_key(s:bookmarks, a:file)
    let s:bookmarks[a:file] = {}
  endif
  let s:bookmarks[a:file][a:lnum] = {
        \ 'text' : a:text,
        \ 'file' : a:file,
        \ 'lnum' : a:lnum,
        \ 'signid' : bookmarks#sign#add(a:file, a:lnum)
        \ }
  call bookmarks#cache#write(s:bookmarks)
endfunction

function! bookmarks#delete(file, lnum) abort
  if has_key(s:bookmarks, a:file) && has_key(s:bookmarks[a:file], a:lnum)
    exe 'sign unplace ' . s:bookmarks[a:file][a:lnum].signid
    unlet s:bookmarks[a:file][a:lnum]
    call bookmarks#cache#write(s:bookmarks)
  endif
endfunction

function! s:jump_to_bookmark(bookmark) abort

  exe 'e ' . a:bookmark.file
  exe a:bookmark.lnum
  
endfunction

function! bookmarks#next() abort
  let file = s:FILE.unify_path(expand('%'), ':p')

  if has_key(s:bookmarks, file)
    for lnum in keys(s:bookmarks[file])
      if lnum > line('.')
        call s:jump_to_bookmark(s:bookmarks[file][lnum])
      endif
    endfor
  endif
  
endfunction

function! bookmarks#showall() abort
  let qf = []
  for [f, nrs] in items(s:bookmarks)
    for [nr, bm] in items(nrs)
      call add(qf, {
            \ 'filename' : f,
            \ 'lnum' : nr,
            \ 'text' : bm.text,
            \ })
    endfor
  endfor
  call setqflist([], 'r', {
        \ 'title' : 'Bookmarks',
        \ 'items' : qf,
        \ })
  botright copen
endfunction

function! bookmarks#on_enter_buffer() abort
  if get(b:, 'bookmarks_init', v:false) || empty(bufname()) || !empty(&buftype)
    return
  endif
  let file = s:FILE.unify_path(expand('%'), ':p')
  if has_key(s:bookmarks, file)
    for lnum in keys(s:bookmarks[file])
        let s:bookmarks[file][lnum].signid = bookmarks#sign#add(file, lnum)
    endfor
  endif

  let b:bookmarks_init = v:true
endfunction

function! bookmarks#clear() abort
  let file = s:FILE.unify_path(expand('%'), ':p')
  if has_key(s:bookmarks, file)
    for lnum in keys(s:bookmarks[file])
        call bookmarks#delete(file, lnum)
    endfor
  endif

endfunction
