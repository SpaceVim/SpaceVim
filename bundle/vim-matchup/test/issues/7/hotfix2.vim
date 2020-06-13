
function! AugroupHotfix()
    call matchup#util#patch_match_words(
        \ '\<aug\%[roup]\s\+\%(END\>\)\@!\S:',
        \ '\<aug\%[roup]\s\+\%(END\>\)\@!\S\@=:')
endfunction

let g:matchup_hotfix_vim = 'AugroupHotfix'

