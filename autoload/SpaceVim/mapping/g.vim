function! SpaceVim#mapping#g#init() abort
    nnoremap <silent><nowait> [g] :<c-u>LeaderGuide "g"<CR>
    nmap g [g]
    let g:_spacevim_mappings_g = {}
    let g:_spacevim_mappings_g['<C-g>'] = ['call feedkeys("g<c-g>", "n")', 'show cursor info']
    nnoremap g<c-g> g<c-g>
endfunction
