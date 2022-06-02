lua require('telescope').load_extension('menu')
lua require('telescope').load_extension('messages')
lua require('telescope').load_extension('project')
lua require('telescope').load_extension('scriptnames')
lua require('telescope').load_extension('neoyank')
if filereadable(g:_spacevim_root_dir . 'bundle/telescope-fzf-native.nvim/build/libfzf.so')
      \ || filereadable(g:_spacevim_root_dir . 'bundle/telescope-fzf-native.nvim/build/libfzf.dll')
  lua require('telescope').load_extension('fzf')
endif
lua <<EOF
local actions = require("telescope.actions")
require("telescope").setup{
defaults = {
  mappings = {
    i = {
      -- the default key binding should same as other fuzzy finder layer
      -- tab move to next
      ["<C-j>"] = actions.move_selection_next,
      ["<Tab>"] = actions.move_selection_next,
      ["<C-k>"] = actions.move_selection_previous,
      ["<S-Tab>"] = actions.move_selection_previous,
      ["<Esc>"] = actions.close,
      ["<C-h>"] = "which_key"
      },
    },
  sorting_strategy = "ascending",
  layout_config = {
    prompt_position = "bottom"
    }
  }
}
EOF
