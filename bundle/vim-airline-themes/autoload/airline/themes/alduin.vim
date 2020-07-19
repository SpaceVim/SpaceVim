" Author:   Danilo Augusto
" Script:   Alduin (vim-airline version)
" License:  MIT

let s:gui00 = "#1c1c1c" " ANSI Black
let s:gui01 = "#af8787" " ANSI Red
let s:gui02 = "#dfaf87" " ANSI Green
let s:gui03 = "#878787" " ANSI Yellow
let s:gui04 = "#af5f5f" " ANSI Blue
let s:gui05 = "#875f5f" " ANSI Magenta
let s:gui06 = "#87afaf" " ANSI Cyan
let s:gui07 = "#ffdf87" " ANSI White
let s:gui08 = "#87875f"
let s:gui09 = "#af1600"
let s:gui0A = "#af875f"
let s:gui0B = "#878787"
let s:gui0C = "#af5f00"
let s:gui0D = "#5f5f87"
let s:gui0E = "#afd7d7"
let s:gui0F = "#dfdfaf"

let s:cterm00 = "234"
let s:cterm01 = "138"
let s:cterm02 = "180"
let s:cterm03 = "102"
let s:cterm04 = "131"
let s:cterm05 = "95"
let s:cterm06 = "109"
let s:cterm07 = "222"
let s:cterm08 = "101"
let s:cterm09 = "138"
let s:cterm0A = "180"
let s:cterm0B = "102"
let s:cterm0C = "130"
let s:cterm0D = "60"
let s:cterm0E = "152"
let s:cterm0F = "187"

let s:guiWhite = "#ffffff"
let s:guiGray = "#666666"
let s:guiDarkGray = "#545454"
let s:guiAlmostBlack = "#2a2a2a"
let s:ctermWhite = "231"
let s:ctermGray = "243"
let s:ctermDarkGray = "240"
let s:ctermAlmostBlack = "235"

let g:airline#themes#alduin#palette = {}
let s:modified = { 'airline_c': [s:gui07, '', s:cterm07, '', ''] }

" Normal mode
let s:N1 = [s:gui07, s:gui0D, s:cterm07, s:cterm0D]
let s:N2 = [s:guiWhite, s:gui01, s:ctermWhite, s:cterm01]
let s:N3 = [s:gui02, s:guiDarkGray, s:cterm02, s:ctermDarkGray]
let g:airline#themes#alduin#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#alduin#palette.normal_modified = s:modified

" Insert mode
let s:I1 = [s:guiWhite, s:gui0B, s:ctermWhite, s:cterm0B]
let s:I2 = s:N2
let s:I3 = [s:guiWhite, s:gui01, s:ctermWhite, s:cterm01]
let g:airline#themes#alduin#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#alduin#palette.insert_modified = s:modified

" Visual mode
let s:V1 = [s:guiWhite, s:gui08, s:ctermWhite, s:cterm08]
let s:V2 = s:N2
let s:V3 = s:I3
let g:airline#themes#alduin#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#alduin#palette.visual_modified = s:modified

" Replace mode
let s:R1 = [s:gui08, s:gui00, s:cterm08, s:cterm00]
let s:R2 = s:N2
let s:R3 = s:I3
let g:airline#themes#alduin#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)
let g:airline#themes#alduin#palette.replace_modified = s:modified

" Inactive mode
let s:IN1 = [s:guiGray, s:gui01, s:ctermGray, s:cterm01]
let s:IN2 = [s:gui02, s:guiAlmostBlack, s:cterm02, s:ctermAlmostBlack]
let s:IN3 = [s:gui02, s:guiAlmostBlack, s:cterm02, s:ctermAlmostBlack]
let g:airline#themes#alduin#palette.inactive = airline#themes#generate_color_map(s:IN1, s:IN2, s:IN3)
let g:airline#themes#alduin#palette.inactive_modified = s:modified

" CtrlP
if !get(g:, 'loaded_ctrlp', 0)
  finish
endif

let s:CP1 = [s:guiWhite, s:gui01, s:ctermWhite, s:cterm01]
let s:CP2 = [s:guiWhite, s:gui03, s:ctermWhite, s:cterm01]
let s:CP3 = [s:guiWhite, s:gui0D, s:ctermWhite, s:cterm0D]
let g:airline#themes#alduin#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
      \ s:CP1,
      \ s:CP2,
      \ s:CP3)
