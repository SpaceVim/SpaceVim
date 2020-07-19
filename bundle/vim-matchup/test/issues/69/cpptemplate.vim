
function! CppTemplate()
  call matchup#util#append_match_words(
        \ '\%(\s\@<!<\|<\s\@!\)=\@!:\%(\s\@<!>\|>\s\@!\)=\@!')
endfunction
if !exists('g:matchup_hotfix')
  let g:matchup_hotfix = {}
endif
let g:matchup_hotfix.cpp = 'CppTemplate'
set matchpairs-=<:>

