"nnoremap <leader>gd :execute 'Unite  -auto-preview -start-insert -no-split gtags/def:'.expand('<cword>')<CR>
"nnoremap <leader>gc :execute 'Unite  -auto-preview -start-insert -no-split gtags/context'<CR>
" nnoremap <leader>gr :execute 'Unite  -auto-preview -start-insert -no-split gtags/ref'<CR>
" nnoremap <leader>gg :execute 'Unite  -auto-preview -start-insert -no-split gtags/grep'<CR>
"nnoremap <leader>gp :execute 'Unite  -auto-preview -start-insert -no-split gtags/completion'<CR>
" vnoremap <leader>gd <ESC>:execute 'Unite -auto-preview -start-insert -no-split gtags/def:'.GetVisualSelection()<CR>
" let g:unite_source_gtags_project_config = get(g:, 'unite_source_gtags_project_config', {
      " \ '_':                   { 'treelize': 0 }
      " \ })

" vim:set et sw=2:
