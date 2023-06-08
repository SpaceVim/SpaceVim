let s:WIN = SpaceVim#api#import('vim#window')
nnoremap <silent> <F3> <cmd>NeoTreeFocusToggle<CR>
augroup vfinit
  au!
  autocmd FileType neo-tree call s:nvim_tree_init()
augroup END
function! s:nvim_tree_init() abort
  nnoremap <silent><buffer> . :<C-u>lua require'nvim-tree.actions'.on_keypress('toggle_dotfiles')<Cr>
endfunction

lua require('config.neo-tree')
