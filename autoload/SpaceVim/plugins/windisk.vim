func! SpaceVim#plugins#windisk#open()
  let disks = s:get_disks()
  if !empty(disks)
    " 1. open plugin buffer
    " 2. init buffer option and syntax
    " 2. updated content
    " 3. init buffer key bindings
  else
    " TODO: print warnning, not sure if it is needed.
  endif
endf

func! s:get_disks()
  return map(filter(range(65, 97), "isdirectory(nr2char(v:val) . ':/')"), 'nr2char(v:val) . ":/"')
endf

