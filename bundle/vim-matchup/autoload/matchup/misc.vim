" vim match-up - even better matching
"
" Maintainer: Andy Massimino
" Email:      a@normed.space
"

" {{{1 function! matchup#misc#reload()
if get(s:, 'reload_guard', 1)
  function! matchup#misc#reload() abort
    let s:reload_guard = 0

    for l:file in glob(fnamemodify(s:file, ':h') . '/../**/*.vim', 0, 1)
      execute 'source' l:file
    endfor

    call matchup#init()

    unlet s:reload_guard
  endfunction
endif

" }}}1

let s:file = expand('<sfile>')

" vim: fdm=marker sw=2

