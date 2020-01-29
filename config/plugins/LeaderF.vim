scriptencoding utf-8
let g:Lf_StlSeparator = get(g:, 'Lf_StlSeparator', { 'left': '', 'right': '' })
let g:Lf_StlColorscheme = get(g:, 'spacevim_colorscheme', 'default')
" disable default mru

" disable default mru, and use neomru by default
augroup LeaderF_Mru
  autocmd!
  autocmd FileType leaderf setlocal nonumber
augroup END

" change the leaderf Colorscheme automatically

augroup leaderf_layer_config
  autocmd!
  autocmd ColorScheme * let g:Lf_StlColorscheme = g:colors_name
augroup END

let g:Lf_PreviewResult = {
      \ 'File': 0,
      \ 'Buffer': 0,
      \ 'Mru': 0,
      \ 'Tag': 0,
      \ 'BufTag': 0,
      \ 'Function': 0,
      \ 'Line': 0,
      \ 'Colorscheme': 0
      \}

let g:Lf_CommandMap = {
      \ '<C-J>' : ['<Tab>'],
      \ '<C-K>' : ['<S-Tab>'],
      \ '<C-R>' : ['<C-E>'],
      \ '<C-X>' : ['<C-S>'],
      \ '<C-]>' : ['<C-V>'],
      \ '<C-F>' : ['<C-D>'],
      \ '<Tab>' : ['<Esc>'],
      \ }
let g:Lf_HideHelp = 1
