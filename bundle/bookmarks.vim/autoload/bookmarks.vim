if exists('s:bookmarks')
  finish
endif


let s:FILE = SpaceVim#api#import('file')
let s:NT = SpaceVim#api#import('notify')
let s:BUF = SpaceVim#api#import('vim#buffer')


let s:bookmarks = bookmarks#cache#read()

function! s:skip_current_buf() abort
  if empty(s:BUF.bufname())
    return v:true
  elseif !empty(&buftype)
    return v:true
  endif
endfunction

function! bookmarks#on_leave_buffer() abort
  if s:skip_current_buf()
    return
  endif

  let file = s:FILE.unify_path(expand('%'), ':p')

  if has_key(s:bookmarks, file)
    let sign_lnum_map = bookmarks#sign#get_lnums(s:BUF.bufnr())
    let new_file_bms = {}
    for lnum in keys(s:bookmarks[file])
      let signid = s:bookmarks[file][lnum].signid
      if has_key(sign_lnum_map, signid)
        let new_lnum = sign_lnum_map[signid]
        let new_file_bms[new_lnum] = s:bookmarks[file][lnum]
        let new_file_bms[new_lnum].lnum = new_lnum
      else
        " the signid does not exist, maybe that line has been removed
        if has_key(s:bookmarks[file][lnum], 'vtextid')
          call bookmarks#vtext#delete(file, s:bookmarks[file][lnum].vtextid)
        endif
      endif
    endfor
    let s:bookmarks[file] = new_file_bms
    call bookmarks#cache#write(s:bookmarks)
  endif
endfunction

function! bookmarks#toggle() abort
  if s:skip_current_buf()
    return
  endif
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
  if s:skip_current_buf()
    return
  endif
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
  call bookmarks#logger#info('add bookmarks:')
  call bookmarks#logger#info('         file:' .. a:file)
  call bookmarks#logger#info('         lnum:' .. a:lnum)
  call bookmarks#logger#info('         text:' .. a:text)
  call bookmarks#logger#info('        a:000:' .. string(a:000))
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
  let file = s:FILE.unify_path(expand('%'), ':p')

  if file !=# a:bookmark.file
    exe 'e ' . a:bookmark.file
  endif
  exe a:bookmark.lnum

endfunction

function! bookmarks#next() abort
  let file = s:FILE.unify_path(expand('%'), ':p')
  if has_key(s:bookmarks, file) && !empty(keys(s:bookmarks[file]))
    for lnum in sort(keys(s:bookmarks[file]))
      if lnum > line('.')
        call s:jump_to_bookmark(s:bookmarks[file][lnum])
        return
      endif
    endfor
    " if all bookmarks < line('.')
    " jump to first bookmark
    call s:jump_to_bookmark(s:bookmarks[file][keys(s:bookmarks[file])[0]])
  else
    call s:NT.notify('no bookmarks found')
  endif

endfunction

function! bookmarks#previous() abort
  let file = s:FILE.unify_path(expand('%'), ':p')

  if has_key(s:bookmarks, file) && !empty(keys(s:bookmarks[file]))
    for lnum in reverse(sort(keys(s:bookmarks[file])))
      if lnum < line('.')
        call s:jump_to_bookmark(s:bookmarks[file][lnum])
        return
      endif
    endfor
    " if all bookmarks > line('.')
    " jump to first bookmark
    call s:jump_to_bookmark(s:bookmarks[file][keys(s:bookmarks[file])[-1]])
  else
    call s:NT.notify('no bookmarks found')
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
  if get(b:, 'bookmarks_init', v:false) || empty(s:BUF.bufname()) || !empty(&buftype)
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
