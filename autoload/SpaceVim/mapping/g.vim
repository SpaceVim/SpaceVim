function! SpaceVim#mapping#g#init() abort
    nnoremap <silent><nowait> [g] :<c-u>LeaderGuide "g"<CR>
    nmap g [g]
    let g:_spacevim_mappings_g = {}
    let g:_spacevim_mappings_g['<C-G>'] = ['call feedkeys("g\<c-g>", "n")', 'show cursor info']
    nnoremap g<c-g> g<c-g>
    let g:_spacevim_mappings_g['&'] = ['call feedkeys("g&", "n")', 'repeat last ":s" on all lines']
    nnoremap g& g&
    let g:_spacevim_mappings_g['#'] = ['call feedkeys("\<Plug>(incsearch-nohl-g#)")', 'search under cursor backward']
    let g:_spacevim_mappings_g['*'] = ['call feedkeys("\<Plug>(incsearch-nohl-g*)")', 'search under cursor forward']
    let g:_spacevim_mappings_g['/'] = ['call feedkeys("\<Plug>(incsearch-stay)")', 'stay incsearch']
    let g:_spacevim_mappings_g['$'] = ['call feedkeys("g$", "n")', 'go to rightmost character']
    nnoremap g$ g$
    let g:_spacevim_mappings_g['<End>'] = ['call feedkeys("g$", "n")', 'go to rightmost character']
    nnoremap g<End> g<End>
    let g:_spacevim_mappings_g['0'] = ['call feedkeys("g0", "n")', 'go to leftmost character']
    nnoremap g0 g0
    let g:_spacevim_mappings_g['<Home>'] = ['call feedkeys("g0", "n")', 'go to leftmost character']
    nnoremap g<Home> g<Home>
    let g:_spacevim_mappings_g['e'] = ['call feedkeys("ge", "n")', 'go to end of previous word']
    nnoremap ge ge
    let g:_spacevim_mappings_g['<'] = ['call feedkeys("g<", "n")', 'last page of previous command output']
    nnoremap g< g<
    let g:_spacevim_mappings_g['f'] = ['call feedkeys("gf", "n")', 'edit file under cursor']
    nnoremap gf gf
    let g:_spacevim_mappings_g['j'] = ['call feedkeys("gj", "n")', 'move cursor down screen line']
    nnoremap gj gj
    let g:_spacevim_mappings_g['k'] = ['call feedkeys("gk", "n")', 'move cursor up screen line']
    nnoremap gk gk
    let g:_spacevim_mappings_g['u'] = ['call feedkeys("gu", "n")', 'make motion text lowercase']
    nnoremap gu gu
    let g:_spacevim_mappings_g['U'] = ['call feedkeys("gU", "n")', 'make motion text uppercase']
    nnoremap gU gU
    let g:_spacevim_mappings_g['H'] = ['call feedkeys("gH", "n")', 'select line mode']
    nnoremap gH gH

    let g:_spacevim_mappings_g['d'] = ['call SpaceVim#mapping#gd()', 'goto definition']
    call SpaceVim#mapping#def('nnoremap <silent>', 'gd', ':call SpaceVim#mapping#gd()<CR>', 'Goto declaration', '')


endfunction
