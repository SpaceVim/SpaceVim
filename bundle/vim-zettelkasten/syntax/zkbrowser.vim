if "zkbrowser" !=# get(b:, "current_syntax", "zkbrowser")
  finish
endif

syntax match ZkFileName '[0-9]\+-[0-9]\+-[0-9]\+-[0-9]\+-[0-9]\+-[0-9]\+\.md'
syntax match ZkRefCount '\[[0-9]\+ .*\]'
syntax match ZkTag '#\<\k\+\>'

highlight default link ZkFileName Label
highlight default link ZkRefCount Link
highlight default link ZkTag Tag

let b:current_syntax = "zkbrowser"
