scriptencoding utf-8
let s:neomake_automake_events = {}
if get(g:, 'spacevim_lint_on_save', 0)
    let s:neomake_automake_events['BufWritePost'] = {'delay': 0}
endif

if get(g:, 'spacevim_lint_on_the_fly', 0)
    let s:neomake_automake_events['TextChanged'] = {'delay': 750}
    let s:neomake_automake_events['TextChangedI'] = {'delay': 750}
endif

if !empty(s:neomake_automake_events)
  try
    call neomake#configure#automake(s:neomake_automake_events)
  catch /^Vim\%((\a\+)\)\=:E117/
  endtry
endif
" 1 open list and move cursor 2 open list without move cursor
let g:neomake_open_list = get(g:, 'neomake_open_list', 2)
let g:neomake_verbose = get(g:, 'neomake_verbose', 0)
let g:neomake_java_javac_delete_output = get(g:, 'neomake_java_javac_delete_output', 0)
let g:neomake_error_sign = get(g:, 'neomake_error_sign', {
      \ 'text': get(g:, 'spacevim_error_symbol', '✖'),
      \ 'texthl': (get(g:, 'spacevim_colorscheme', 'gruvbox') ==# 'gruvbox' ? 'GruvboxRedSign' : 'error'),
      \ })
let g:neomake_warning_sign = get(g:, 'neomake_warning_sign', {
      \ 'text': get(g:,'spacevim_warning_symbol', '➤'),
      \ 'texthl': (get(g:, 'spacevim_colorscheme', 'gruvbox') ==# 'gruvbox' ? 'GruvboxYellowSign' : 'todo'),
      \ })
let g:neomake_info_sign = get(g:, 'neomake_info_sign', {
      \ 'text': get(g:,'spacevim_info_symbol', '🛈'),
      \ 'texthl': (get(g:, 'spacevim_colorscheme', 'gruvbox') ==# 'gruvbox' ? 'GruvboxYellowSign' : 'todo'),
      \ })
" vim:set et sw=2:
