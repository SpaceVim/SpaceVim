let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#vim_bookmarks#define_highlights() abort " {{{
  highlight default link BookmarkUnitePath     Comment
  highlight default link BookmarkUniteContent  Normal
endfunction " }}}

let s:source = {
      \ 'name': 'vim_bookmarks',
      \ 'description': 'manipulate bookmarks of vim-bookmarks',
      \ 'hooks': {},
      \}
function! s:source.gather_candidates(args, context) abort " {{{
  let files = sort(bm#all_files())
  let candidates = []
  for file in files
    let line_nrs = sort(bm#all_lines(file), "bm#compare_lines")
    for line_nr in line_nrs
      let bookmark = bm#get_bookmark_by_line(file, line_nr)
      call add(candidates, {
            \ 'word': printf("%s:%d | %s", file, line_nr,
            \   bookmark.annotation !=# ''
            \     ? "Annotation: " . bookmark.annotation
            \     : (bookmark.content !=# "" ? bookmark.content
            \                                : "empty line")
            \ ),
            \ 'kind': 'vim_bookmarks',
            \ 'action__path': file,
            \ 'action__line': line_nr,
            \ 'action__bookmark': bookmark,
            \})
    endfor
  endfor
  return copy(candidates)
endfunction " }}}
function! s:source.hooks.on_syntax(args, context) abort " {{{
  call unite#sources#vim_bookmarks#define_highlights()
  highlight default link uniteSource__VimBookmarks_path    BookmarkUnitePath
  highlight default link uniteSource__VimBookmarks_content BookmarkUniteContent

  execute 'syntax match uniteSource__VimBookmarks_path'
        \ '/[^|]\+/'
        \ 'contained containedin=uniteSource__VimBookmarks'
  execute 'syntax match uniteSource__VimBookmarks_content'
        \ '/|.*$/'
        \ 'contained containedin=uniteSource__VimBookmarks'
endfunction " }}}

function! unite#sources#vim_bookmarks#define()
  return s:source
endfunction
call unite#define_source(s:source)  " Required for reloading

" define default converter
call unite#custom_source(
      \ 'vim_bookmarks',
      \ 'converters',
      \ 'converter_vim_bookmarks_short')


let &cpo = s:save_cpo
unlet s:save_cpo
"vim: sts=2 sw=2 smarttab et ai textwidth=0 fdm=marker
