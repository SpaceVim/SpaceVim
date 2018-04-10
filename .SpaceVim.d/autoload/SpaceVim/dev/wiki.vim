function! SpaceVim#dev#wiki#updateLabels() abort
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
  let start = search('^<!-- SpaceVim Wiki labels info start -->$','bwnc')
  let end = search('^<!-- SpaceVim Wiki labels info end -->$','bnwc')
  return sort([start, end])
endfunction

function! s:generate_content() abort
  let content = ['## Labels',
        \ '',
        \ 'Name | color | description',
        \ '--- | ---- | ----'
        \ ]
  let content += s:get_labels()
  return content
endfunction

function! s:get_labels() abort
  let labels = github#api#labels#GetAll('SpaceVim', 'SpaceVim')
  let line = []

  for label in labels
    call add(line, label.name . ' | #' . label.color . ' | ' . get(label, 'description', '') )
  endfor
    if line[-1] !=# ''
        let line += ['']
    endif
  return line
endfunction
