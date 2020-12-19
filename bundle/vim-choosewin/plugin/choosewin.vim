" GUARD:
if expand("%:p") ==# expand("<sfile>:p")
  unlet! g:loaded_choosewin
endif
if exists('g:loaded_choosewin')
  finish
endif
let g:loaded_choosewin = 1
let s:old_cpo = &cpo
set cpo&vim

" Main:
augroup plugin-choosewin
  autocmd!
  autocmd ColorScheme,SessionLoadPost * call choosewin#color#refresh()
augroup END

" KeyMap:
nnoremap <silent> <Plug>(choosewin)
      \ :<C-u>call choosewin#start(range(1, winnr('$')))<CR>

" Command:
function! s:win_all()
  return range(1, winnr('$'))
endfunction

command! -bar ChooseWin
      \ call choosewin#start(s:win_all())
command! -bar ChooseWinSwap
      \ call choosewin#start(s:win_all(), {'swap': 1, 'swap_stay': 0 })
command! -bar ChooseWinSwapStay
      \ call choosewin#start(s:win_all(), {'swap': 1, 'swap_stay': 1 })

" Finish:
let &cpo = s:old_cpo

" vim: foldmethod=marker
