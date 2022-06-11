let s:WIN = SpaceVim#api#import('vim#window')
nnoremap <silent> <F3> <cmd>NvimTreeToggle<CR>
" we can not use this option to disable default key bindings
" let g:nvim_tree_disable_default_keybindings = 1
augroup vfinit
  au!
  autocmd FileType NvimTree call s:nvim_tree_init()
  autocmd BufEnter * nested if
        \ (!has('vim_starting') && s:WIN.win_count() == 1  && g:_spacevim_autoclose_filetree
        \ && &filetype ==# 'NvimTree') |
        \ call s:close_last_filetree() | endif
augroup END
function! s:close_last_filetree() abort
  call SpaceVim#layers#shell#close_terminal()
  q
endfunction
function! s:nvim_tree_init() abort
  nnoremap <silent><buffer> . :<C-u>lua require'nvim-tree.actions'.on_keypress('toggle_dotfiles')<Cr>
endfunction
lua <<EOF
-- init.lua

-- empty setup using defaults: add your own options
require'nvim-tree'.setup {
  view = {
    width = vim.api.nvim_eval('g:spacevim_sidebar_width'),
    height = 30,
    hide_root_folder = false,
    side = vim.api.nvim_eval('g:spacevim_filetree_direction'),
    preserve_window_proportions = false,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
    mappings = {
      custom_only = true,
      list = {
        -- user mappings go here
      },
    },
  },
}
EOF
