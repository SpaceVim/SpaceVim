syntax clear

let b:current_syntax = 'neomake_qf'

highlight default link neomakeListNr LineNr
highlight default link neomakeCursorListNr CursorLineNr
highlight default link neomakeMakerName FoldColumn
highlight default link neomakeBufferName qfFileName
" vim: ts=4 sw=4 et
