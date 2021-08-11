if !exists("g:bm_sign_init")
  let g:bm_sign_init = 0
endif

" Sign {{{

function! bm_sign#lazy_init()
  if g:bm_sign_init ==# 0
    call bm_sign#init()
    let g:bm_sign_init = 1
  endif
endfunction

function! bm_sign#init()
  call bm_sign#define_highlights()
  sign define Bookmark texthl=BookmarkSign
  sign define BookmarkAnnotation texthl=BookmarkAnnotationSign
  execute "sign define Bookmark text=". g:bookmark_sign
  execute "sign define BookmarkAnnotation text=". g:bookmark_annotation_sign
  if g:bookmark_highlight_lines
    sign define Bookmark linehl=BookmarkLine
    sign define BookmarkAnnotation linehl=BookmarkAnnotationLine
  else
    sign define Bookmark linehl=
    sign define BookmarkAnnotation linehl=
  endif
endfunction

function! bm_sign#define_highlights()
  highlight BookmarkSignDefault ctermfg=33 ctermbg=NONE
  highlight BookmarkAnnotationSignDefault ctermfg=28 ctermbg=NONE
  highlight BookmarkLineDefault ctermfg=232 ctermbg=33
  highlight BookmarkAnnotationLineDefault ctermfg=232 ctermbg=28
  highlight default link BookmarkSign BookmarkSignDefault
  highlight default link BookmarkAnnotationSign BookmarkAnnotationSignDefault
  highlight default link BookmarkLine BookmarkLineDefault
  highlight default link BookmarkAnnotationLine BookmarkAnnotationLineDefault
endfunction

function! bm_sign#add(file, line_nr, is_annotation)
  call bm_sign#lazy_init()
  let sign_idx = g:bm_sign_index
  call bm_sign#add_at(a:file, sign_idx, a:line_nr, a:is_annotation)
  return sign_idx
endfunction

" add sign with certain index
function! bm_sign#add_at(file, sign_idx, line_nr, is_annotation)
  call bm_sign#lazy_init()
  let name = a:is_annotation ==# 1 ? "BookmarkAnnotation" : "Bookmark"
  execute "sign place ". a:sign_idx ." line=" . a:line_nr ." name=". name ." file=". a:file
  if (a:sign_idx >=# g:bm_sign_index)
    let g:bm_sign_index = a:sign_idx + 1
  endif
endfunction

function! bm_sign#update_at(file, sign_idx, line_nr, is_annotation)
  call bm_sign#del(a:file, a:sign_idx)
  call bm_sign#add_at(a:file, a:sign_idx, a:line_nr, a:is_annotation)
endfunction

function! bm_sign#del(file, sign_idx)
  call bm_sign#lazy_init()
  try
    execute "sign unplace ". a:sign_idx ." file=". a:file
  catch
  endtry
endfunction

" Returns dict with {'sign_idx': 'line_nr'}
function! bm_sign#lines_for_signs(file)
  call bm_sign#lazy_init()
  let bufnr = bufnr(a:file)
  let signs_raw = util#redir_execute(":sign place file=". a:file)
  let lines = split(signs_raw, "\n")
  let result = {}
  for line in lines
    let results = matchlist(line, 'line=\(\d\+\)\W\+id=\(\d\+\)\W\+name=bookmark\c')
    if len(results) ># 0
      let result[results[2]] = results[1]
    endif
  endfor
  return result
endfunction

" }}}
