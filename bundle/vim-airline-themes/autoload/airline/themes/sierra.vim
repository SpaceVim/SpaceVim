" File: sierra.vim
" Author: Danilo Augusto <daniloaugusto.ita16@gmail.com>
" Date: 2017-02-26
" License:  MIT

let s:gui00 = "#303030" " ANSI Black
let s:gui01 = "#af5f5f" " ANSI Red
let s:gui02 = "#d75f5f" " ANSI Green
let s:gui03 = "#afd7d7" " ANSI Yellow
let s:gui04 = "#af8787" " ANSI Blue
let s:gui05 = "#dfaf87" " ANSI Magenta
let s:gui06 = "#ffafaf" " ANSI Cyan
let s:gui07 = "#f7e4c0" " ANSI White
let s:gui08 = "#686868"
let s:gui09 = "#af5f5f"
let s:gui0A = "#d75f5f"
let s:gui0B = "#afd7d7"
let s:gui0C = "#af8787"
let s:gui0D = "#dfaf87"
let s:gui0E = "#ffb2af"
let s:gui0F = "#ffffff"

let s:cterm00 = "236"
let s:cterm01 = "131"
let s:cterm02 = "167"
let s:cterm03 = "152"
let s:cterm04 = "138"
let s:cterm05 = "180"
let s:cterm06 = "217"
let s:cterm07 = "222"
let s:cterm08 = "242"
let s:cterm09 = "131"
let s:cterm0A = "167"
let s:cterm0B = "152"
let s:cterm0C = "138"
let s:cterm0D = "180"
let s:cterm0E = "217"
let s:cterm0F = "231"

let s:guiWhite = "#ffffff"
let s:guiGray = "#666666"
let s:guiDarkGray = "#545454"
let s:guiAlmostBlack = "#2a2a2a"
let s:ctermWhite = "231"
let s:ctermGray = "243"
let s:ctermDarkGray = "240"
let s:ctermAlmostBlack = "235"

let g:airline#themes#sierra#palette = {}
let s:modified = { 'airline_c': [s:gui07, '', s:cterm07, '', ''] }

" Normal mode
let s:N1 = [s:guiWhite, s:gui0D, s:ctermWhite, s:cterm0D]
let s:N2 = [s:guiWhite, s:gui01, s:ctermWhite, s:cterm01]
let s:N3 = [s:gui02, s:guiDarkGray, s:cterm02, s:ctermDarkGray]
let g:airline#themes#sierra#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#sierra#palette.normal_modified = s:modified

" Insert mode
let s:I1 = [s:guiWhite, s:gui0B, s:ctermWhite, s:cterm0B]
let s:I2 = s:N2
let s:I3 = [s:guiWhite, s:gui01, s:ctermWhite, s:cterm01]
let g:airline#themes#sierra#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#sierra#palette.insert_modified = s:modified

" Visual mode
let s:V1 = [s:guiWhite, s:gui08, s:ctermWhite, s:cterm08]
let s:V2 = s:N2
let s:V3 = s:I3
let g:airline#themes#sierra#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#sierra#palette.visual_modified = s:modified

" Replace mode
let s:R1 = [s:gui08, s:gui00, s:cterm08, s:cterm00]
let s:R2 = s:N2
let s:R3 = s:I3
let g:airline#themes#sierra#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)
let g:airline#themes#sierra#palette.replace_modified = s:modified

" Inactive mode
let s:IN1 = [s:guiGray, s:gui01, s:ctermGray, s:cterm01]
let s:IN2 = [s:gui02, s:guiAlmostBlack, s:cterm02, s:ctermAlmostBlack]
let s:IN3 = [s:gui02, s:guiAlmostBlack, s:cterm02, s:ctermAlmostBlack]
let g:airline#themes#sierra#palette.inactive = airline#themes#generate_color_map(s:IN1, s:IN2, s:IN3)
let g:airline#themes#sierra#palette.inactive_modified = s:modified

" CtrlP
if !get(g:, 'loaded_ctrlp', 0)
    finish
endif

let s:CP1 = [s:guiWhite, s:gui01, s:ctermWhite, s:cterm01]
let s:CP2 = [s:guiWhite, s:gui03, s:ctermWhite, s:cterm01]
let s:CP3 = [s:guiWhite, s:gui0D, s:ctermWhite, s:cterm0D]
