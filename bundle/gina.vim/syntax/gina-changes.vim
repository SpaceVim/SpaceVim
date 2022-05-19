if exists('b:current_syntax')
  finish
endif

syntax match GinaChangesAdded /^\d\+/ nextgroup=GinaChangesRemoved skipwhite
syntax match GinaChangesRemoved /\d\+/ nextgroup=GinaChangesPath skipwhite contained
syntax match GinaChangesPath /.\+/ contained

function! s:define_highlights() abort
  highlight default link GinaChangesAdded   Statement
  highlight default link GinaChangesRemoved Constant
  highlight default link GinaChangesPath    Comment
endfunction

augroup gina_syntax_changes_internal
  autocmd! *
  autocmd ColorScheme * call s:define_highlights()
augroup END

call s:define_highlights()

let b:current_syntax = 'gina-changes'
