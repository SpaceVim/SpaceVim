func! s:paser(file)
  return {}
endf

let s:owners = s:paser('.github/CODEOWNERS')



func! SpaceVim#dev#codeowner#open_profile()
  let url = 'https://github.com'
  let owner = get(s:owners, expand('%'), '')
  if owner =~ '^@'
     let url = url . owner[1:]
     exe 'OpenBrowser ' . url
  else
     echohl WarnMsg
     echon 'can not find owner for current file'
     echohl None
  endif
endf
