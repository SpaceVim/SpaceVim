scriptencoding utf-8
let g:ale_sign_error = get(g:, 'spacevim_error_symbol', '✖')
let g:ale_sign_warning = get(g:,'spacevim_warning_symbol', '➤')
let g:ale_sign_info = get(g:,'spacevim_info_symbol', '🛈')
let g:ale_echo_msg_format = get(g:, 'ale_echo_msg_format', '%severity%: %linter%: %s')

if get(g:, 'spacevim_colorscheme', '') ==# 'gruvbox'
  highlight link ALEErrorSign GruvboxRedSign
  highlight link ALEWarningSign GruvboxYellowSign
endif

let s:lint_option = SpaceVim#layers#checkers#get_lint_option()
if s:lint_option.lint_on_the_fly
  let g:ale_lint_on_text_changed = 'always'
  let g:ale_lint_delay = 750
else
  let g:ale_lint_on_text_changed = 'never'
endif
let g:ale_lint_on_save = s:lint_option.lint_on_save
