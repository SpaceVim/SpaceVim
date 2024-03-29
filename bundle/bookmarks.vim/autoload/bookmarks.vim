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

function! s:has_annotation(file, lnum) abort
  return has_key(s:bookmarks, a:file) 
        \ && has_key(s:bookmarks[a:file], a:lnum)
        \ && has_key(s:bookmarks[a:file][a:lnum], 'annotation')
        \ && !empty(s:bookmarks[a:file][a:lnum].annotation)
endfunction

function! bookmarks#annotate() abort

  let file = s:FILE.unify_path(expand('%'), ':p')
  let lnum = line('.')
  if s:has_annotation(file, lnum)
    let default_annotation = s:bookmarks[file][lnum].annotation
    let annotation = input({'prompt' : 'Annotation:', 'default' : default_annotation, 'cancelreturn' : ''})
    if !empty(annotation)
      call bookmarks#add(file, lnum, annotation, 1)
    else
      call s:NT.notify('canceled, no changes.')
    endif
  else
    let annotation = input('Annotation:')
    if !empty(annotation)
      call bookmarks#add(file, lnum, annotation, 1)
    else
      call s:NT.notify('empty annotation, skipped!')
    endif
  endif

endfunction

function! bookmarks#get_all_bookmarks() abort
  return deepcopy(s:bookmarks)
endfunction


function! bookmarks#add(file, lnum, text, ...) abort
  if !has_key(s:bookmarks, a:file)
    let s:bookmarks[a:file] = {}
  endif
  if has_key(s:bookmarks[a:file], a:lnum) && has_key(s:bookmarks[a:file][a:lnum], 'vtextid')
    call bookmarks#vtext#delete(a:file, s:bookmarks[a:file][a:lnum].vtextid)
  endif
  if has_key(s:bookmarks[a:file], a:lnum) && has_key(s:bookmarks[a:file][a:lnum], 'signid')
    exe 'sign unplace ' . s:bookmarks[a:file][a:lnum].signid
  endif
  let s:bookmarks[a:file][a:lnum] = {
        \ 'text' : a:text,
        \ 'file' : a:file,
        \ 'lnum' : a:lnum,
        \ 'signid' : bookmarks#sign#add(a:file, a:lnum)
        \ }
  if get(a:000, 0, 0)
    let s:bookmarks[a:file][a:lnum].vtextid = bookmarks#vtext#add(a:file, a:lnum, a:text)
    let s:bookmarks[a:file][a:lnum].annotation = a:text
  endif
  call bookmarks#cache#write(s:bookmarks)
endfunction

function! bookmarks#delete(file, lnum) abort
  if has_key(s:bookmarks, a:file) && has_key(s:bookmarks[a:file], a:lnum)
    exe 'sign unplace ' . s:bookmarks[a:file][a:lnum].signid
    if has_key(s:bookmarks[a:file][a:lnum], 'vtextid')
      call bookmarks#vtext#delete(a:file, s:bookmarks[a:file][a:lnum].vtextid)
    endif
    unlet s:bookmarks[a:file][a:lnum]
    if empty(s:bookmarks[a:file])
      unlet s:bookmarks[a:file]
    endif
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
      if has_key(s:bookmarks[file][lnum], 'annotation') && !empty(s:bookmarks[file][lnum].annotation)
        call bookmarks#vtext#add(file, lnum, s:bookmarks[file][lnum].annotation)
      endif
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
  call bookmarks#cache#write(s:bookmarks)
endfunction
