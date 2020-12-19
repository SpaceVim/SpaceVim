let g:delimitMate_expand_cr = 1
let g:delimitMate_eol_marker = ';'
call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#Like(maparg('(', 'i'), '<Plug>delimitMate(', 'Mappings defined for the first buffer without filetype set.')
call vimtest#Quit()


