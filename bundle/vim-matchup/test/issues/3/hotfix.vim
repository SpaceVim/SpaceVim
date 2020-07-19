
function! SQLHotFix()
    call matchup#util#patch_match_words(
        \ '\%(\<create\s\+\%(or\s\+replace\s\+\)\?\)\?'
        \ . '\%(function\|procedure\|event\)'
        \ . ':\<returns\?\>',
        \ '\%(\<create\s\+\%(or\s\+replace\s\+\)\?\)'
        \ . '\%(function\|procedure\|event\)'
        \ . ':\<returns\>'
        \ . ':\<return\s\+\%(next\|query\)\>'
        \ . ':\<return\>\ze\%(\s\+next\)\@!\%(.\|$\)'
        \)
endfunction

let g:matchup_hotfix_sql = 'SQLHotFix'

