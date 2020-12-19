" vim-airline template by ronald2wing (https://github.com/ronald2wing)
" Base 16 Gruvbox Dark Hard Scheme by Dawid Kurek (https://github.com/dawikur)
let g:airline#themes#base16_gruvbox_dark_hard#palette = {}
let s:gui00 = "#1d2021"
let s:gui01 = "#3c3836"
let s:gui02 = "#504945"
let s:gui03 = "#665c54"
let s:gui04 = "#bdae93"
let s:gui05 = "#d5c4a1"
let s:gui06 = "#ebdbb2"
let s:gui07 = "#fbf1c7"
let s:gui08 = "#fb4934"
let s:gui09 = "#fe8019"
let s:gui0A = "#fabd2f"
let s:gui0B = "#b8bb26"
let s:gui0C = "#8ec07c"
let s:gui0D = "#83a598"
let s:gui0E = "#d3869b"
let s:gui0F = "#d65d0e"

let s:cterm00 = 234
let s:cterm01 = 235
let s:cterm02 = 236
let s:cterm03 = 240
let s:cterm04 = 143
let s:cterm05 = 187
let s:cterm06 = 223
let s:cterm07 = 230
let s:cterm08 = 203
let s:cterm09 = 208
let s:cterm0A = 214
let s:cterm0B = 142
let s:cterm0C = 108
let s:cterm0D = 108
let s:cterm0E = 175
let s:cterm0F = 166

let s:N1   = [ s:gui01, s:gui0B, s:cterm01, s:cterm0B ]
let s:N2   = [ s:gui06, s:gui02, s:cterm06, s:cterm02 ]
let s:N3   = [ s:gui09, s:gui01, s:cterm09, s:cterm01 ]
let g:airline#themes#base16_gruvbox_dark_hard#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

let s:I1   = [ s:gui01, s:gui0D, s:cterm01, s:cterm0D ]
let s:I2   = [ s:gui06, s:gui02, s:cterm06, s:cterm02 ]
let s:I3   = [ s:gui09, s:gui01, s:cterm09, s:cterm01 ]
let g:airline#themes#base16_gruvbox_dark_hard#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)

let s:R1   = [ s:gui01, s:gui08, s:cterm01, s:cterm08 ]
let s:R2   = [ s:gui06, s:gui02, s:cterm06, s:cterm02 ]
let s:R3   = [ s:gui09, s:gui01, s:cterm09, s:cterm01 ]
let g:airline#themes#base16_gruvbox_dark_hard#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)

let s:V1   = [ s:gui01, s:gui0E, s:cterm01, s:cterm0E ]
let s:V2   = [ s:gui06, s:gui02, s:cterm06, s:cterm02 ]
let s:V3   = [ s:gui09, s:gui01, s:cterm09, s:cterm01 ]
let g:airline#themes#base16_gruvbox_dark_hard#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)

let s:IA1   = [ s:gui05, s:gui01, s:cterm05, s:cterm01 ]
let s:IA2   = [ s:gui05, s:gui01, s:cterm05, s:cterm01 ]
let s:IA3   = [ s:gui05, s:gui01, s:cterm05, s:cterm01 ]
let g:airline#themes#base16_gruvbox_dark_hard#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)

" Here we define the color map for ctrlp.  We check for the g:loaded_ctrlp
" variable so that related functionality is loaded iff the user is using
" ctrlp. Note that this is optional, and if you do not define ctrlp colors
" they will be chosen automatically from the existing palette.
if !get(g:, 'loaded_ctrlp', 0)
  finish
endif
let g:airline#themes#base16_gruvbox_dark_hard#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
      \ [ s:gui07, s:gui02, s:cterm07, s:cterm02, '' ],
      \ [ s:gui07, s:gui04, s:cterm07, s:cterm04, '' ],
      \ [ s:gui05, s:gui01, s:cterm05, s:cterm01, 'bold' ])
