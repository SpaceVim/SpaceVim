let s:save_cpo = &cpo
set cpo&vim


function! s:format_bookmark(candidate) " {{{
  let file = a:candidate.action__path
  let line_nr = a:candidate.action__line
  let bookmark = a:candidate.action__bookmark
  return printf("%s:%d | %s", pathshorten(file), line_nr,
        \   bookmark.annotation !=# ''
        \     ? "Annotation: " . bookmark.annotation
        \     : (bookmark.content !=# "" ? bookmark.content
        \                                : "empty line")
        \ )
endfunction " }}}
let s:converter = {
      \ 'name': 'converter_vim_bookmarks_short',
      \ 'description': 'vim-bookmarks converter which show short informations',
      \}
function! s:converter.filter(candidates, context) " {{{
  let candidates = copy(a:candidates)
  for candidate in candidates
    let candidate.abbr = s:format_bookmark(candidate)
  endfor
  return candidates
endfunction " }}}

function! unite#filters#converter_vim_bookmarks_short#define() " {{{
  return s:converter
endfunction " }}}
call unite#define_filter(s:converter)

let &cpo = s:save_cpo
unlet s:save_cpo
"vim: sts=2 sw=2 smarttab et ai textwidth=0 fdm=marker
