
" vim-airline 'term_light' theme
" it is using current terminal colorscheme
" and in gvim i left colors from 'wombat' theme but i am not using it anyway

" Normal mode
"          [ guifg, guibg, ctermfg, ctermbg, opts ]
let s:N1 = [ '#f0f0f0' , '#86CD74' , 15,  2 ] " mode
let s:N2 = [ '#86CD74' , '#deded9' ,  2,  8 ] " info
let s:N3 = [ '#86CD74' , '#888a85' ,  2, 15 ] " statusline
let s:N4 = [ '#CAE682' , '#141413' , 10,  0 ] " mode modified

" Insert mode
let s:I1 = [ '#f0f0f0' , '#FADE3E' , 15,  3 ]
let s:I2 = [ '#FADE3E' , '#deded9' ,  3,  8 ]
let s:I3 = [ '#FADE3E' , '#888a85' ,  3, 15 ]
let s:I4 = [ '#FDE76E' , '#141413' , 11,  0 ]

" Visual mode
let s:V1 = [ '#f0f0f0' , '#7CB0E6' , 15,  4 ]
let s:V2 = [ '#7CB0E6' , '#deded9' ,  4,  8 ]
let s:V3 = [ '#7CB0E6' , '#888a85' ,  4, 15 ]
let s:V4 = [ '#B5D3F3' , '#141413' , 12,  0 ]

" Replace mode
let s:R1 = [ '#f0f0f0' , '#E55345' , 15,  1 ]
let s:R2 = [ '#E55345' , '#deded9' ,  1,  8 ]
let s:R3 = [ '#E55345' , '#888a85' ,  1, 15 ]
let s:R4 = [ '#E5786D' , '#141413' ,  9,  0 ]

" Paste mode
let s:PA = [ '#94E42C' , 6 ]

" Info modified
let s:IM = [ '#40403C' , 7 ]

" Inactive mode
let s:IA = [ '#767676' , s:N3[1] , 243 , s:N3[3] , '' ]

let g:airline#themes#term_light#palette = {}

let g:airline#themes#term_light#palette.accents = {
      \ 'red': [ '#E5786D' , '' , 203 , '' , '' ],
      \ }

let g:airline#themes#term_light#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#term_light#palette.normal_modified = {
    \ 'airline_a': [ s:N4[1] , s:N4[0] , s:N4[3] , s:N4[2] , ''     ] ,
    \ 'airline_b': [ s:N4[0] , s:IM[0] , s:N4[2] , s:IM[1] , ''     ] ,
    \ 'airline_c': [ s:N4[0] , s:N3[1] , s:N4[2] , s:N3[3] , ''     ] }


let g:airline#themes#term_light#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#term_light#palette.insert_modified = {
    \ 'airline_a': [ s:I4[1] , s:I4[0] , s:I4[3] , s:I4[2] , ''     ] ,
    \ 'airline_b': [ s:I4[0] , s:IM[0] , s:I4[2] , s:IM[1] , ''     ] ,
    \ 'airline_c': [ s:I4[0] , s:N3[1] , s:I4[2] , s:N3[3] , ''     ] }


let g:airline#themes#term_light#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#term_light#palette.visual_modified = {
    \ 'airline_a': [ s:V4[1] , s:V4[0] , s:V4[3] , s:V4[2] , ''     ] ,
    \ 'airline_b': [ s:V4[0] , s:IM[0] , s:V4[2] , s:IM[1] , ''     ] ,
    \ 'airline_c': [ s:V4[0] , s:N3[1] , s:V4[2] , s:N3[3] , ''     ] }


let g:airline#themes#term_light#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)
let g:airline#themes#term_light#palette.replace_modified = {
    \ 'airline_a': [ s:R4[1] , s:R4[0] , s:R4[3] , s:R4[2] , ''     ] ,
    \ 'airline_b': [ s:R4[0] , s:IM[0] , s:R4[2] , s:IM[1] , ''     ] ,
    \ 'airline_c': [ s:R4[0] , s:N3[1] , s:R4[2] , s:N3[3] , ''     ] }


let g:airline#themes#term_light#palette.insert_paste = {
    \ 'airline_a': [ s:I1[0] , s:PA[0] , s:I1[2] , s:PA[1] , ''     ] ,
    \ 'airline_b': [ s:PA[0] , s:IM[0] , s:PA[1] , s:IM[1] , ''     ] ,
    \ 'airline_c': [ s:PA[0] , s:N3[1] , s:PA[1] , s:N3[3] , ''     ] }


let g:airline#themes#term_light#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
let g:airline#themes#term_light#palette.inactive_modified = {
    \ 'airline_c': [ s:N4[0] , ''      , s:N4[2] , ''      , ''     ] }


if !get(g:, 'loaded_ctrlp', 0)
  finish
endif
let g:airline#themes#term_light#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
      \ [ '#DADADA' , '#242424' , 253 , 234 , ''     ] ,
      \ [ '#DADADA' , '#40403C' , 253 , 238 , ''     ] ,
      \ [ '#141413' , '#DADADA' , 232 , 253 , 'bold' ] )

