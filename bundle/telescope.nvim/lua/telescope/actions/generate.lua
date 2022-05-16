---@tag telescope.actions.generate
---@config { ["module"] = "telescope.actions.generate" }

---@brief [[
--- Module for convenience to override defaults of corresponding |telescope.actions| at |telescope.setup()|.
---
--- General usage:
--- <code>
---   require("telescope").setup {
---     defaults = {
---       mappings = {
---         n = {
---           ["?"] = action_generate.which_key {
---             name_width = 20, -- typically leads to smaller floats
---             max_height = 0.5, -- increase potential maximum height
---             separator = " > ", -- change sep between mode, keybind, and name
---             close_with_action = false, -- do not close float on action
---           },
---         },
---       },
---     },
---   }
--- </code>
---@brief ]]

local actions = require "telescope.actions"
local action_generate = {}

--- Display the keymaps of registered actions similar to which-key.nvim.<br>
--- - Floating window:
---   - Appears on the opposite side of the prompt.
---   - Resolves to minimum required number of lines to show hints with `opts` or truncates entries at `max_height`.
---   - Closes automatically on action call and can be disabled with by setting `close_with_action` to false.
---@param opts table: options to pass to toggling registered actions
---@field max_height number: % of max. height or no. of rows for hints (default: 0.4), see |resolver.resolve_height()|
---@field only_show_current_mode boolean: only show keymaps for the current mode (default: true)
---@field mode_width number: fixed width of mode to be shown (default: 1)
---@field keybind_width number: fixed width of keybind to be shown (default: 7)
---@field name_width number: fixed width of action name to be shown (default: 30)
---@field column_padding string: string to split; can be used for vertical separator (default: "  ")
---@field mode_hl string: hl group of mode (default: TelescopeResultsConstant)
---@field keybind_hl string: hl group of keybind (default: TelescopeResultsVariable)
---@field name_hl string: hl group of action name (default: TelescopeResultsFunction)
---@field column_indent number: number of left-most spaces before keybinds are shown (default: 4)
---@field line_padding number: row padding in top and bottom of float (default: 1)
---@field separator string: separator string between mode, key bindings, and action (default: " -> ")
---@field close_with_action boolean: registered action will close keymap float (default: true)
---@field normal_hl string: winhl of "Normal" for keymap hints floating window (default: "TelescopePrompt")
---@field border_hl string: winhl of "Normal" for keymap borders (default: "TelescopePromptBorder")
---@field winblend number: pseudo-transparency of keymap hints floating window
action_generate.which_key = function(opts)
  return function(prompt_bufnr)
    actions.which_key(prompt_bufnr, opts)
  end
end

return action_generate
