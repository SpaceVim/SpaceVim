let g:delimitMate_expand_cr = 1
let g:delimitMate_eol_marker = ';'
call vimtest#StartTap()
call vimtap#Plan(8)
" NOTE: Do not forget to update the plan ^
let g:delimitMate_insert_eol_marker = 0
DelimitMateReload
normal i(
call vimtap#Is(getline(1), '()', 'value = 1, case 1')
%d _
exec "normal i(\<CR>x"
call vimtap#Like(join(getline(1,line('$')), "\<NL>"),
      \ '^(\n\s*x\n)$', ' "normal i(\<CR>x", Value = 2, case 2')
let g:delimitMate_insert_eol_marker = 1
DelimitMateReload
%d _
normal i(
call vimtap#Is(getline(1), '();', '"normal i(", value = 1, case 1')
%d _
exec "normal i(\<CR>x"
call vimtap#Like(join(getline(1,line('$')), "\<NL>"),
      \ '^(\n\s*x\n);$', '"normal i(\<CR>x", Value = 2, case 2')
%d _
let g:delimitMate_insert_eol_marker = 2
DelimitMateReload
normal i(
call vimtap#Is(getline(1), '()', '"normal i(", Value = 2, case 1')
%d _
exec "normal i(\<CR>x"
call vimtap#Like(join(getline(1,line('$')), "\<NL>"),
      \ '^(\n\s*x\n);$', '"normal i(\<CR>x", Value = 2, case 2')

%d _
exec "normal i{(\<CR>x"
call vimtap#Like(join(getline(1,line('$')), "\<NL>"),
      \ '^{(\n\s*x\n)};$', ' "normal i{(\<CR>x", Value = 2, case 3')

%d _
exec "normal i;\<Esc>I{(\<CR>x"
call vimtap#Like(join(getline(1,line('$')), "\<NL>"),
      \ '^{(\n\s*x\n)};$', ' "normal i{(\<CR>x", Value = 2, case 4')

" End: quit vim.
call vimtest#Quit()
