" Color palette
let s:guiShadow      = "#3b3a32" " shadow
let s:guiDarkGray    = "#49483e" " dark gray
let s:guiBgPurple    = "#8076aa" " background purple
let s:guiGray        = "#49483e" " gray
let s:guiViolet      = "#63588d" " violet
let s:guiDustyLilac  = "#efe6ff" "dusty-lilac
let s:guiSeafoam     = "#c2ffdf" "seafoam
let s:guiSilver      = "#f8f8f0" "silver
let s:guiFuschia     = "#f92672" "fuschia
let s:guiPeach       = "#ff857f" "peach
let s:guiGold        = "#e6c000" "gold
let s:guiDarkSeafoam = "#80ffbd" "dark-seafoam
let s:guiLilac       = "#c5a3ff" "lilac
let s:guiLavender    = "#ae81ff" "lavender
let s:guiRose        = "#ffb8d1" "rose
let s:guiGoldenrod   = "#fffea0" "goldenrod

let s:ctermShadow      = "233"
let s:ctermDarkGray    = "235"
let s:ctermBgPurple    = "59"
let s:cterm03          = "66"
let s:cterm04          = "145"
let s:cterm05          = "152"
let s:cterm06          = "188"
let s:ctermSilver      = "189"
let s:ctermFuschia     = "88"
let s:cterm09          = "209"
let s:cterm0A          = "221"
let s:ctermDarkSeafoam = "22"
let s:cterm0C          = "73"
let s:ctermLavender    = "25"
let s:cterm0E          = "176"
let s:cterm0F          = "137"

let s:guiWhite = "#f8f8f0"
let s:guiGray = "#8076aa"
let s:ctermWhite = "231"
let s:ctermGray = "243"

let g:airline#themes#fairyfloss#palette = {}
let s:modified = { 'airline_c': [ s:guiRose, '', 215, '', '' ] }

" Normal mode
let s:N1 = [ s:guiSilver , s:guiLavender , s:ctermSilver , s:ctermLavender  ]
let s:N2 = [ s:guiWhite , s:guiDarkGray , s:ctermWhite , s:ctermDarkGray  ]
let s:N3 = [ s:guiShadow , s:guiLavender , s:ctermBgPurple , s:ctermShadow  ]
let g:airline#themes#fairyfloss#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#fairyfloss#palette.normal_modified = s:modified

" Insert mode
let s:I1 = [ s:guiDarkGray , s:guiDarkSeafoam , s:ctermWhite , s:ctermDarkSeafoam  ]
let s:I2 = s:N2
let s:I3 = [ s:guiWhite , s:guiDarkGray , s:ctermWhite , s:ctermShadow  ]
let g:airline#themes#fairyfloss#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#fairyfloss#palette.insert_modified = s:modified

" Visual mode
let s:V1 = [ s:guiWhite , s:guiFuschia , s:ctermWhite , s:ctermFuschia ]
let s:V2 = s:N2
let s:V3 = s:I3
let g:airline#themes#fairyfloss#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#fairyfloss#palette.visual_modified = s:modified

" Replace mode
let s:R1 = [ s:guiFuschia , s:guiDarkGray , s:ctermFuschia, s:ctermShadow ]
let s:R2 = s:N2
let s:R3 = s:I3
let g:airline#themes#fairyfloss#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)
let g:airline#themes#fairyfloss#palette.replace_modified = s:modified

" Inactive mode
let s:IN1 = [ s:guiGray , s:guiDarkGray , s:ctermGray , s:ctermDarkGray ]
let s:IN2 = [ s:guiBgPurple , s:guiShadow , s:ctermBgPurple , s:ctermShadow ]
let s:IN3 = [ s:guiBgPurple , s:guiShadow , s:ctermBgPurple , s:ctermShadow ]
let g:airline#themes#fairyfloss#palette.inactive = airline#themes#generate_color_map(s:IN1, s:IN2, s:IN3)
let g:airline#themes#fairyfloss#palette.inactive_modified = s:modified

" CtrlP
if !get(g:, 'loaded_ctrlp', 0)
  finish
endif

let s:CP1 = [ s:guiWhite , s:guiDarkGray , s:ctermWhite , s:ctermDarkGray  ]
let s:CP2 = [ s:guiWhite , s:guiGray , s:ctermWhite , s:ctermDarkGray  ]
let s:CP3 = [ s:guiWhite , s:guiLavender , s:ctermWhite , s:ctermLavender  ]

let g:airline#themes#fairyfloss#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(s:CP1, s:CP2, s:CP3)
