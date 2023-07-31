local toml = require('spacevim.api.data.toml')

print(vim.inspect(toml.parse_file('mode/basic.toml')))

print(vim.inspect(vim.api.nvim_eval("SpaceVim#api#import('data#toml').parse_file('mode/basic.toml')")))


-- {
--   layers = { {
--       auto_completion_return_key_behavior = "complete",
--       auto_completion_tab_key_behavior = "cycle",
--       name = "autocomplete"
--     }, {
--       default_height = 30,
--       default_position = "top",
--       name = "shell"
--     } },
--   options = {
--     buffer_index_type = 4,
--     colorscheme = "gruvbox",
--     colorscheme_bg = "dark",
--     enable_guicolors = false,
--     enable_statusline_mode = false,
--     enable_tabline_filetype_icon = false,
--     statusline_iseparator = "bar",
--     statusline_separator = "nil",
--     statusline_unicode = false,
--     vimcompatible = true,
--     windows_index_type = 3
--   }
-- }
-- {
--   layers = { {
--       auto_completion_return_key_behavior = "complete",
--       auto_completion_tab_key_behavior = "cycle",
--       name = "autocomplete"
--     }, {
--       default_height = 30,
--       default_position = "top",
--       name = "shell"
--     } },
--   options = {
--     buffer_index_type = 4,
--     colorscheme = "gruvbox",
--     colorscheme_bg = "dark",
--     enable_guicolors = 0,
--     enable_statusline_mode = 0,
--     enable_tabline_filetype_icon = 0,
--     statusline_iseparator = "bar",
--     statusline_separator = "nil",
--     statusline_unicode = 0,
--     vimcompatible = 1,
--     windows_index_type = 3
--   }
-- }
