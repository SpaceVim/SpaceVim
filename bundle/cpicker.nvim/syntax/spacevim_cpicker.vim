if exists('b:current_syntax') && b:current_syntax ==# 'spacevim_cpicker'
  finish
endif
let b:current_syntax = 'spacevim_cpicker'
syntax case ignore

syn match ProcessBar /[?=+]\+/
" syn match SpaceVimPickerCode /\s#[0123456789ABCDEF]\+\|\srgb(\d\+,\s\d\+,\s\d\+)\|\shsl(\d\+,\s\d\+%,\s\d\+%)\|\shsv(\d\+,\s\d\+%,\s\d\+%)\|\scmyk(\d\+%,\s\d\+%,\s\d\+%,\s\d\+%)\|\shwb(\d\+,\s\d\+%,\s\d\+%)/
syn match SpaceVimPickerBackground /=\+\s/

highlight ProcessBar ctermfg=Gray ctermbg=Gray guifg=Gray guibg=Gray


