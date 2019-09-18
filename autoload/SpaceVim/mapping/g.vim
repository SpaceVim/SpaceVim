"=============================================================================
" g.vim --- g key bindings
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#mapping#g#init() abort
    nnoremap <silent><nowait> [G] :<c-u>LeaderGuide "g"<CR>
    nmap g [G]
    let g:_spacevim_mappings_g = {}
    let g:_spacevim_mappings_g['<C-G>'] = ['call feedkeys("g\<c-g>", "n")', 'show cursor info']
    nnoremap g<c-g> g<c-g>
    let g:_spacevim_mappings_g['&'] = ['call feedkeys("g&", "n")', 'repeat last ":s" on all lines']
    nnoremap g& g&

    let g:_spacevim_mappings_g["'"] = ['call feedkeys("g' . "'" . '", "n")', 'jump to mark']
    nnoremap g' g'
    let g:_spacevim_mappings_g['`'] = ['call feedkeys("g' . '`' . '", "n")', 'jump to mark']
    nnoremap g` g`

    let g:_spacevim_mappings_g['+'] = ['call feedkeys("g+", "n")', 'newer text state']
    nnoremap g+ g+
    let g:_spacevim_mappings_g['-'] = ['call feedkeys("g-", "n")', 'older text state']
    nnoremap g- g-
    let g:_spacevim_mappings_g[','] = ['call feedkeys("g,", "n")', 'newer position in change list']
    nnoremap g, g,
    let g:_spacevim_mappings_g[';'] = ['call feedkeys("g;", "n")', 'older position in change list']
    nnoremap g; g;
    let g:_spacevim_mappings_g['@'] = ['call feedkeys("g@", "n")', 'call operatorfunc']
    nnoremap g@ g@

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
    let g:_spacevim_mappings_g['F'] = ['call feedkeys("gF", "n")', 'edit file under cursor(jump to line after name)']
    nnoremap gF gF
    let g:_spacevim_mappings_g['j'] = ['call feedkeys("gj", "n")', 'move cursor down screen line']
    nnoremap gj gj
    let g:_spacevim_mappings_g['k'] = ['call feedkeys("gk", "n")', 'move cursor up screen line']
    nnoremap gk gk
    let g:_spacevim_mappings_g['u'] = ['call feedkeys("gu", "n")', 'make motion text lowercase']
    nnoremap gu gu
    let g:_spacevim_mappings_g['E'] = ['call feedkeys("gE", "n")', 'end of previous word']
    nnoremap gE gE
    let g:_spacevim_mappings_g['U'] = ['call feedkeys("gU", "n")', 'make motion text uppercase']
    nnoremap gU gU
    let g:_spacevim_mappings_g['H'] = ['call feedkeys("gH", "n")', 'select line mode']
    nnoremap gH gH
    let g:_spacevim_mappings_g['h'] = ['call feedkeys("gh", "n")', 'select mode']
    nnoremap gh gh
    let g:_spacevim_mappings_g['I'] = ['call feedkeys("gI", "n")', 'insert text in column 1']
    nnoremap gI gI
    let g:_spacevim_mappings_g['i'] = ['call feedkeys("gi", "n")', "insert text after '^ mark"]
    nnoremap gi gi
    let g:_spacevim_mappings_g['J'] = ['call feedkeys("gJ", "n")', 'join lines without space']
    nnoremap gJ gJ
    let g:_spacevim_mappings_g['N'] = ['call feedkeys("gN", "n")', 'visually select previous match']
    nnoremap gN gN
    let g:_spacevim_mappings_g['n'] = ['call feedkeys("gn", "n")', 'visually select next match']
    nnoremap gn gn
    let g:_spacevim_mappings_g['Q'] = ['call feedkeys("gQ", "n")', 'switch to Ex mode']
    nnoremap gQ gQ
    let g:_spacevim_mappings_g['q'] = ['call feedkeys("gq", "n")', 'format Nmove text']
    nnoremap gq gq
    let g:_spacevim_mappings_g['R'] = ['call feedkeys("gR", "n")', 'enter VREPLACE mode']
    nnoremap gR gR
    let g:_spacevim_mappings_g['T'] = ['call feedkeys("gT", "n")', 'previous tag page']
    nnoremap gT gT
    let g:_spacevim_mappings_g['t'] = ['call feedkeys("gt", "n")', 'next tag page']
    nnoremap gt gt
    let g:_spacevim_mappings_g[']'] = ['call feedkeys("g]", "n")', 'tselect cursor tag']
    nnoremap g] g]
    let g:_spacevim_mappings_g['^'] = ['call feedkeys("g^", "n")', 'go to leftmost no-white character']
    nnoremap g^ g^
    let g:_spacevim_mappings_g['_'] = ['call feedkeys("g_", "n")', 'go to last char']
    nnoremap g_ g_
    let g:_spacevim_mappings_g['~'] = ['call feedkeys("g~", "n")', 'swap case for Nmove text']
    nnoremap g~ g~
    let g:_spacevim_mappings_g['a'] = ['call feedkeys("ga", "n")', 'print ascii value of cursor character']
    nnoremap ga ga
    let g:_spacevim_mappings_g['g'] = ['call feedkeys("gg", "n")', 'go to line N']
    nnoremap gg gg
    let g:_spacevim_mappings_g['m'] = ['call feedkeys("gm", "n")', 'go to middle of screenline']
    nnoremap gm gm
    let g:_spacevim_mappings_g['o'] = ['call feedkeys("go", "n")', 'goto byte N in the buffer']
    nnoremap go go
    let g:_spacevim_mappings_g.s = ['call feedkeys("gs", "n")', 'sleep N seconds']
    nnoremap gs gs
    let g:_spacevim_mappings_g['v'] = ['call feedkeys("gv", "n")', 'reselect the previous Visual area']
    nnoremap gv gv
    let g:_spacevim_mappings_g['<C-]>'] = ['call feedkeys("g<c-]>", "n")', 'jump to tag under cursor']
    nnoremap g<c-]> g<c-]>
    let g:_spacevim_mappings_g['d'] = ['call SpaceVim#mapping#gd()', 'goto definition']
    call SpaceVim#mapping#def('nnoremap <silent>', 'gd', ':call SpaceVim#mapping#gd()<CR>', 'Goto declaration', '')


endfunction
