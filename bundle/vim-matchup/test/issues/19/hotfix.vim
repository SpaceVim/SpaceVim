
function! HtmlListHotfix()
    call matchup#util#patch_match_words(
        \ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>',
        \ '')
endfunction

let g:matchup_hotfix_html = 'HtmlListHotfix'

