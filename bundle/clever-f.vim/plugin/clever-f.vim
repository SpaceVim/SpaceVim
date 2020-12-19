if exists('g:loaded_clever_f') && g:loaded_clever_f
    finish
endif

noremap <silent><expr><Plug>(clever-f-f)              clever_f#find_with('f')
noremap <silent><expr><Plug>(clever-f-F)              clever_f#find_with('F')
noremap <silent><expr><Plug>(clever-f-t)              clever_f#find_with('t')
noremap <silent><expr><Plug>(clever-f-T)              clever_f#find_with('T')
noremap <silent><expr><Plug>(clever-f-reset)          clever_f#reset()
noremap <silent><expr><Plug>(clever-f-repeat-forward) clever_f#repeat(0)
noremap <silent><expr><Plug>(clever-f-repeat-back)    clever_f#repeat(1)

if ! exists('g:clever_f_not_overwrites_standard_mappings')
    nmap f <Plug>(clever-f-f)
    xmap f <Plug>(clever-f-f)
    omap f <Plug>(clever-f-f)
    nmap F <Plug>(clever-f-F)
    xmap F <Plug>(clever-f-F)
    omap F <Plug>(clever-f-F)
    nmap t <Plug>(clever-f-t)
    xmap t <Plug>(clever-f-t)
    omap t <Plug>(clever-f-t)
    nmap T <Plug>(clever-f-T)
    xmap T <Plug>(clever-f-T)
    omap T <Plug>(clever-f-T)
endif

let g:loaded_clever_f = 1
