lua require('telescope').load_extension('menu')
lua <<EOF
local actions = require("telescope.actions")
require("telescope").setup{
  defaults = {
    mappings = {
      i = {
        -- the default key binding should same as other fuzzy finder layer
        -- tab move to next
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<Esc>"] = actions.close,
        ["<C-h>"] = "which_key"
      },
    },
  }
}
EOF
