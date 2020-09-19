" base16-snazzy
" theme format modified from wombat 
" colors from sindresorhus/hyper-snazzy & h404bi/base16-snazzy-scheme/
" Made by Ayush Shenoy (masala-man)
"
"   BASE16-SNAZZY        XTERM
let s:base00 = '#282a36' "236 
let s:base01 = '#34353e' "237
let s:base02 = '#43454f' "238
let s:base03 = '#78787e' "244
let s:base04 = '#a5a5a9' "248
let s:base05 = '#e2e4e5' "254
let s:base06 = '#eff0eb' "255
let s:base07 = '#f1f1f0' "15
let s:base08 = '#ff5c57' "203
let s:base09 = '#ff9f43' "215
let s:base0A = '#f3f99d' "229
let s:base0B = '#5af78e' "84
let s:base0C = '#9aedfe' "123
let s:base0D = '#57c7ff' "81
let s:base0E = '#ff6ac1' "205
let s:base0F = '#b2643c' "131

" Normal mode
"          [ guifg , guibg , ctermfg , ctermbg , opts ]
let s:N1 = [ s:base00 , s:base0D , 235 , 81 ]           " [ color of body and line-info ]
let s:N2 = [ s:base0D , s:base00 , 81 , 235 ]           " [ diffcount and file-info ]
let s:N3 = [ s:base0D , s:base00 , 81 , 235 ]           " [ filename ]
let s:N4 = [ s:base0D , 81 ]                            " [ buffer modified ]

" Insert mode
let s:I1 = [ s:base00 , s:base0B , 235 , 84 ]
let s:I2 = [ s:base0B , s:base00 , 84 , 235 ]
let s:I3 = [ s:base0B , s:base00 , 84 , 235 ]
let s:I4 = [ s:base0B , 84 ]

" Visual mode
let s:V1 = [ s:base00 , s:base0A , 235 , 229 ]
let s:V2 = [ s:base0A , s:base00 , 229 , 235 ]
let s:V3 = [ s:base0A , s:base00 , 229 , 235 ]
let s:V4 = [ s:base0A , 229 ]

" Replace mode
let s:R1 = [ s:base00 , s:base08 , 235 , 203 ]
let s:R2 = [ s:base08 , s:base00 , 203 , 235 ]
let s:R3 = [ s:base08 , s:base00 , 203 , 235 ]
let s:R4 = [ s:base08 , 203 ]

" Paste mode
let s:PA = [ s:base0B , 84 ] 

" Info modified
let s:IM = [ s:base00 , 235 ]

" Inactive mode
let s:IA = [ '' , s:N3[1] , 244 , 235 , '' ] " [ color of bar on inactive splits ]

let g:airline#themes#base16_snazzy#palette = {}
 
let g:airline#themes#base16_snazzy#palette.accents = {
      \ 'red': [ s:base08 , '' , 203 , '' , '' ]
      \ }

let ER = [ s:base00 , s:base08 , 235 , 203 ]      " [ error color ]
let WI = [ s:base00 , s:base0A , 235 , 229 ]      " [ warning color ]

let g:airline#themes#base16_snazzy#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#base16_snazzy#palette.normal_modified = {
    \ 'airline_a': [ s:N1[0] , s:N4[0] , s:N1[2] , s:N4[1] , ''     ] ,
    \ 'airline_b': [ s:N4[0] , s:IM[0] , s:N4[1] , s:IM[1] , ''     ] ,
    \ 'airline_c': [ s:N4[0] , s:N3[1] , s:N4[1] , s:N3[3] , ''     ] }

let g:airline#themes#base16_snazzy#palette.normal.airline_error = ER
let g:airline#themes#base16_snazzy#palette.normal.airline_warning = WI
let g:airline#themes#base16_snazzy#palette.normal_modified.airline_error = ER
let g:airline#themes#base16_snazzy#palette.normal_modified.airline_warning = WI

let g:airline#themes#base16_snazzy#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#base16_snazzy#palette.insert_modified = {
    \ 'airline_a': [ s:I1[0] , s:I4[0] , s:I1[2] , s:I4[1] , ''     ] ,
    \ 'airline_b': [ s:I4[0] , s:IM[0] , s:I4[1] , s:IM[1] , ''     ] ,
    \ 'airline_c': [ s:I4[0] , s:N3[1] , s:I4[1] , s:N3[3] , ''     ] }

let g:airline#themes#base16_snazzy#palette.insert.airline_error = ER
let g:airline#themes#base16_snazzy#palette.insert.airline_warning = WI
let g:airline#themes#base16_snazzy#palette.insert_modified.airline_error = ER
let g:airline#themes#base16_snazzy#palette.insert_modified.airline_warning = WI

let g:airline#themes#base16_snazzy#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#base16_snazzy#palette.visual_modified = {
    \ 'airline_a': [ s:V1[0] , s:V4[0] , s:V1[2] , s:V4[1] , ''     ] ,
    \ 'airline_b': [ s:V4[0] , s:IM[0] , s:V4[1] , s:IM[1] , ''     ] ,
    \ 'airline_c': [ s:V4[0] , s:N3[1] , s:V4[1] , s:N3[3] , ''     ] }

let g:airline#themes#base16_snazzy#palette.visual.airline_error = ER
let g:airline#themes#base16_snazzy#palette.visual.airline_warning = WI
let g:airline#themes#base16_snazzy#palette.visual_modified.airline_error = ER
let g:airline#themes#base16_snazzy#palette.visual_modified.airline_warning = WI

let g:airline#themes#base16_snazzy#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)
let g:airline#themes#base16_snazzy#palette.replace_modified = {
    \ 'airline_a': [ s:R1[0] , s:R4[0] , s:R1[2] , s:R4[1] , ''     ] ,
    \ 'airline_b': [ s:R4[0] , s:IM[0] , s:R4[1] , s:IM[1] , ''     ] ,
    \ 'airline_c': [ s:R4[0] , s:N3[1] , s:R4[1] , s:N3[3] , ''     ] }

let g:airline#themes#base16_snazzy#palette.replace.airline_error = ER
let g:airline#themes#base16_snazzy#palette.replace.airline_warning = WI
let g:airline#themes#base16_snazzy#palette.replace_modified.airline_error = ER
let g:airline#themes#base16_snazzy#palette.replace_modified.airline_warning = WI

let g:airline#themes#base16_snazzy#palette.insert_paste = {
    \ 'airline_a': [ s:I1[0] , s:PA[0] , s:I1[2] , s:PA[1] , ''     ] ,
    \ 'airline_b': [ s:PA[0] , s:IM[0] , s:PA[1] , s:IM[1] , ''     ] ,
    \ 'airline_c': [ s:PA[0] , s:N3[1] , s:PA[1] , s:N3[3] , ''     ] }

let g:airline#themes#base16_snazzy#palette.insert_paste.airline_error = ER
let g:airline#themes#base16_snazzy#palette.insert_paste.airline_warning = WI

let g:airline#themes#base16_snazzy#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
let g:airline#themes#base16_snazzy#palette.inactive_modified = {
    \ 'airline_c': [ s:N4[0] , ''      , s:N4[1] , ''      , ''     ] }
