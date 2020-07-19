" Normal mode
" (Dark)
let s:N1 = [ '#212733' , '#BBE67E' , 0   , 114 ] " guifg guibg ctermfg ctermbg
let s:N2 = [ '#BBE67E' , '#212733' , 114 , 0   ] " guifg guibg ctermfg ctermbg
let s:N3 = [ '#E6E1CF' , '#212733' , 15  , 0   ] " guifg guibg ctermfg ctermbg

" Insert mode
let s:I1 = [ '#212733' , '#80D4FF' , 0   , 80  ] " guifg guibg ctermfg ctermbg
let s:I2 = [ '#80D4FF' , '#212733' , 80  , 0   ] " guifg guibg ctermfg ctermbg
let s:I3 = [ '#E6E1CF' , '#212733' , 15  , 0   ] " guifg guibg ctermfg ctermbg

" Visual mode
let s:V1 = [ '#212733' , '#FFAE57' , 0   , 173 ] " guifg guibg ctermfg ctermbg
let s:V2 = [ '#FFAE57' , '#212733' , 173 , 0   ] " guifg guibg ctermfg ctermbg
let s:V3 = [ '#E6E1CF' , '#212733' , 15  , 0   ] " guifg guibg ctermfg ctermbg

" Replace mode
let s:RE = [ '#212733' , '#F07178' , 0   , 167 ] " guifg guibg ctermfg ctermbg

let g:airline#themes#ayu_mirage#palette = {}

let g:airline#themes#ayu_mirage#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

let g:airline#themes#ayu_mirage#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#ayu_mirage#palette.insert_replace = {
            \ 'airline_a': [ s:RE[0]   , s:I1[1]   , s:RE[1]   , s:I1[3]   , ''     ] }

let g:airline#themes#ayu_mirage#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)

let g:airline#themes#ayu_mirage#palette.replace = copy(g:airline#themes#ayu_mirage#palette.normal)
let g:airline#themes#ayu_mirage#palette.replace.airline_a = [ s:RE[0] , s:RE[1] , s:RE[2] , s:RE[3] , '' ]

let s:IA = [ s:N1[1] , s:N3[1] , s:N1[3] , s:N3[3] , '' ]
let g:airline#themes#ayu_mirage#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
