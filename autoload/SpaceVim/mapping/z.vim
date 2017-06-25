function! SpaceVim#mapping#z#init() abort "{{{
    nnoremap <silent><nowait> [z] :<c-u>LeaderGuide "z"<CR>
    nmap z [z]
    let g:_spacevim_mappings_z = {}
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
    let g:_spacevim_mappings_z['G'] = ['call feedkeys("zG", "n")', 'mark good spelled(update internal-wordlist)']
    nnoremap zG zG
    let g:_spacevim_mappings_z['M'] = ['call feedkeys("zM", "n")', 'set `foldlevel` to zero']
    nnoremap zM zM
    let g:_spacevim_mappings_z['N'] = ['call feedkeys("zN", "n")', 'set `foldenable`']
    nnoremap zN zN
    let g:_spacevim_mappings_z['O'] = ['call feedkeys("zO", "n")', 'open folds recursively']
    nnoremap zO zO
    let g:_spacevim_mappings_z['R'] = ['call feedkeys("zR", "n")', 'set `foldlevel` to deepest fold']
    nnoremap zR zR
    let g:_spacevim_mappings_z['W'] = ['call feedkeys("zW", "n")', 'mark wrong spelled']
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
    let g:_spacevim_mappings_z['g'] = ['call feedkeys("zg", "n")', 'mark good spelled']
    nnoremap zg zg
    let g:_spacevim_mappings_z['i'] = ['call feedkeys("zi", "n")', 'toggle foldenable']
    nnoremap zi zi
    let g:_spacevim_mappings_z['j'] = ['call feedkeys("zj", "n")', 'mode to start of next fold']
    nnoremap zj zj
    let g:_spacevim_mappings_z['k'] = ['call feedkeys("zk", "n")', 'mode to end of previous fold']
    nnoremap zk zk
    let g:_spacevim_mappings_z['m'] = ['call feedkeys("zm", "n")', 'subtract one from `foldlevel`']
    nnoremap zm zm
    let g:_spacevim_mappings_z['n'] = ['call feedkeys("zn", "n")', 'reset `foldenable`']
    nnoremap zn zn
    let g:_spacevim_mappings_z['o'] = ['call feedkeys("zo", "n")', 'open fold']
    nnoremap zo zo
    let g:_spacevim_mappings_z['r'] = ['call feedkeys("zr", "n")', 'add one to `foldlevel`']
    nnoremap zr zr
    " smart scroll
    let g:_spacevim_mappings_z['z'] = ['call feedkeys("zz", "n")', 'smart scroll']
    nnoremap zz zz

endfunction "}}}
