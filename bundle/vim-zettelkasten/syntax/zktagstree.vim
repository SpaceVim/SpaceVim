if "zktagstree" !=# get(b:, "current_syntax", "zktagstree")
  finish
endif

" syntax match ZettelKastenID '[0-9]\+-[0-9]\+-[0-9]\+-[0-9]\+-[0-9]\+-[0-9]\+\.md'
" syntax match ZettelKastenDash '\s-\s'
syntax match zktagstreeOrg '[▼▶]\+ .*'
syntax match zktagstreeTags '#\<\k\+\>'

" highlight default link ZettelKastenID String
" highlight default link ZettelKastenDash Comment
highlight default link zktagstreeOrg Number
highlight default link zktagstreeTags Tag

let b:current_syntax = "zktagstree"

