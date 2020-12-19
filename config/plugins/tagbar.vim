let g:tagbar_width = get(g:, 'tagbar_width', g:spacevim_sidebar_width)
if g:spacevim_filetree_direction ==# 'right'
  let g:tagbar_left = 1
else
  let g:tagbar_left = 0
endif
let g:tagbar_sort = get(g:, 'tagbar_sort', 0)
let g:tagbar_compact = get(g:, 'tagbar_compact', 1)
let g:tagbar_map_showproto = get(g:, 'tagbar_map_showproto', '')
let g:tagbar_iconchars = ['▶', '▼']
