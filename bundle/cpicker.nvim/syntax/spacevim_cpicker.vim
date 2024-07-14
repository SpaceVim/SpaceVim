if exists('b:current_syntax') && b:current_syntax ==# 'spacevim_cpicker'
  finish
endif
let b:current_syntax = 'spacevim_cpicker'
syntax case ignore

syn match ProcessBar /[?=+]\+/
syn match SpaceVimPickerCode /#[0123456789ABCDEF]\+\|rgb(\d\+,\s\d\+,\s\d\+)\|hsl(\d\+,\s\d\+%,\s\d\+%)\|hsv(\d\+,\s\d\+%,\s\d\+%)\|cmyk(\d\+%,\s\d\+%,\s\d\+%,\s\d\+%)\|hwb(\d\+,\s\d\+%,\s\d\+%)/
syn match SpaceVimPickerBackground /=\+/

highlight ProcessBar ctermfg=Gray ctermbg=Gray guifg=Gray guibg=Gray


