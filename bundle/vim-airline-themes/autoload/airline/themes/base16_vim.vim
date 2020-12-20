let g:airline#themes#base16_vim#palette = {}

function! airline#themes#base16_vim#refresh()
  let s:improved_contrast = get(g:, 'airline_base16_improved_contrast', 0)
  let s:monotone = get(g:, 'airline_base16_monotone', 0)
        \ || get(g:, 'airline_base16_solarized', 0)

  if exists('g:base16_gui00')
    " base16-vim provides values that we can load dynamically

    " Base16 term color palette
    let s:base00 = g:base16_cterm00  " black
    let s:base01 = g:base16_cterm01
    let s:base02 = g:base16_cterm02
    let s:base03 = g:base16_cterm03  " brblack
    let s:base04 = g:base16_cterm04
    let s:base05 = g:base16_cterm05  " white
    let s:base06 = g:base16_cterm06
    let s:base07 = g:base16_cterm07
    let s:base08 = g:base16_cterm08  " red
    let s:base09 = g:base16_cterm09
    let s:base0A = g:base16_cterm0A  " yellow
    let s:base0B = g:base16_cterm0B  " green
    let s:base0C = g:base16_cterm0C  " cyan
    let s:base0D = g:base16_cterm0D  " blue
    let s:base0E = g:base16_cterm0E  " magenta
    let s:base0F = g:base16_cterm0F

    " Gui color palette
    let s:gui00 = "#" . g:base16_gui00
    let s:gui01 = "#" . g:base16_gui01
    let s:gui02 = "#" . g:base16_gui02
    let s:gui03 = "#" . g:base16_gui03
    let s:gui04 = "#" . g:base16_gui04
    let s:gui05 = "#" . g:base16_gui05
    let s:gui06 = "#" . g:base16_gui06
    let s:gui07 = "#" . g:base16_gui07
    let s:gui08 = "#" . g:base16_gui08
    let s:gui09 = "#" . g:base16_gui09
    let s:gui0A = "#" . g:base16_gui0A
    let s:gui0B = "#" . g:base16_gui0B
    let s:gui0C = "#" . g:base16_gui0C
    let s:gui0D = "#" . g:base16_gui0D
    let s:gui0E = "#" . g:base16_gui0E
    let s:gui0F = "#" . g:base16_gui0F
  else
    " Fallback: term colors should still be correct, but gui colors must be
    " hardcoded to a particular scheme.

    " Base16 term color palette
    let s:base00 = "00"  " black
    let s:base03 = "08"  " brblack
    let s:base05 = "07"  " white
    let s:base07 = "15"
    let s:base08 = "01"  " red
    let s:base0A = "03"  " yellow
    let s:base0B = "02"  " green
    let s:base0C = "06"  " cyan
    let s:base0D = "04"  " blue
    let s:base0E = "05"  " magenta
    if exists('g:base16colorspace') && g:base16colorspace == "256"
      let s:base01 = "18"
      let s:base02 = "19"
      let s:base04 = "20"
      let s:base06 = "21"
      let s:base09 = "16"
      let s:base0F = "17"
    else
      let s:base01 = "10"
      let s:base02 = "11"
      let s:base04 = "12"
      let s:base06 = "13"
      let s:base09 = "09"
      let s:base0F = "14"
    endif

    " Gui color palette (base16-default-dark)
    let s:gui00 = "#181818"
    let s:gui01 = "#282828"
    let s:gui02 = "#383838"
    let s:gui03 = "#585858"
    let s:gui04 = "#b8b8b8"
    let s:gui05 = "#d8d8d8"
    let s:gui06 = "#e8e8e8"
    let s:gui07 = "#f8f8f8"
    let s:gui08 = "#ab4642"
    let s:gui09 = "#dc9656"
    let s:gui0A = "#f7ca88"
    let s:gui0B = "#a1b56c"
    let s:gui0C = "#86c1b9"
    let s:gui0D = "#7cafc2"
    let s:gui0E = "#ba8baf"
    let s:gui0F = "#a16946"
  endif

  " Normal mode
  let s:N1 = [s:gui00, s:gui0B, s:base00, s:base0B]
  let s:N2 = [s:gui04, s:gui02, s:base04, s:base02]
  let s:N3 = [s:gui0B, s:gui01, s:base0B, s:base01]

  if s:improved_contrast
      let s:N2 = [s:gui05, s:gui02, s:base05, s:base02]
  endif

  if s:monotone
    let s:N1 = [s:gui01, s:gui04, s:base01, s:base04]
    let s:N2 = [s:gui00, s:gui02, s:base00, s:base02]
    let s:N3 = [s:gui04, s:gui01, s:base04, s:base01]
  endif

  let g:airline#themes#base16_vim#palette.normal
        \ = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
  let g:airline#themes#base16_vim#palette.normal_modified = {
        \ 'airline_c': [s:gui09, s:gui01, s:base09, s:base01, ''],
        \ }

  " Insert mode
  let s:I1 = [s:gui01, s:gui0D, s:base01, s:base0D]
  let s:I3 = [s:gui0D, s:gui01, s:base0D, s:base01]
  let g:airline#themes#base16_vim#palette.insert
        \ = airline#themes#generate_color_map(s:I1, s:N2, s:I3)

  if s:monotone
    let s:I1 = [s:gui01, s:gui0A, s:base01, s:base0A]
    let g:airline#themes#base16_vim#palette.insert
          \ = airline#themes#generate_color_map(s:I1, s:N2, s:N3)
  endif

  let g:airline#themes#base16_vim#palette.insert_modified
        \ = copy(g:airline#themes#base16_vim#palette.normal_modified)

  " Replace mode
  let s:R1 = [s:gui01, s:gui08, s:base01, s:base08]
  let s:R3 = [s:gui08, s:gui01, s:base08, s:base01]
  let g:airline#themes#base16_vim#palette.replace
        \ = airline#themes#generate_color_map(s:R1, s:N2, s:R3)

  if s:monotone
    let s:R1 = [s:gui01, s:gui09, s:base01, s:base09]
    let g:airline#themes#base16_vim#palette.replace
          \ = airline#themes#generate_color_map(s:R1, s:N2, s:N3)
  endif

  let g:airline#themes#base16_vim#palette.replace_modified
        \ = copy(g:airline#themes#base16_vim#palette.normal_modified)

  " Visual mode
  let s:V1 = [s:gui01, s:gui0E, s:base01, s:base0E]
  let s:V3 = [s:gui0E, s:gui01, s:base0E, s:base01]
  let g:airline#themes#base16_vim#palette.visual
        \ = airline#themes#generate_color_map(s:V1, s:N2, s:V3)

  if s:monotone
    let s:V1 = [s:gui01, s:gui0F, s:base01, s:base0F]
    let g:airline#themes#base16_vim#palette.visual
          \ = airline#themes#generate_color_map(s:V1, s:N2, s:N3)
  endif

  " Inactive window
  if s:improved_contrast
    let s:IA = [s:gui04, s:gui01, s:base04, s:base01, '']
  else
    let s:IA = [s:gui03, s:gui01, s:base03, s:base01, '']
  endif
  let g:airline#themes#base16_vim#palette.inactive
        \ = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
  let g:airline#themes#base16_vim#palette.inactive_modified = {
        \ 'airline_c': [s:gui09, '', s:base09, '', ''],
        \ }
endfunction

call airline#themes#base16_vim#refresh()
