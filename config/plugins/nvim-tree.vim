let s:WIN = SpaceVim#api#import('vim#window')
nnoremap <silent> <F3> <cmd>NvimTreeToggle<CR>
augroup vfinit
  au!
  autocmd BufEnter * nested if
        \ (!has('vim_starting') && s:WIN.win_count() == 1  && g:_spacevim_autoclose_filetree
        \ && &filetype ==# 'NvimTree') |
        \ call s:close_last_filetree() | endif
augroup END
function! s:close_last_filetree() abort
  call SpaceVim#layers#shell#close_terminal()
  q
endfunction
lua <<EOF
-- init.lua

-- empty setup using defaults: add your own options
require'nvim-tree'.setup {
  view = {
    width = vim.api.nvim_eval('g:spacevim_sidebar_width'),
    height = 30,
    hide_root_folder = false,
    side = "right",
    preserve_window_proportions = false,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
    mappings = {
      custom_only = false,
      list = {
        -- user mappings go here
      },
    },
  },
}
EOF
