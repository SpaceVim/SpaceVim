"==============================================================
"    file: compatible_with_ultisnips.vim
"   brief: 
" VIM Version: 8.0
"  author: tenfyzhong
"   email: tenfy@tenfy.cn
" created: 2017-07-14 22:08:37
"==============================================================
if !exists(':UltiSnipsEdit') || get(g:, 'complete_parameter_use_ultisnips_mappings', 0) == 0
  finish
endif

if g:UltiSnipsExpandTrigger == g:UltiSnipsJumpForwardTrigger
  exec printf('inoremap <silent> %s <c-r>=UltiSnips#ExpandSnippetOrJump()<cr><c-r>=cmp#ultisnips#ExpandTrigger()<cr>', g:UltiSnipsExpandTrigger)
  exec printf('snoremap <silent> %s <ESC>:call UltiSnips#ExpandSnippetOrJump()<cr><ESC>:call cmp#ultisnips#ExpandTrigger()<cr>', g:UltiSnipsExpandTrigger)
else
  exec printf('inoremap <silent> %s <c-r>=UltiSnips#JumpForwards()<cr><c-r>=cmp#ultisnips#JumpForward()<cr>', g:UltiSnipsJumpForwardTrigger)
  exec printf('snoremap <silent> %s <ESC>:call UltiSnips#JumpForwards()<cr><ESC>:call cmp#ultisnips#JumpForward()<cr>', g:UltiSnipsJumpForwardTrigger)
endif
exec printf("inoremap <silent> %s <c-r>=UltiSnips#JumpBackwards()<cr><c-r>=cmp#ultisnips#JumpBackward()<cr>", g:UltiSnipsJumpBackwardTrigger)
exec printf("snoremap <silent> %s <ESC>:call UltiSnips#JumpBackwards()<cr><ESC>:call cmp#ultisnips#JumpBackward()<cr>", g:UltiSnipsJumpBackwardTrigger)


