func! s:paser(file)
  let config = readfile(a:file, '')
  let rst = {}
  for line in config
    if line !~ '^#' && !empty(line)
      let file = split(line)[0]
      let owners = split(line)[1:]
      call extend(rst, {file : owners})
    endif
  endfor
  return rst
endf

let s:owners = s:paser('.github/CODEOWNERS')



func! SpaceVim#dev#codeowner#open_profile()
  let url = 'https://github.com/'
  let owners = get(s:owners, expand('%'), [])
  if !empty(owners)
     let url = url . owner[0]
     exe 'OpenBrowser ' . url
  else
     echohl WarnMsg
     echon 'can not find owner for current file'
     echohl None
  endif
endf
