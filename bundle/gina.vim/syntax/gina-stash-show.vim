if exists('b:current_syntax')
  finish
endif

syntax match GinaStashShowAdded /^\d\+/ nextgroup=GinaStashShowRemoved skipwhite
syntax match GinaStashShowRemoved /\d\+/ nextgroup=GinaStashShowPath skipwhite contained
syntax match GinaStashShowPath /.\+/ contained

function! s:define_highlights() abort
  highlight default link GinaStashShowAdded   Statement
  highlight default link GinaStashShowRemoved Constant
  highlight default link GinaStashShowPath    Comment
endfunction

augroup gina_syntax_stash_show_internal
  autocmd! *
  autocmd ColorScheme * call s:define_highlights()
augroup END

call s:define_highlights()

let b:current_syntax = 'gina-stash-show'
