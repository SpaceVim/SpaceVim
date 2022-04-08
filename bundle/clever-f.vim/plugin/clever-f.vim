if exists('g:loaded_clever_f') && g:loaded_clever_f
    finish
endif

noremap <silent> <Plug>(clever-f-f)              :<C-u>call clever_f#find_with('f')<Cr>
noremap <silent> <Plug>(clever-f-F)              :<C-u>call clever_f#find_with('F')<Cr>
noremap <silent> <Plug>(clever-f-t)              :<C-u>call clever_f#find_with('t')<Cr>
noremap <silent> <Plug>(clever-f-T)              :<C-u>call clever_f#find_with('T')<Cr>
noremap <silent> <Plug>(clever-f-reset)          :<C-u>call clever_f#reset()<Cr>
noremap <silent> <Plug>(clever-f-repeat-forward) :<C-u>call clever_f#repeat(0)<Cr>
noremap <silent> <Plug>(clever-f-repeat-back)    :<C-u>call clever_f#repeat(1)<Cr>

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
