nnoremap <silent> <F3> <cmd>NvimTreeToggle<CR>
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
