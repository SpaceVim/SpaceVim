" Color palette
let s:gui_dark_gray = '#303030'
let s:cterm_dark_gray = 236
let s:gui_med_gray_hi = '#444444'
let s:cterm_med_gray_hi = 238
let s:gui_med_gray_lo = '#3a3a3a'
let s:cterm_med_gray_lo = 237
let s:gui_light_gray = '#b2b2b2'
let s:cterm_light_gray = 249
let s:gui_green = '#005f87'
let s:cterm_green = 150
let s:gui_blue = '#87afd7'
let s:cterm_blue = 110
let s:gui_purple = '#afafd7'
let s:cterm_purple = 146
let s:gui_orange = '#ffaf87'
let s:cterm_orange = 216
let s:gui_red = '#d78787'
let s:cterm_red = 174
let s:gui_pink = '#d7afd7'
let s:cterm_pink = 182

let g:airline#themes#angr#palette = {}

" Normal mode
let s:N1 = [s:gui_dark_gray, s:gui_green, s:cterm_dark_gray, s:cterm_green]
let s:N2 = [s:gui_light_gray, s:gui_med_gray_lo, s:cterm_light_gray, s:cterm_med_gray_lo]
let s:N3 = [s:gui_light_gray, s:gui_med_gray_hi, s:cterm_light_gray, s:cterm_med_gray_hi] " inside text
let g:airline#themes#angr#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#angr#palette.normal_modified = {
      \ 'airline_c': [s:gui_orange, s:gui_med_gray_hi, s:cterm_orange, s:cterm_med_gray_hi, ''],
      \ }

" Insert mode
let s:I1 = [s:gui_med_gray_hi, s:gui_blue, s:cterm_med_gray_hi, s:cterm_blue]
let s:I3 = [s:gui_blue, s:gui_med_gray_hi, s:cterm_blue, s:cterm_med_gray_hi] " inside text
let g:airline#themes#angr#palette.insert = airline#themes#generate_color_map(s:I1, s:N2, s:I3)
let g:airline#themes#angr#palette.insert_modified = copy(g:airline#themes#angr#palette.normal_modified)
let g:airline#themes#angr#palette.insert_paste = {
      \ 'airline_a': [s:gui_dark_gray, s:gui_orange, s:cterm_dark_gray, s:cterm_orange, ''],
      \ }

" Replace mode
let g:airline#themes#angr#palette.replace = {
      \ 'airline_a': [s:gui_dark_gray, s:gui_red, s:cterm_dark_gray, s:cterm_red, ''],
      \ 'airline_c': [s:gui_red, s:gui_med_gray_hi, s:cterm_red, s:cterm_med_gray_hi, ''],
      \ }
let g:airline#themes#angr#palette.replace_modified = copy(g:airline#themes#angr#palette.insert_modified)

" Visual mode
let s:V1 = [s:gui_dark_gray, s:gui_pink, s:cterm_dark_gray, s:cterm_pink]
let s:V3 = [s:gui_pink, s:gui_med_gray_hi, s:cterm_pink, s:cterm_med_gray_hi]
let g:airline#themes#angr#palette.visual = airline#themes#generate_color_map(s:V1, s:N2, s:V3)
let g:airline#themes#angr#palette.visual_modified = copy(g:airline#themes#angr#palette.insert_modified)

" Inactive window
let s:IA = [s:gui_light_gray, s:gui_med_gray_hi, s:cterm_light_gray, s:cterm_med_gray_hi, '']
let g:airline#themes#angr#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
let g:airline#themes#angr#palette.inactive_modified = {
      \ 'airline_c': [s:gui_orange, '', s:cterm_orange, '', ''],
      \ }

" Warnings
let s:ER = airline#themes#get_highlight2(['ErrorMsg', 'bg'], ['ErrorMsg', 'fg'], 'bold')
let g:airline#themes#angr#palette.normal.airline_warning = [
 \ s:ER[1], s:ER[0], s:ER[3], s:ER[2]
 \ ]
let g:airline#themes#angr#palette.normal_modified.airline_warning =
\ g:airline#themes#angr#palette.normal.airline_warning
let g:airline#themes#angr#palette.insert.airline_warning =
\ g:airline#themes#angr#palette.normal.airline_warning
let g:airline#themes#angr#palette.insert_modified.airline_warning =
\ g:airline#themes#angr#palette.normal.airline_warning
let g:airline#themes#angr#palette.visual.airline_warning =
\ g:airline#themes#angr#palette.normal.airline_warning
let g:airline#themes#angr#palette.visual_modified.airline_warning =
\ g:airline#themes#angr#palette.normal.airline_warning
let g:airline#themes#angr#palette.replace.airline_warning =
\ g:airline#themes#angr#palette.normal.airline_warning
let g:airline#themes#angr#palette.replace_modified.airline_warning =
\ g:airline#themes#angr#palette.normal.airline_warning

" Errors
let g:airline#themes#angr#palette.normal.airline_error = [
 \ s:ER[1], s:ER[0], s:ER[3], s:ER[2]
 \ ]
let g:airline#themes#angr#palette.normal_modified.airline_error =
\ g:airline#themes#angr#palette.normal.airline_error
let g:airline#themes#angr#palette.insert.airline_error =
\ g:airline#themes#angr#palette.normal.airline_error
let g:airline#themes#angr#palette.insert_modified.airline_error =
\ g:airline#themes#angr#palette.normal.airline_error
let g:airline#themes#angr#palette.visual.airline_error =
\ g:airline#themes#angr#palette.normal.airline_error
let g:airline#themes#angr#palette.visual_modified.airline_error =
\ g:airline#themes#angr#palette.normal.airline_error
let g:airline#themes#angr#palette.replace.airline_error =
\ g:airline#themes#angr#palette.normal.airline_error
let g:airline#themes#angr#palette.replace_modified.airline_error =
\ g:airline#themes#angr#palette.normal.airline_error

" CtrlP
if !get(g:, 'loaded_ctrlp', 0)
  finish
endif
let g:airline#themes#angr#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
      \ [ s:gui_orange, s:gui_med_gray_hi, s:cterm_orange, s:cterm_med_gray_hi, '' ] ,
      \ [ s:gui_orange, s:gui_med_gray_lo, s:cterm_orange, s:cterm_med_gray_lo, '' ] ,
      \ [ s:gui_dark_gray, s:gui_green, s:cterm_dark_gray, s:cterm_green, 'bold' ] )
