scriptencoding utf-8



" 1 open list and move cursor
" 2 open list without move cursor
let g:neomake_open_list = g:is_nvim ? 0 : 2
let g:neomake_echo_current_error = 1
if !g:is_spacevim
  let g:neomake_virtualtext_current_error = 1
endif
let g:neomake_cursormoved_delay = 30

let s:neomake_automake_events = {}
let s:neomake_automake_events['BufWritePost'] = {'delay': 0}
if get(g:, 'spacevim_lint_on_the_fly', 0)
    let s:neomake_automake_events['TextChanged'] = {'delay': 500}
    let s:neomake_automake_events['TextChangedI'] = {'delay': 500}
endif

if !empty(s:neomake_automake_events)
  try
    call neomake#configure#automake(s:neomake_automake_events)
  catch /^Vim\%((\a\+)\)\=:E117/
  endtry
endif


let g:neomake_verbose = 0
let g:neomake_java_javac_delete_output = 0
let g:neomake_error_sign = {
      \ 'text': '✖',
      \ 'texthl': (g:spacevim_colorscheme ==# 'gruvbox' ? 'GruvboxRedSign' : 'error'),
      \ }
let g:neomake_warning_sign = {
      \ 'text': '➤',
      \ 'texthl': (g:spacevim_colorscheme ==# 'gruvbox' ? 'GruvboxYellowSign' : 'todo'),
      \ }
let g:neomake_info_sign = {
      \ 'text': '🛈',
      \ 'texthl': (g:spacevim_colorscheme ==# 'gruvbox' ? 'GruvboxYellowSign' : 'todo'),
      \ }

" vim:set et sw=2:
