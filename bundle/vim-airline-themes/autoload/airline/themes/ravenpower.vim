" Pretty much powerlineish clone, and some
" of the hex colours was borrowed from raven

" Normal mode                                    " fg             & bg
let s:N1 = [ '#005f00' , '#1d1f21' , 7  , 8 ]    " darkestgreen   & brightgreen
let s:N2 = [ '#9e9e9e' , '#303030' , 247 , 236 ] " gray8          & gray2
let s:N3 = [ '#c8c8c8' , '#2e2e2e' , 188 , 235 ] " white          & gray4

" Insert mode                                    " fg             & bg
"let s:I1 = [ '#005f5f' , '#ffffff' , 23  , 231 ] " darkestcyan    & white
"let s:I2 = [ '#5fafd7' , '#0087af' , 74  , 31  ] " darkcyan       & darkblue
let s:I1 = [ '#87d7ff' , '#1d1f21' , 7   , 24  ] " mediumcyan     & darkestblue

" Visual mode                                    " fg             & bg
let s:V1 = [ '#080808' , '#ffaf00' , 232 , 214 ] " gray3          & brightestorange

" Replace mode                                   " fg             & bg
let s:RE = [ '#ffffff' , '#d70000' , 231 , 160 ] " white          & brightred

let g:airline#themes#ravenpower#palette = {}

let g:airline#themes#ravenpower#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

let g:airline#themes#ravenpower#palette.insert = airline#themes#generate_color_map(s:I1, s:N2, s:N3)
let g:airline#themes#ravenpower#palette.insert_replace = {
      \ 'airline_a': [  s:RE[0]   , s:I1[1]   , s:RE[1]   , s:I1[3]   , ''     ] }

let g:airline#themes#ravenpower#palette.visual = {
      \ 'airline_a': [ s:V1[0]   , s:V1[1]   , s:V1[2]   , s:V1[3]   , ''     ] }

let g:airline#themes#ravenpower#palette.replace = copy(airline#themes#ravenpower#palette.normal)
let g:airline#themes#ravenpower#palette.replace.airline_a = [ s:RE[0] , s:RE[1] , s:RE[2] , s:RE[3] , '' ]


let s:IA = [ s:N2[1] , s:N3[1] , s:N2[3] , s:N3[3] , '' ]
let g:airline#themes#ravenpower#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
