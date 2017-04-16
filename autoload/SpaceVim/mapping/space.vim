function! SpaceVim#mapping#space#init() abort
    nnoremap <silent><nowait> [SPC] :<c-u>LeaderGuide " "<CR>
    nmap <Space> [SPC]
    let g:_spacevim_mappings_space = {}
    let g:_spacevim_mappings_space.t = {'name' : 'Toggle editor visuals'}
    nnoremap <silent> [SPC]tn  :<C-u>set nu!<CR>
endfunction
