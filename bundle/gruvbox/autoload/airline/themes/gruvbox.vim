" -----------------------------------------------------------------------------
" File: gruvbox.vim
" Description: Retro groove color scheme for Airline
" Author: morhetz <morhetz@gmail.com>
" Source: https://github.com/gruvbox-community/gruvbox
" -----------------------------------------------------------------------------

let g:airline#themes#gruvbox#palette = {}

function! airline#themes#gruvbox#refresh()

  let M0 = airline#themes#get_highlight('Identifier')
  let accents_group = airline#themes#get_highlight('Special')
  let modified_group = [M0[0], '', M0[2], '', '']
  let warning_group = airline#themes#get_highlight2(['GruvboxBg0', 'fg'], ['Question', 'fg'])
  let error_group = airline#themes#get_highlight2(['GruvboxBg0', 'fg'], ['WarningMsg', 'fg'])

  let s:N1 = airline#themes#get_highlight2(['GruvboxBg0', 'fg'], ['StatusLineNC', 'bg'])
  let s:N2 = airline#themes#get_highlight2(['StatusLineNC', 'bg'], ['Pmenu', 'bg'])
  let s:N3 = airline#themes#get_highlight2(['StatusLineNC', 'bg'], ['StatusLineNC', 'fg'])
  let g:airline#themes#gruvbox#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
  let g:airline#themes#gruvbox#palette.normal_modified = { 'airline_c': modified_group }
  let g:airline#themes#gruvbox#palette.normal.airline_warning = warning_group
  let g:airline#themes#gruvbox#palette.normal_modified.airline_warning = warning_group
  let g:airline#themes#gruvbox#palette.normal.airline_error = error_group
  let g:airline#themes#gruvbox#palette.normal_modified.airline_error = error_group
  let g:airline#themes#gruvbox#palette.normal.airline_term = s:N3
  let g:airline#themes#gruvbox#palette.normal_modified.airline_term = s:N3

  let s:I1 = airline#themes#get_highlight2(['GruvboxBg0', 'fg'], ['Identifier', 'fg'])
  let s:I2 = s:N2
  let s:I3 = airline#themes#get_highlight2(['GruvboxFg1', 'fg'], ['Pmenu', 'bg'])
  let g:airline#themes#gruvbox#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
  let g:airline#themes#gruvbox#palette.insert_modified = g:airline#themes#gruvbox#palette.normal_modified
  let g:airline#themes#gruvbox#palette.insert.airline_warning = g:airline#themes#gruvbox#palette.normal.airline_warning
  let g:airline#themes#gruvbox#palette.insert_modified.airline_warning = g:airline#themes#gruvbox#palette.normal_modified.airline_warning
  let g:airline#themes#gruvbox#palette.insert.airline_error = g:airline#themes#gruvbox#palette.normal.airline_error
  let g:airline#themes#gruvbox#palette.insert_modified.airline_error = g:airline#themes#gruvbox#palette.normal_modified.airline_error
  let g:airline#themes#gruvbox#palette.insert.airline_term = g:airline#themes#gruvbox#palette.normal.airline_term
  let g:airline#themes#gruvbox#palette.insert_modified.airline_term = g:airline#themes#gruvbox#palette.normal_modified.airline_term

  let s:R1 = airline#themes#get_highlight2(['GruvboxBg0', 'fg'], ['Structure', 'fg'])
  let s:R2 = s:I2
  let s:R3 = s:I3
  let g:airline#themes#gruvbox#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)
  let g:airline#themes#gruvbox#palette.replace_modified = g:airline#themes#gruvbox#palette.normal_modified
  let g:airline#themes#gruvbox#palette.replace.airline_warning = g:airline#themes#gruvbox#palette.normal.airline_warning
  let g:airline#themes#gruvbox#palette.replace_modified.airline_warning = g:airline#themes#gruvbox#palette.normal_modified.airline_warning
  let g:airline#themes#gruvbox#palette.replace.airline_error = g:airline#themes#gruvbox#palette.normal.airline_error
  let g:airline#themes#gruvbox#palette.replace_modified.airline_error = g:airline#themes#gruvbox#palette.normal_modified.airline_error
  let g:airline#themes#gruvbox#palette.replace.airline_term = g:airline#themes#gruvbox#palette.normal.airline_term
  let g:airline#themes#gruvbox#palette.replace_modified.airline_term = g:airline#themes#gruvbox#palette.normal_modified.airline_term

  let s:V1 = airline#themes#get_highlight2(['GruvboxBg0', 'fg'], ['Question', 'fg'])
  let s:V2 = s:N2
  let s:V3 = airline#themes#get_highlight2(['GruvboxBg0', 'fg'], ['TabLine', 'fg'])
  let g:airline#themes#gruvbox#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
  let g:airline#themes#gruvbox#palette.visual_modified = { 'airline_c': [ s:V3[0], '', s:V3[2], '', '' ] }
  let g:airline#themes#gruvbox#palette.visual.airline_warning = g:airline#themes#gruvbox#palette.normal.airline_warning
  let g:airline#themes#gruvbox#palette.visual_modified.airline_warning = g:airline#themes#gruvbox#palette.normal_modified.airline_warning
  let g:airline#themes#gruvbox#palette.visual.airline_error = g:airline#themes#gruvbox#palette.normal.airline_error
  let g:airline#themes#gruvbox#palette.visual_modified.airline_error = g:airline#themes#gruvbox#palette.normal_modified.airline_error
  let g:airline#themes#gruvbox#palette.visual.airline_term = g:airline#themes#gruvbox#palette.normal.airline_term
  let g:airline#themes#gruvbox#palette.visual_modified.airline_term =  g:airline#themes#gruvbox#palette.normal_modified.airline_term

  let s:C1 = airline#themes#get_highlight2(['GruvboxBg0', 'fg'], ['GruvboxGreen', 'fg'])
  let s:C2 = s:I2
  let s:C3 = s:I3
  let g:airline#themes#gruvbox#palette.commandline = airline#themes#generate_color_map(s:C1, s:C2, s:C3)
  let g:airline#themes#gruvbox#palette.commandline_modified = g:airline#themes#gruvbox#palette.normal_modified
  let g:airline#themes#gruvbox#palette.commandline.airline_warning = g:airline#themes#gruvbox#palette.normal.airline_warning
  let g:airline#themes#gruvbox#palette.commandline_modified.airline_warning = g:airline#themes#gruvbox#palette.normal_modified.airline_warning
  let g:airline#themes#gruvbox#palette.commandline.airline_error = g:airline#themes#gruvbox#palette.normal.airline_error
  let g:airline#themes#gruvbox#palette.commandline_modified.airline_error = g:airline#themes#gruvbox#palette.normal_modified.airline_error
  let g:airline#themes#gruvbox#palette.commandline.airline_term = g:airline#themes#gruvbox#palette.normal.airline_term
  let g:airline#themes#gruvbox#palette.commandline_modified.airline_term = g:airline#themes#gruvbox#palette.normal.airline_term

  let s:IA = airline#themes#get_highlight2(['TabLine', 'fg'], ['CursorLine', 'bg'])
  let g:airline#themes#gruvbox#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
  let g:airline#themes#gruvbox#palette.inactive_modified = { 'airline_c': modified_group }

  let g:airline#themes#gruvbox#palette.accents = { 'red': accents_group }

  let s:TF = airline#themes#get_highlight2(['GruvboxBg0', 'fg'], ['GruvboxBg0', 'fg'])
  let g:airline#themes#gruvbox#palette.tabline = {
    \ 'airline_tab':  s:N2,
    \ 'airline_tabsel':  s:N1,
    \ 'airline_tabtype':  s:V1,
    \ 'airline_tablabel':  s:V1,
    \ 'airline_tablabel_right':  s:V1,
    \ 'airline_tabfill':  s:TF,
    \ 'airline_tabhid':  s:IA,
    \ 'airline_tabmod':  s:I1
    \ }

endfunction

call airline#themes#gruvbox#refresh()

" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker:
