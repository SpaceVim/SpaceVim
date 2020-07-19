" Name: Solarized Flood
" Changed: June 3 2018
" Maintainer: https://github.com/Neur1n
" Description:
"   A vim-airline theme made based on and tested with the Solarized colorscheme
"   (https://github.com/frankier/neovim-colors-solarized-truecolor-only) in
"   Windows 10 OS and GVim 8.1.
"
"   This script is based on the 'dark' theme. The 'inactive' and 'ctrlp' parts
"   were not changed.
"
"   It is call 'flood' since the statusline and the tabline will be highlighted
"   with the 'base03' color in Solarized (dark). If you use the dark Solarized
"   colorscheme for Vim and, in Windows, set 'Personalization-Colors-Choose
"   your color - Custom color' to be '#002B36' (*), then most parts of the GVim
"   window will be 'flooded' with the color.
"   NOTE: This will make some components of the airline less distinguishable
"         from the others. If anyone has better ideas, I will be happy to take
"         a conversation with you. :)

"   (*): Your PC may not support the exact color but it will pick the nearest
"        color for you and it should work fine.


scriptencoding utf-8

" The following color definitions:
"   'hex':  originated from official solarized (dark) colors
"   'term': calculated by 'x256' package of Python
"   '*':    'term' value that is different with solarized official definition
"   '#':    picked manually
let s:base03  = {'hex': '#002B36', 'term': 234}  "   0,  43,  54
let s:base02  = {'hex': '#073642', 'term': 235}  "   7,  54,  66
let s:base01  = {'hex': '#586E75', 'term': 242}  "  88, 110, 117 *
let s:base00  = {'hex': '#657B83', 'term':  66}  " 101, 123, 131 *

let s:base0   = {'hex': '#839496', 'term': 246}  " 131, 148, 150 *
let s:base1   = {'hex': '#93A1A1', 'term': 247}  " 147, 161, 161 *
let s:base2   = {'hex': '#EEE8D5', 'term': 254}  " 238, 232, 213
let s:base3   = {'hex': '#FDF6E3', 'term': 230}  " 253, 246, 227

let s:yellow  = {'hex': '#B58900', 'term': 136}  " 181, 137,   0
let s:orange  = {'hex': '#CB4B16', 'term': 166}  " 203,  75,  22
let s:red     = {'hex': '#DC322F', 'term': 160}  " 220,  50,  47 *
let s:magenta = {'hex': '#D33682', 'term': 168}  " 211,  54, 130 *
let s:violet  = {'hex': '#6C71C4', 'term':  62}  " 108, 113, 196 *
let s:blue    = {'hex': '#268BD2', 'term':  32}  "  38, 139, 210 *
let s:cyan    = {'hex': '#2AA198', 'term':  36}  "  42, 161, 152 *
let s:green   = {'hex': '#859900', 'term': 106}  " 133, 153,   0 #

let g:airline#themes#solarized_flood#palette = {}


" *****************************************************************************
"                                                                   Normal Mode
" *****************************************************************************
let s:airline_a_normal = [s:base03['hex'],  s:green['hex'],
                        \ s:base03['term'], s:green['term'], 'italic']

let s:airline_b_normal = [s:base1['hex'],  s:base03['hex'],
                        \ s:base1['term'], s:base03['term'], 'italic']

let s:airline_c_normal = [s:cyan['hex'],  s:base03['hex'],
                        \ s:cyan['term'], s:base03['term'], 'italic']

let g:airline#themes#solarized_flood#palette.normal =
      \ airline#themes#generate_color_map(s:airline_a_normal,
                                        \ s:airline_b_normal,
                                        \ s:airline_c_normal)

let g:airline#themes#solarized_flood#palette.normal['airline_z'] =
      \ [s:green['hex'], s:base03['hex'], s:green['term'], s:base03['term'],
       \ 'italic']

let g:airline#themes#solarized_flood#palette.normal_modified = {
      \ 'airline_c': [s:magenta['hex'], s:base03['hex'],
                    \ s:magenta['term'], s:base03['term'], 'italic'],
      \ }

" *****************************************************************************
"                                                                   Insert Mode
" *****************************************************************************
let s:airline_a_insert = [s:base03['hex'] , s:cyan['hex'],
                        \ s:base03['term'], s:cyan['term'], 'bold']

let s:airline_b_insert = [s:base1['hex'],  s:base03['hex'],
                        \ s:base1['term'], s:base03['term'], 'bold']

let s:airline_c_insert = [s:blue['hex'],  s:base03['hex'],
                        \ s:blue['term'], s:base03['term'], 'bold']

let g:airline#themes#solarized_flood#palette.insert =
      \ airline#themes#generate_color_map(s:airline_a_insert,
                                        \ s:airline_b_insert,
                                        \ s:airline_c_insert)

let g:airline#themes#solarized_flood#palette.insert['airline_z'] =
      \ [s:cyan['hex'], s:base03['hex'], s:cyan['term'], s:base03['term'],
       \ 'bold']

let g:airline#themes#solarized_flood#palette.insert_modified = {
      \ 'airline_c': [s:magenta['hex'],  s:base03['hex'],
                    \ s:magenta['term'], s:base03['term'], 'bold'],
      \ }

let g:airline#themes#solarized_flood#palette.insert_paste = {
      \ 'airline_a': [s:base03['hex'],  s:orange['hex'],
                    \ s:base03['term'], s:orange['term'], 'bold'],
      \ }

" *****************************************************************************
"                                                                  Replace Mode
" *****************************************************************************
let g:airline#themes#solarized_flood#palette.replace =
      \ copy(g:airline#themes#solarized_flood#palette.insert)

let g:airline#themes#solarized_flood#palette.replace.airline_a =
      \ [s:base03['hex'], s:red['hex'], s:base03['term'], s:red['term'], 'bold']

let g:airline#themes#solarized_flood#palette.replace_modified =
      \ g:airline#themes#solarized_flood#palette.insert_modified

" *****************************************************************************
"                                                                   Visual Mode
" *****************************************************************************
let s:airline_a_visual = [s:base03['hex'],  s:yellow['hex'],
                        \ s:base03['term'], s:yellow['term'], 'italic']

let s:airline_b_visual = [s:base1['hex'],  s:base03['hex'],
                        \ s:base1['term'], s:base03['term'], 'italic']

let s:airline_c_visual = [s:red['hex'],  s:base03['hex'],
                        \ s:red['term'], s:base03['term'], 'italic']

let g:airline#themes#solarized_flood#palette.visual =
      \ airline#themes#generate_color_map(s:airline_a_visual,
                                        \ s:airline_b_visual,
                                        \ s:airline_c_visual)

let g:airline#themes#solarized_flood#palette.visual['airline_z'] =
      \ [s:yellow['hex'], s:base03['hex'], s:yellow['term'], s:base03['term'],
       \ 'italic']

let g:airline#themes#solarized_flood#palette.visual_modified = {
      \ 'airline_c': [s:magenta['hex'],  s:base03['hex'],
                    \ s:magenta['term'], s:base03['term'], 'italic'],
      \ }

" *****************************************************************************
"                                                                 Inactive Mode
" *****************************************************************************
let s:airline_a_inactive = ['#4e4e4e', '#1c1c1c', 239, 234, '']
let s:airline_b_inactive = ['#4e4e4e', '#262626', 239, 235, '']
let s:airline_c_inactive = ['#4e4e4e', '#303030', 239, 236, '']
let g:airline#themes#solarized_flood#palette.inactive =
      \ airline#themes#generate_color_map(s:airline_a_inactive,
                                        \ s:airline_b_inactive,
                                        \ s:airline_c_inactive)
let g:airline#themes#solarized_flood#palette.inactive_modified = {
      \ 'airline_c': ['#875faf', '', 97, '', ''] ,
      \ }


let g:airline#themes#solarized_flood#palette.accents = {
      \ 'red': [s:red['hex'], '', s:red['term'], '']
      \ }


if get(g:, 'loaded_ctrlp', 0)
  let g:airline#themes#solarized_flood#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
        \ [ '#d7d7ff', '#5f00af', 189, 55 , ''    ],
        \ [ '#ffffff', '#875fd7', 231, 98 , ''    ],
        \ [ '#5f00af', '#ffffff', 55 , 231, 'bold'])
endif
