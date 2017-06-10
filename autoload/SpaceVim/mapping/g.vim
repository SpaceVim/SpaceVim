function! SpaceVim#mapping#g#init() abort
    nnoremap <silent><nowait> [g] :<c-u>LeaderGuide "g"<CR>
    nmap g [g]
    let g:_spacevim_mappings_g = {}
endfunction
