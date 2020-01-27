"=============================================================================
" z.vim --- z key bindings
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#mapping#z#init() abort "{{{
    nnoremap <silent><nowait> [Z] :<c-u>LeaderGuide "z"<CR>
    nmap z [Z]
    let g:_spacevim_mappings_z = {}
    let g:_spacevim_mappings_z['<CR>'] = ['call feedkeys("z\<CR>", "n")', 'cursor line to top']
    nnoremap z<CR> z<CR>
    let g:_spacevim_mappings_z['+'] = ['call feedkeys("z+", "n")', 'cursor to screen top line N']
    nnoremap z+ z+
    let g:_spacevim_mappings_z['-'] = ['call feedkeys("z-", "n")', 'cursor to screen bottom line N']
    nnoremap z- z-
    let g:_spacevim_mappings_z['^'] = ['call feedkeys("z^", "n")', 'cursor to screen bottom line N']
    nnoremap z^ z^
    let g:_spacevim_mappings_z['.'] = ['call feedkeys("z.", "n")', 'cursor line to center']
    nnoremap z. z.
    let g:_spacevim_mappings_z['='] = ['call feedkeys("z=", "n")', 'spelling suggestions']
    nnoremap z= z=
    let g:_spacevim_mappings_z['A'] = ['call feedkeys("zA", "n")', 'toggle folds recursively']
    nnoremap zA zA
    let g:_spacevim_mappings_z['C'] = ['call feedkeys("zC", "n")', 'close folds recursively']
    nnoremap zC zC
    let g:_spacevim_mappings_z['D'] = ['call feedkeys("zD", "n")', 'delete folds recursively']
    nnoremap zD zD
    let g:_spacevim_mappings_z['E'] = ['call feedkeys("zE", "n")', 'eliminate all folds']
    nnoremap zE zE
    let g:_spacevim_mappings_z['F'] = ['call feedkeys("zF", "n")', 'create a fold for N lines']
    nnoremap zF zF
    let g:_spacevim_mappings_z['G'] = ['call feedkeys("zG", "n")', 'mark good spelled (update internal wordlist)']
    nnoremap zG zG
    let g:_spacevim_mappings_z['H'] = ['call feedkeys("zH", "n")', 'scroll half a screenwidth to the right']
    nnoremap zH zH
    let g:_spacevim_mappings_z['L'] = ['call feedkeys("zL", "n")', 'scroll half a screenwidth to the left']
    nnoremap zL zL
    let g:_spacevim_mappings_z['M'] = ['call feedkeys("zM", "n")', 'set `foldlevel` to zero']
    nnoremap zM zM
    let g:_spacevim_mappings_z['N'] = ['call feedkeys("zN", "n")', 'set `foldenable`']
    nnoremap zN zN
    let g:_spacevim_mappings_z['O'] = ['call feedkeys("zO", "n")', 'open folds recursively']
    nnoremap zO zO
    let g:_spacevim_mappings_z['R'] = ['call feedkeys("zR", "n")', 'set `foldlevel` to deepest fold']
    nnoremap zR zR
    let g:_spacevim_mappings_z['W'] = ['call feedkeys("zW", "n")', 'mark wrong spelled (update internal wordlist)']
    nnoremap zW zW
    let g:_spacevim_mappings_z['X'] = ['call feedkeys("zX", "n")', 're-apply `foldleve`']
    nnoremap zX zX
    let g:_spacevim_mappings_z['a'] = ['call feedkeys("za", "n")', 'toggle a fold']
    nnoremap za za
    let g:_spacevim_mappings_z['b'] = ['call feedkeys("zb", "n")', 'redraw, cursor line at bottom']
    nnoremap zb zb
    let g:_spacevim_mappings_z['c'] = ['call feedkeys("zc", "n")', 'close a fold']
    nnoremap zc zc
    let g:_spacevim_mappings_z['d'] = ['call feedkeys("zd", "n")', 'delete a fold']
    nnoremap zd zd
    let g:_spacevim_mappings_z['e'] = ['call feedkeys("ze", "n")', 'right scroll horizontally to cursor position']
    nnoremap ze ze
    let g:_spacevim_mappings_z['f'] = ['call feedkeys("zf", "n")', 'create a fold for motion']
    nnoremap zf zf
    let g:_spacevim_mappings_z['g'] = ['call feedkeys("zg", "n")', 'mark good spelled']
    nnoremap zg zg
    let g:_spacevim_mappings_z['h'] = ['call feedkeys("zh", "n")', 'scroll screen N characters to right']
    nnoremap zh zh
    let g:_spacevim_mappings_z['<Left>'] = ['call feedkeys("zh", "n")', 'scroll screen N characters to right']
    nnoremap z<Left> zh
    let g:_spacevim_mappings_z['i'] = ['call feedkeys("zi", "n")', 'toggle foldenable']
    nnoremap zi zi
    let g:_spacevim_mappings_z['j'] = ['call feedkeys("zj", "n")', 'move to start of next fold']
    nnoremap zj zj
    let g:_spacevim_mappings_z['J'] = ['call feedkeys("zjzx", "n")', 'move to and open next fold']
    nnoremap zJ zjzx
    let g:_spacevim_mappings_z['k'] = ['call feedkeys("zk", "n")', 'move to end of previous fold']
    nnoremap zk zk
    let g:_spacevim_mappings_z['K'] = ['call feedkeys("zkzx", "n")', 'move to and open previous fold']
    nnoremap zK zkzx
    let g:_spacevim_mappings_z['l'] = ['call feedkeys("zl", "n")', 'scroll screen N characters to left']
    nnoremap zl zl
    let g:_spacevim_mappings_z['<Right>'] = ['call feedkeys("zl", "n")', 'scroll screen N characters to left']
    nnoremap z<Right> zl
    let g:_spacevim_mappings_z['m'] = ['call feedkeys("zm", "n")', 'subtract one from `foldlevel`']
    nnoremap zm zm
    let g:_spacevim_mappings_z['n'] = ['call feedkeys("zn", "n")', 'reset `foldenable`']
    nnoremap zn zn
    let g:_spacevim_mappings_z['o'] = ['call feedkeys("zo", "n")', 'open fold']
    nnoremap zo zo
    let g:_spacevim_mappings_z['r'] = ['call feedkeys("zr", "n")', 'add one to `foldlevel`']
    nnoremap zr zr
    let g:_spacevim_mappings_z.s = ['call feedkeys("zs", "n")', 'left scroll horizontally to cursor position']
    nnoremap zs zs
    let g:_spacevim_mappings_z['t'] = ['call feedkeys("zt", "n")', 'cursor line at top of window']
    nnoremap zt zt
    let g:_spacevim_mappings_z['v'] = ['call feedkeys("zv", "n")', 'open enough folds to view cursor line']
    nnoremap zv zv
    let g:_spacevim_mappings_z['w'] = ['call feedkeys("zw", "n")', 'mark wrong spelled']
    nnoremap zw zw
    let g:_spacevim_mappings_z['x'] = ['call feedkeys("zx", "n")', 're-apply foldlevel and do "zV"']
    nnoremap zx zx
    " smart scroll
    let g:_spacevim_mappings_z['z'] = ['call feedkeys("zz", "n")', 'smart scroll']
    nnoremap zz zz

endfunction "}}}
