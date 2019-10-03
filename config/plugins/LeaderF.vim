scriptencoding utf-8
let g:Lf_StlSeparator = get(g:, 'Lf_StlSeparator', { 'left': '', 'right': '' })
let g:Lf_StlColorscheme = g:spacevim_colorscheme
" disable default mru
"
augroup LeaderF_Mru
    autocmd!
augroup END
