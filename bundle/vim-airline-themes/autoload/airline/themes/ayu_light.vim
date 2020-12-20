" Normal mode
" (Dark)
let s:N1 = [ '#6C7680' , '#86B300' , 66  , 106 ] " guifg guibg ctermfg ctermbg
let s:N2 = [ '#86B300' , '#6C7680' , 106 , 66  ] " guifg guibg ctermfg ctermbg
let s:N3 = [ '#6C7680' , '#FAFAFA' , 66  , 231 ] " guifg guibg ctermfg ctermbg

" Insert mode
let s:I1 = [ '#6C7680' , '#55B4D4' , 66  , 74  ] " guifg guibg ctermfg ctermbg
let s:I2 = [ '#55B4D4' , '#6C7680' , 74  , 66  ] " guifg guibg ctermfg ctermbg
let s:I3 = [ '#6C7680' , '#FAFAFA' , 66  , 231 ] " guifg guibg ctermfg ctermbg

" Visual mode
let s:V1 = [ '#6C7680' , '#FA8D3E' , 66  , 209 ] " guifg guibg ctermfg ctermbg
let s:V2 = [ '#FA8D3E' , '#6C7680' , 209 , 66  ] " guifg guibg ctermfg ctermbg
let s:V3 = [ '#6C7680' , '#FAFAFA' , 66  , 231 ] " guifg guibg ctermfg ctermbg

" Replace mode
let s:RE = [ '#6C7680' , '#F51818' , 66  , 196 ] " guifg guibg ctermfg ctermbg

let g:airline#themes#ayu_light#palette = {}

let g:airline#themes#ayu_light#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

let g:airline#themes#ayu_light#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#ayu_light#palette.insert_replace = {
            \ 'airline_a': [ s:RE[0]   , s:I1[1]   , s:RE[1]   , s:I1[3]   , ''     ] }

let g:airline#themes#ayu_light#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)

let g:airline#themes#ayu_light#palette.replace = copy(g:airline#themes#ayu_light#palette.normal)
let g:airline#themes#ayu_light#palette.replace.airline_a = [ s:RE[0] , s:RE[1] , s:RE[2] , s:RE[3] , '' ]

let s:IA = [ s:N1[1] , s:N3[1] , s:N1[3] , s:N3[3] , '' ]
let g:airline#themes#ayu_light#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
