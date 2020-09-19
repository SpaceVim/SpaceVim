" Normal mode
" (Dark)
let s:N1 = [ '#3D424D' , '#C2D94C' , 59  , 149 ] " guifg guibg ctermfg ctermbg
let s:N2 = [ '#C2D94C' , '#304357' , 149 , 59  ] " guifg guibg ctermfg ctermbg
let s:N3 = [ '#B3B1AD' , '#0A0E14' , 145 , 16  ] " guifg guibg ctermfg ctermbg

" Insert mode
let s:I1 = [ '#3D424D' , '#39BAE6' , 59  , 74  ] " guifg guibg ctermfg ctermbg
let s:I2 = [ '#39BAE6' , '#304357' , 74  , 59  ] " guifg guibg ctermfg ctermbg
let s:I3 = [ '#B3B1AD' , '#0A0E14' , 145 , 16  ] " guifg guibg ctermfg ctermbg

" Visual mode
let s:V1 = [ '#3D424D' , '#FF8F40' , 59  , 209 ] " guifg guibg ctermfg ctermbg
let s:V2 = [ '#FF8F40' , '#304357' , 209 , 59  ] " guifg guibg ctermfg ctermbg
let s:V3 = [ '#B3B1AD' , '#0A0E14' , 145 , 16  ] " guifg guibg ctermfg ctermbg

" Replace mode
let s:RE = [ '#3D424D' , '#FF3333' , 59  , 203 ] " guifg guibg ctermfg ctermbg

let g:airline#themes#ayu_dark#palette = {}

let g:airline#themes#ayu_dark#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

let g:airline#themes#ayu_dark#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#ayu_dark#palette.insert_replace = {
            \ 'airline_a': [ s:RE[0]   , s:I1[1]   , s:RE[1]   , s:I1[3]   , ''     ] }

let g:airline#themes#ayu_dark#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)

let g:airline#themes#ayu_dark#palette.replace = copy(g:airline#themes#ayu_dark#palette.normal)
let g:airline#themes#ayu_dark#palette.replace.airline_a = [ s:RE[0] , s:RE[1] , s:RE[2] , s:RE[3] , '' ]

let s:IA = [ s:N1[1] , s:N3[1] , s:N1[3] , s:N3[3] , '' ]
let g:airline#themes#ayu_dark#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
