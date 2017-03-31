scriptencoding utf-8
if !executable('ctags')
  let g:Tlist_Ctags_Cmd = get(g:, 'Tlist_Ctags_Cmd', '/usr/bin/ctags')  "设置ctags执行路径
endif
let g:Tlist_Auto_Update = get(g:, 'Tlist_Auto_Update', 1)
let g:Tlist_Auto_Open = get(g:, 'Tlist_Auto_Open', 0)
let g:Tlist_Use_Right_Window = get(g:, 'Tlist_Use_Right_Window', 1)
let g:Tlist_Show_One_File = get(g:, 'Tlist_Show_One_File', 0)
let g:Tlist_File_Fold_Auto_Close = get(g:, 'Tlist_File_Fold_Auto_Close', 1)
let g:Tlist_Exit_OnlyWindow = get(g:, 'Tlist_Exit_OnlyWindow', 1)
let g:Tlist_Show_Menu = get(g:, 'Tlist_Show_Menu', 1)

" vim:set et sw=2:
