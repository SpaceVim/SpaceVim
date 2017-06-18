" the theme colors should be 
" [
"    \ [ a_guifg, a_guibg, a_ctermfg, a_ctermbg],
"    \ [ b_guifg, b_guibg, b_ctermfg, b_ctermbg],
"    \ [ c_guifg, c_guibg, c_ctermfg, c_ctermbg],
"    \ [ z_guibg, z_ctermbg],
"    \ [ i_guifg, i_guibg, i_ctermfg, i_ctermbg],
"    \ [ v_guifg, v_guibg, v_ctermfg, v_ctermbg],
"    \ [ r_guifg, r_guibg, r_ctermfg, r_ctermbg],
" \ ]

let s:yellow = 'ctermfg=214 guifg=#fabd2f'
let s:blus = 'ctermfg=109 guifg=#83a598'
let s:aqua =  'ctermfg=108 guifg=#8ec07c'
let s:orange = 'ctermfg=208 guifg=#fe8019'
function! SpaceVim#mapping#guide#theme#gruvbox#palette() abort
    return [
                \ ['#282828', '#a89984', 246, 235],
                \ ['#a89984', '#504945', 239, 246],
                \ ['#a89984', '#3c3836', 237, 246],
                \ ['#665c54', 241],
                \ ['#282828', '#83a598', 235, 109],
                \ ['#282828', '#fe8019', 235, 208],
                \ ['#282828', '#8ec07c', 235, 108],
                \ ]
endfunction
