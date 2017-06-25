function! SpaceVim#mapping#z#init() abort
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
    let g:_spacevim_mappings_z['G'] = ['call feedkeys("zG", "n")', 'mark good spelled']
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
endfunction
