" Airline theme for Seabird/Seagull:
" https://github.com/nightsense/seabird/blob/master/colors/seagull.vim
"
" Based on Solarized theme code:
" https://github.com/vim-airline/vim-airline-themes/blob/master/autoload/airline/themes/solarized.vim
let g:airline#themes#seagull#palette = {}

function! airline#themes#seagull#refresh()
  """"""""""""""""""""""""""""""""""""""""""""""""
  " Options
  """"""""""""""""""""""""""""""""""""""""""""""""
  let s:background           = get(g:, 'airline_seagull_bg', &background)
  let s:ansi_colors          = get(g:, 'seagull_termcolors', 16) != 256 && &t_Co >= 16 ? 1 : 0
  let s:use_green            = get(g:, 'airline_seagull_normal_green', 0)
  let s:dark_inactive_border = get(g:, 'airline_seagull_dark_inactive_border', 0)
  let s:tty                  = &t_Co == 8

  """"""""""""""""""""""""""""""""""""""""""""""""
  " Colors
  """"""""""""""""""""""""""""""""""""""""""""""""
  " Base colors
  let s:base03  = {'t': 234, 'g': '#0b141a'}
  let s:base02  = {'t': 235, 'g': '#1d252b'}
  let s:base01  = {'t': 240, 'g': '#61707a'}
  let s:base00  = {'t': 241, 'g': '#6d767d'}
  let s:base0   = {'t': 244, 'g': '#787e82'}
  let s:base1   = {'t': 245, 'g': '#808487'}
  let s:base2   = {'t': 254, 'g': '#e6eaed'}
  let s:base3   = {'t': 230, 'g': '#ffffff'}
  let s:yellow  = {'t': 136, 'g': '#bf8c00'}
  let s:orange  = {'t': 166, 'g': '#ff6200'}
  let s:red     = {'t': 160, 'g': '#ff4053'}
  let s:magenta = {'t': 125, 'g': '#ff549b'}
  let s:violet  = {'t': 61,  'g': '#9854ff'}
  let s:blue    = {'t': 33,  'g': '#0099ff'}
  let s:cyan    = {'t': 37,  'g': '#00a5ab'}
  let s:green   = {'t': 64,  'g': '#11ab00'}

  """"""""""""""""""""""""""""""""""""""""""""""""
  " Simple mappings
  " NOTE: These are easily tweakable mappings. The actual mappings get
  " the specific gui and terminal colors from the base color dicts.
  """"""""""""""""""""""""""""""""""""""""""""""""
  " Normal mode
  if s:background == 'dark'
    let s:N1 = [s:base3, (s:use_green ? s:green : s:base1), 'bold']
    let s:N2 = [s:base2, (s:tty ? s:base01 : s:base00), '']
    let s:N3 = [s:base01, s:base02, '']
  else
    let s:N1 = [s:base2, (s:use_green ? s:green : s:base00), 'bold']
    let s:N2 = [(s:tty ? s:base01 : s:base2), s:base1, '']
    let s:N3 = [s:base1, s:base2, '']
  endif
  let s:NF = [s:orange, s:N3[1], '']
  let s:NW = [s:base3, s:orange, '']
  if s:background == 'dark'
    let s:NM = [s:base1, s:N3[1], '']
    let s:NMi = [s:base2, s:N3[1], '']
  else
    let s:NM = [s:base01, s:N3[1], '']
    let s:NMi = [s:base02, s:N3[1], '']
  endif

  " Insert mode
  let s:I1 = [s:N1[0], s:cyan, 'bold']
  let s:I2 = s:N2
  let s:I3 = s:N3
  let s:IF = s:NF
  let s:IM = s:NM

  " Visual mode
  let s:V1 = [s:N1[0], s:green, 'bold']
  let s:V2 = s:N2
  let s:V3 = s:N3
  let s:VF = s:NF
  let s:VM = s:NM

  " Replace mode
  let s:R1 = [s:N1[0], s:red, '']
  let s:R2 = s:N2
  let s:R3 = s:N3
  let s:RM = s:NM
  let s:RF = s:NF

  " Inactive, according to VertSplit in seagull
  " (bg dark: base00; bg light: base0)
  if s:background == 'dark'
    if s:dark_inactive_border
      let s:IA = [s:base01, s:base02, '']
    else
      let s:IA = [s:base02, s:base00, '']
    endif
  else
    let s:IA = [s:base2, s:base0, '']
  endif

  """"""""""""""""""""""""""""""""""""""""""""""""
  " Actual mappings
  " WARNING: Don't modify this section unless necessary.
  """"""""""""""""""""""""""""""""""""""""""""""""
  let s:NFa = [s:NF[0].g, s:NF[1].g, s:NF[0].t, s:NF[1].t, s:NF[2]]
  let s:IFa = [s:IF[0].g, s:IF[1].g, s:IF[0].t, s:IF[1].t, s:IF[2]]
  let s:VFa = [s:VF[0].g, s:VF[1].g, s:VF[0].t, s:VF[1].t, s:VF[2]]
  let s:RFa = [s:RF[0].g, s:RF[1].g, s:RF[0].t, s:RF[1].t, s:RF[2]]

  let g:airline#themes#seagull#palette.accents = {
        \ 'red': s:NFa,
        \ }

  let g:airline#themes#seagull#palette.inactive = airline#themes#generate_color_map(
        \ [s:IA[0].g, s:IA[1].g, s:IA[0].t, s:IA[1].t, s:IA[2]],
        \ [s:IA[0].g, s:IA[1].g, s:IA[0].t, s:IA[1].t, s:IA[2]],
        \ [s:IA[0].g, s:IA[1].g, s:IA[0].t, s:IA[1].t, s:IA[2]])
  let g:airline#themes#seagull#palette.inactive_modified = {
        \ 'airline_c': [s:NMi[0].g, '', s:NMi[0].t, '', s:NMi[2]]}

  let g:airline#themes#seagull#palette.normal = airline#themes#generate_color_map(
        \ [s:N1[0].g, s:N1[1].g, s:N1[0].t, s:N1[1].t, s:N1[2]],
        \ [s:N2[0].g, s:N2[1].g, s:N2[0].t, s:N2[1].t, s:N2[2]],
        \ [s:N3[0].g, s:N3[1].g, s:N3[0].t, s:N3[1].t, s:N3[2]])

  let g:airline#themes#seagull#palette.normal.airline_warning = [
        \ s:NW[0].g, s:NW[1].g, s:NW[0].t, s:NW[1].t, s:NW[2]]

  let g:airline#themes#seagull#palette.normal.airline_error = [
        \ s:NW[0].g, s:NW[1].g, s:NW[0].t, s:NW[1].t, s:NW[2]]

  let g:airline#themes#seagull#palette.normal_modified = {
        \ 'airline_c': [s:NM[0].g, s:NM[1].g,
        \ s:NM[0].t, s:NM[1].t, s:NM[2]]}

  let g:airline#themes#seagull#palette.normal_modified.airline_warning =
        \ g:airline#themes#seagull#palette.normal.airline_warning

  let g:airline#themes#seagull#palette.insert = airline#themes#generate_color_map(
        \ [s:I1[0].g, s:I1[1].g, s:I1[0].t, s:I1[1].t, s:I1[2]],
        \ [s:I2[0].g, s:I2[1].g, s:I2[0].t, s:I2[1].t, s:I2[2]],
        \ [s:I3[0].g, s:I3[1].g, s:I3[0].t, s:I3[1].t, s:I3[2]])

  let g:airline#themes#seagull#palette.insert.airline_warning =
        \ g:airline#themes#seagull#palette.normal.airline_warning

  let g:airline#themes#seagull#palette.insert_modified = {
        \ 'airline_c': [s:IM[0].g, s:IM[1].g,
        \ s:IM[0].t, s:IM[1].t, s:IM[2]]}

  let g:airline#themes#seagull#palette.insert_modified.airline_warning =
        \ g:airline#themes#seagull#palette.normal.airline_warning

  let g:airline#themes#seagull#palette.visual = airline#themes#generate_color_map(
        \ [s:V1[0].g, s:V1[1].g, s:V1[0].t, s:V1[1].t, s:V1[2]],
        \ [s:V2[0].g, s:V2[1].g, s:V2[0].t, s:V2[1].t, s:V2[2]],
        \ [s:V3[0].g, s:V3[1].g, s:V3[0].t, s:V3[1].t, s:V3[2]])

  let g:airline#themes#seagull#palette.visual.airline_warning =
        \ g:airline#themes#seagull#palette.normal.airline_warning

  let g:airline#themes#seagull#palette.visual_modified = {
        \ 'airline_c': [s:VM[0].g, s:VM[1].g,
        \ s:VM[0].t, s:VM[1].t, s:VM[2]]}

  let g:airline#themes#seagull#palette.visual_modified.airline_warning =
        \ g:airline#themes#seagull#palette.normal.airline_warning

  let g:airline#themes#seagull#palette.replace = airline#themes#generate_color_map(
        \ [s:R1[0].g, s:R1[1].g, s:R1[0].t, s:R1[1].t, s:R1[2]],
        \ [s:R2[0].g, s:R2[1].g, s:R2[0].t, s:R2[1].t, s:R2[2]],
        \ [s:R3[0].g, s:R3[1].g, s:R3[0].t, s:R3[1].t, s:R3[2]])

  let g:airline#themes#seagull#palette.replace.airline_warning =
        \ g:airline#themes#seagull#palette.normal.airline_warning

  let g:airline#themes#seagull#palette.replace_modified = {
        \ 'airline_c': [s:RM[0].g, s:RM[1].g,
        \ s:RM[0].t, s:RM[1].t, s:RM[2]]}

  let g:airline#themes#seagull#palette.replace_modified.airline_warning =
        \ g:airline#themes#seagull#palette.normal.airline_warning

  let g:airline#themes#seagull#palette.tabline = {}

  let g:airline#themes#seagull#palette.tabline.airline_tab = [
        \ s:I2[0].g, s:I2[1].g, s:I2[0].t, s:I2[1].t, s:I2[2]]

  let g:airline#themes#seagull#palette.tabline.airline_tabtype = [
        \ s:N2[0].g, s:N2[1].g, s:N2[0].t, s:N2[1].t, s:N2[2]]
endfunction

call airline#themes#seagull#refresh()
