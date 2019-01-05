let s:JSON = SpaceVim#api#import('data#json')
let s:FILE = SpaceVim#api#import('file')

function! SpaceVim#plugins#a#alt()
  let g:altconfa = {}
  try
    let g:altconfa = s:JSON.json_decode(join(readfile('.projections.json'), "\n"))
  catch
  endtry
  if empty(g:altconfa)
    echohl WarningMsg
    echo 'failed to file .projections.json'
    echohl None
  endif
  let file = s:FILE.unify_path(bufname('%'), ':.')
  if has_key(g:altconfa, file)
    let alt = get(g:altconfa[file], 'alternate', '')
    if !empty(alt)
      exe 'e ' . alt
    endif
  endif
endfunction
