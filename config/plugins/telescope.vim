lua require('telescope').load_extension('menu')
lua <<EOF
local actions = require("telescope.actions")
require("telescope").setup{
  defaults = {
    mappings = {
      i = {
        -- the default key binding should same as other fuzzy finder layer
        -- tab move to next
        ["<C-j>"] = actions.cycle_previewers_next,
      },
    },
  }
}
EOF
