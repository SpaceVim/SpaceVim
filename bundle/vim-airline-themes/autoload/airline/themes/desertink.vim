" Based on powerlinish
"
" Theme to mimic the default colorscheme of powerline
" Not 100% the same so it's powerline... ish.
"
" Differences from default powerline:
" * Paste indicator isn't colored different
" * Far right hand section matches the color of the mode indicator
"
" Differences from other airline themes:
" * No color differences when you're in a modified buffer
" * Visual mode only changes the mode section. Otherwise
"   it appears the same as normal mode

" Normal mode
let s:N1 = [ '#005f00' , '#afd700' , 22  , 148, '' ]
let s:N2 = [ '#bbbbbb' , '#444444' , 250 , 238, '' ]
let s:N3 = [ '#ffffff' , '#303030' , 231 , 235, 'bold' ]

" Insert mode
let s:I1 = [ '#ffffff' , '#004866' , 231 , 24 ]
let s:I2 = [ '#99DDFF' , '#0087af' , 74  , 31 ]
let s:I3 = [ '#B2E5FF' , '#005f87' , 117 , 24 ]

" Visual mode
let s:V1 = [ '#080808' , '#ffaf00' , 232 , 214 ]

" Replace mode
let s:RE = [ '#ffffff' , '#d74444' , 231 , 9 ]

" Inactive mode
let s:IA1 = [ '#777777' , '#4a4a4a' , 240 , 237     , '' ]
let s:IA2 = [ '#777777' , '#3a3a3a' , 242 , 236     , '' ]
let s:IA3 = [ '#999999' , s:N3[1]   , 244 , s:N3[3] , '' ]

" Tabline
let s:TN  = s:N2 " normal buffers
let s:TM  = [ '#870000', '#ff8700',  88, 208, 'bold' ] " modified buffers
let s:TMU = [ '#ff8700', '#870000', 208,  88, 'bold' ] " modified unselected buffers
let s:TH  = [ s:N1[1], s:N1[0], s:N1[3], s:N1[2] ]     " hidden buffers

let g:airline#themes#desertink#palette = {}

let g:airline#themes#desertink#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#desertink#palette.normal_modified = {
      \ 'airline_a': s:TM,
      \ 'airline_z': s:TM }

let g:airline#themes#desertink#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:N3)
let g:airline#themes#desertink#palette.insert_replace = {
      \ 'airline_a': [ s:RE[0]   , s:I1[1]   , s:RE[1]   , s:I1[3]   , ''     ],
      \ 'airline_z': [ s:RE[0]   , s:I1[1]   , s:RE[1]   , s:I1[3]   , ''     ] }

let g:airline#themes#desertink#palette.visual = {
      \ 'airline_a': [ s:V1[0]   , s:V1[1]   , s:V1[2]   , s:V1[3]   , ''     ],
      \ 'airline_z': [ s:V1[0]   , s:V1[1]   , s:V1[2]   , s:V1[3]   , ''     ] }

let g:airline#themes#desertink#palette.replace = copy(airline#themes#desertink#palette.normal)
let g:airline#themes#desertink#palette.replace.airline_a = [ s:RE[0] , s:RE[1] , s:RE[2] , s:RE[3] , '' ]
let g:airline#themes#desertink#palette.replace.airline_z = [ s:RE[0] , s:RE[1] , s:RE[2] , s:RE[3] , '' ]

let g:airline#themes#desertink#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)

let g:airline#themes#desertink#palette.tabline = {
      \ 'airline_tab': s:TH,
      \ 'airline_tabmod': s:TM,
      \ 'airline_tabmod_unsel': s:TMU,
      \ 'airline_tabhid': s:TN }
