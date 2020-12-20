" vim-airline companion theme of Ubaryd
" (https://github.com/Donearm/Ubaryd)
"
" Author:       Gianluca fiore <https://github.com/Donearm/>
" Version:      1.12
" License:      MIT

" Normal mode
"
let s:N1 = [ '#005f00' , '#f8f6f2','22','15']
let s:N2 = [ '#f8f6f2' , '#005f00','15','22']
let s:N3 = [ '#b88853' , '#242321' , 137, 235 ]
let s:N4 = [ '#005f00' , 22 ]

" Insert mode
let s:I1 = [ '#f8f6f2', '#e25a74','15','161']
let s:I2 = [ '#242321', '#c14c3d','235','160']
let s:I3 = [ '#f4cf86' , '#242321' , 222 , 235 ]
let s:I4 = [ '#f4cf86' , 222 ]

" Visual mode
let s:V1 = [ '#416389', '#f8f6f2','18','15']
let s:V2 = [ '#416389', '#f4cf86','18','222']
let s:V3 = [ '#9a4820' , '#f8f6f2','88','15']
let s:V4 = [ '#9a4820' , 88 ]

" Replace mode
let s:R1 = [ '#242321' , '#f8f6f2','235','15']
let s:R2 = [ '#ffa724' , '#666462','214','241']
let s:R3 = [ '#f8f6f2' , '#ff7400','15','215']
let s:R4 = [ '#ffa724' , 214 ]

" Paste mode
let s:PA = [ '#f9ef6d' , 154 ]

" Info modified
let s:IM = [ '#242321' , 235 ]

" Inactive mode
let s:IA = [ s:N2[1], s:N3[1], s:N2[3], s:N3[3], '' ]	

let g:airline#themes#ubaryd#palette = {}

let g:airline#themes#ubaryd#palette.accents = {
      \ 'red': [ '#ff7400' , '' , 202 , '' , '' ],
      \ }

let g:airline#themes#ubaryd#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#ubaryd#palette.normal_modified = {
    \ 'airline_a': [ s:N1[0] , s:N4[0] , s:N1[2] , s:N4[1] , ''     ] ,
    \ 'airline_b': [ s:N4[0] , s:IM[0] , s:N4[1] , s:IM[1] , ''     ] ,
    \ 'airline_c': [ s:N4[0] , s:N3[1] , s:N4[1] , s:N3[3] , ''     ] }


let g:airline#themes#ubaryd#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#ubaryd#palette.insert_modified = {
    \ 'airline_a': [ s:I1[0] , s:I4[0] , s:I1[2] , s:I4[1] , ''     ] ,
    \ 'airline_b': [ s:I4[0] , s:IM[0] , s:I4[1] , s:IM[1] , ''     ] ,
    \ 'airline_c': [ s:I4[0] , s:N3[1] , s:I4[1] , s:N3[3] , ''     ] }


let g:airline#themes#ubaryd#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#ubaryd#palette.visual_modified = {
    \ 'airline_a': [ s:V1[0] , s:V4[0] , s:V1[2] , s:V4[1] , ''     ] ,
    \ 'airline_b': [ s:V4[0] , s:IM[0] , s:V4[1] , s:IM[1] , ''     ] ,
    \ 'airline_c': [ s:V4[0] , s:N3[1] , s:V4[1] , s:N3[3] , ''     ] }


let g:airline#themes#ubaryd#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)
let g:airline#themes#ubaryd#palette.replace_modified = {
    \ 'airline_a': [ s:R1[0] , s:R4[0] , s:R1[2] , s:R4[1] , ''     ] ,
    \ 'airline_b': [ s:R4[0] , s:IM[0] , s:R4[1] , s:IM[1] , ''     ] ,
    \ 'airline_c': [ s:R4[0] , s:N3[1] , s:R4[1] , s:N3[3] , ''     ] }


let g:airline#themes#ubaryd#palette.insert_paste = {
    \ 'airline_a': [ s:I1[0] , s:PA[0] , s:I1[2] , s:PA[1] , ''     ] ,
    \ 'airline_b': [ s:PA[0] , s:IM[0] , s:PA[1] , s:IM[1] , ''     ] ,
    \ 'airline_c': [ s:PA[0] , s:N3[1] , s:PA[1] , s:N3[3] , ''     ] }


let g:airline#themes#ubaryd#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
let g:airline#themes#ubaryd#palette.inactive_modified = {
    \ 'airline_c': [ s:N4[0] , ''      , s:N4[1] , ''      , ''     ] }



