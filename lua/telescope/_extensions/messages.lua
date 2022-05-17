local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")

local function prepare_output_table()
  local lines = {}
  local changes = vim.api.nvim_command_output("messages")

  for change in changes:gmatch("[^\r\n]+") do
      table.insert(lines, change)
  end
  return lines
end

local function show_changes(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Messages",
    finder = finders.new_table {
      results = prepare_output_table()
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        local reg = vim.fn.getreg('*')
        vim.fn.setreg('*', entry.value)
        vim.cmd("put *")
        vim.fn.setreg('*', reg)
      end)
      return true
    end,
  }):find()
end

local function run()
  show_changes()
end

return require("telescope").register_extension({
  exports = {
    -- Default when to argument is given, i.e. :Telescope changes
    messages = run,
  },
})
