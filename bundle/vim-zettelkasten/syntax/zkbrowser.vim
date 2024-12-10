if "zkbrowser" !=# get(b:, "current_syntax", "zkbrowser")
  finish
endif

syntax match ZettelKastenID '[0-9]\+-[0-9]\+-[0-9]\+-[0-9]\+-[0-9]\+-[0-9]\+\.md'
syntax match ZettelKastenDash '\s-\s'
syntax match ZettelKastenRefs '\[[0-9]\+ .*\]'
syntax match ZettelKastenTags '#\<\k\+\>'

highlight default link ZettelKastenID String
highlight default link ZettelKastenDash Comment
highlight default link ZettelKastenRefs Number
highlight default link ZettelKastenTags Tag

let b:current_syntax = "zkbrowser"
