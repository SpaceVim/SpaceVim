function! SpaceVim#dev#layers#update() abort

  let [start, end] = s:find_position()
  if start != 0 && end != 0
    if end - start > 1
      exe (start + 1) . ',' . (end - 1) . 'delete'
    endif
    call append(start, s:generate_content())
    silent! Neoformat
  endif

endfunction

function! s:find_position() abort
  let start = search('^<!-- SpaceVim layer list start -->$','bwnc')
  let end = search('^<!-- SpaceVim layer list end -->$','bnwc')
  return sort([start, end])
endfunction

function! s:generate_content() abort
  let content = ['', '## Available layers', '']
  let content += s:layer_list()
  return content
endfunction

function! s:layer_list() abort
  let layers = SpaceVim#util#globpath('~/.SpaceVim/', "docs/layers/**/*.md")
  let list = [
        \ '| Name | Description |',
        \ '| ---------- | ------------ |'
        \ ]
  call remove(layers, index(layers, '/home/wsdjeg/.SpaceVim/docs/layers/index.md'))
  for layer in layers
    let name = split(layer, '/docs/layers')[1][:-4] . '/'
    let url = 'https://spacevim.org/layers' . name
    let content = readfile(layer)
    if len(content) > 3
      let line = '| [' . join(split(name, '/'), '#') . '](' . url . ')    |   ' . content[2][14:-2] . ' | '
    else
      let line = '| [' . join(split(name, '/'), '#') . '](' . url . ')    |   can not find Description |'
    endif
    call add(list, line)
  endfor
  return list
endfunction
