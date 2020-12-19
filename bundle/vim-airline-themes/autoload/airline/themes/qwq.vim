" github: https://github.com/LuciusChen
scriptencoding utf-8

let g:airline#themes#qwq#palette = {}

" normalmode
let s:N1   = [ '#0E3B4F' , '#FFEEE5' , 17  , 190 ]
let s:N2   = [ '#0E3B4F' , '#FFD3CB' , 255 , 238 ]
let s:N3   = [ '#ffffff' , '#F7846E' , 85  , 234 ]
let s:N4   = [ '#ffffff' , '#FF5D4F' , 255 , 53  ]
let g:airline#themes#qwq#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#qwq#palette.normal_modified = { 'airline_c': [ s:N4[0], s:N4[1], s:N4[2], s:N4[3], '' ], }

" insertmode
let s:I1 = [ '#0E3B4F' , '#FFF5D9' , 17  , 45 ]
let s:I2 = [ '#0E3B4F' , '#DDE58E' , 255 , 27 ]
let s:I3 = [ '#ffffff' , '#9ED47B' , 15  , 17 ]
let s:I4 = [ '#ffffff' , '#6BAD3F' , 255 , 53 ]
let s:I5 = [ '#ffffff' , '#6BAD3F' , 17  , 172 ]
let g:airline#themes#qwq#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#qwq#palette.insert_modified = { 'airline_c': [ s:I4[0], s:I4[1], s:I4[2], s:I4[3], '' ], }
let g:airline#themes#qwq#palette.insert_paste = { 'airline_a': [ s:I5[0], s:I5[2], s:I5[2], s:I5[3], '' ], }

" replacemode
let s:R1 = [ '#0E3B4F' , '#C1F9CD' , 17  , 45  ]
let s:R2 = [ '#0E3B4F' , '#8BEFC7' , 255 , 27  ]
let s:R3 = [ '#ffffff' , '#04BEC3' , 15  , 17  ]
let s:R4 = [ '#ffffff' , '#008492' , 255 , 53  ]
let g:airline#themes#qwq#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)
let g:airline#themes#qwq#palette.replace.airline_a = [ s:R1[0], s:R1[1], s:R2[2], 124, '']
let g:airline#themes#qwq#palette.replace_modified = { 'airline_c': [ s:R4[0], s:R4[1], s:R4[2], s:R4[3], '' ], }


" visualmode
let s:V1 = [ '#0E3B4F' , '#FFEEE5' , 232 , 214 ]
let s:V2 = [ '#0E3B4F' , '#FF9DA5' , 232 , 202 ]
let s:V3 = [ '#ffffff' , '#FF5B6F' , 15  , 52  ]
let s:V4 = [ '#ffffff' , '#FF003F' , 255  , 53  ]
let g:airline#themes#qwq#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#qwq#palette.visual_modified = { 'airline_c': [ s:V4[0], s:V4[1], s:V4[2], s:V4[3], '' ], }

" inactive
let s:IA1 = [ '#0E3B4F' , '#FEFCF9' , 239 , 234 , '' ]
let s:IA2 = [ '#0E3B4F' , '#DDC6AF' , 239 , 235 , '' ]
let s:IA3 = [ '#ffffff' , '#A28E79' , 239 , 236 , '' ]
let g:airline#themes#qwq#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)
let g:airline#themes#qwq#palette.inactive_modified = { 'airline_c': [ '#ffffff', '', 97, '', '' ], }

let g:airline#themes#qwq#palette.accents = { 'red': [ '#ffffff', '', 160, '' ] }

" Here we define the color map for ctrlp.  We check for the g:loaded_ctrlp
" variable so that related functionality is loaded iff the user is using
" ctrlp. Note that this is optional, and if you do not define ctrlp colors
" they will be chosen automatically from the existing palette.
if !get(g:, 'loaded_ctrlp', 0)
  finish
endif
let s:C1 = [ '#0E3B4F' , '#FEFCF9' , 189 , 55  , '' ]
let s:C2 = [ '#0E3B4F' , '#DDC6AF' , 231 , 98  , '' ]
let s:C3 = [ '#ffffff' , '#B9A695' , 55  , 231 , '' ]
let g:airline#themes#qwq#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(s:C1, s:C2, s:C3)
