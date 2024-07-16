if exists('b:current_syntax') && b:current_syntax ==# 'spacevim_cpicker_mix'
  finish
endif
let b:current_syntax = 'spacevim_cpicker_mix'
syntax case ignore

syn match SpaceVimPickerMixProcessBar /[?=+]\+/
syn match SpaceVimPickerMixColor1P /P1/ contained
syn match SpaceVimPickerMixColor2P /P2/ contained
syn match SpaceVimPickerMixColor1 /#[0123456789ABCDEF]\+\s\+P1/ contains=SpaceVimPickerMixColor1P
syn match SpaceVimPickerMixColor2 /#[0123456789ABCDEF]\+\s\+P2/ contains=SpaceVimPickerMixColor2P
syn match SpaceVimPickerMixColor3 /=\+\s/
syn match SpaceVimPickerMixColor3Background /\s=\+\s/
syn match SpaceVimPickerMixColor3Code /\scolor-mix...............................................\|\s#......\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s/
syn match SpaceVimPickerMixMethodFlag /[<>]/ contained
syn match SpaceVimPickerMixMethod /[<>].\+[<>]/ contains=SpaceVimPickerMixMethodFlag

highlight SpaceVimPickerMixProcessBar ctermfg=Gray ctermbg=Gray guifg=Gray guibg=Gray
highlight link SpaceVimPickerMixMethodFlag EndOfBuffer
highlight SpaceVimPickerMixMethod ctermfg=Black ctermbg=Gray guifg=Black guibg=Gray
highlight link SpaceVimPickerMixColor1P Normal
highlight link SpaceVimPickerMixColor2P Normal

