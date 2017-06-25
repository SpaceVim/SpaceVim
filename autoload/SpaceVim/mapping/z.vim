function! SpaceVim#mapping#z#init() abort
    nnoremap <silent><nowait> [z] :<c-u>LeaderGuide "z"<CR>
    nmap z [z]
    let g:_spacevim_mappings_z = {}
endfunction
