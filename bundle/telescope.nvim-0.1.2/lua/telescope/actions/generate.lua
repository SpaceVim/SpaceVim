---@tag telescope.actions.generate
---@config { ["module"] = "telescope.actions.generate", ["name"] = "ACTIONS_GENERATE" }

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
local config = require "telescope.config"
local action_state = require "telescope.actions.state"
local finders = require "telescope.finders"

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

action_generate.refine = function(prompt_bufnr, opts)
  opts = opts or {}
  opts.prompt_to_prefix = vim.F.if_nil(opts.prompt_to_prefix, false)
  opts.prefix_hl_group = vim.F.if_nil(opts.prompt_hl_group, "TelescopePromptPrefix")
  opts.prompt_prefix = vim.F.if_nil(opts.prompt_prefix, config.values.prompt_prefix)
  opts.reset_multi_selection = vim.F.if_nil(opts.reset_multi_selection, false)
  opts.reset_prompt = vim.F.if_nil(opts.reset_prompt, true)
  opts.sorter = vim.F.if_nil(opts.sorter, config.values.generic_sorter {})
  local push_history = vim.F.if_nil(opts.push_history, true)

  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local current_line = action_state.get_current_line()
  if push_history then
    action_state.get_current_history():append(current_line, current_picker)
  end

  -- title
  if opts.prompt_title and current_picker.prompt_border then
    current_picker.prompt_border:change_title(opts.prompt_title)
  end

  if opts.results_title and current_picker.results_border then
    current_picker.results_border:change_title(opts.results_title)
  end

  local results = {}
  for entry in current_picker.manager:iter() do
    table.insert(results, entry)
  end

  -- if opts.sorter == false, keep older sorter
  if opts.sorter then
    current_picker.sorter:_destroy()
    current_picker.sorter = opts.sorter
    current_picker.sorter:_init()
  end

  local new_finder = finders.new_table {
    results = results,
    entry_maker = function(x)
      return x
    end,
  }

  if not opts.reset_multi_selection and current_line ~= "" then
    opts.multi = current_picker._multi
  end

  if opts.prompt_to_prefix then
    local current_prefix = current_picker.prompt_prefix
    local suffix = current_prefix ~= opts.prompt_prefix and current_prefix or ""
    opts.new_prefix = suffix .. current_line .. " " .. opts.prompt_prefix
  end
  current_picker:refresh(new_finder, opts)
end

return action_generate
