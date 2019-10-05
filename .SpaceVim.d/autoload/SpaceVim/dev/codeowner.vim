let s:FILE = SpaceVim#api#import('file')

func! s:paser(file) abort
  let config = readfile(a:file, '')
  let rst = {}
  for line in config
    if line !~# '^#' && !empty(line)
      let file = split(line)[0]
      let owners = split(line)[1:]
      call extend(rst, {file : owners})
    endif
  endfor
  return rst
endf

let s:owners = s:paser('.github/CODEOWNERS')
let g:owners = s:owners



func! SpaceVim#dev#codeowner#open_profile() abort
  let url = 'https://github.com/'
  let owners = get(s:owners, s:FILE.unify_path(expand('%'), ':.'), [])
  if !empty(owners)
     let url = url . owners[0][1:]
     exe 'OpenBrowser ' . url
  else
     echohl WarnMsg
     echon 'can not find owner for current file'
     echohl None
  endif
endf
