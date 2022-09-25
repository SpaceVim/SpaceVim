scriptencoding utf-8

augroup aufsharp
  autocmd!
augroup END

" https://github.com/fsharp/vim-fsharp/pull/103
if !has('nvim') && !has('gui_running')
  autocmd aufsharp BufNewFile,BufRead *.fs,*.fsi,*.fsx  set regexpengine=1
endif

autocmd aufsharp BufNewFile,BufRead *.fs,*.fsi,*.fsx setlocal filetype=fsharp
