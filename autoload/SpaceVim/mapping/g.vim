function! SpaceVim#mapping#g#init() abort
    nnoremap <silent><nowait> [g] :<c-u>LeaderGuide "g"<CR>
    nmap g [g]
    let g:_spacevim_mappings_g = {}
    let g:_spacevim_mappings_g['<C-G>'] = ['call feedkeys("g\<c-g>", "n")', 'show cursor info']
    nnoremap g<c-g> g<c-g>
    let g:_spacevim_mappings_g['&'] = ['call feedkeys("g&", "n")', 'repeat last ":s" on all lines']
    nnoremap g& g&
    let g:_spacevim_mappings_g['#'] = ['call feedkeys("\<Plug>(incsearch-nohl-g#)")', 'search under cursor']
    let g:_spacevim_mappings_g['$'] = ['call feedkeys("g$", "n")', 'go to rightmost character']
    let g:_spacevim_mappings_g['e'] = ['call feedkeys("ge", "n")', 'go to end of previous word']
    nnoremap ge ge



endfunction
