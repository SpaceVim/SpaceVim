local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local zk_config = require("zettelkasten.config")

local function prepare_output_table()
    local lines = {}
    local result = vim.fn.globpath(zk_config.templete_dir, '**/*', 0, 1)

    for _, templete in ipairs(result) do
      table.insert(lines, templete)
    end
    return lines
end

local function show_script_names(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "ZettelKasten Templete",
    finder = finders.new_table {
      results = prepare_output_table()
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        -- the file name is entry.value
        -- do something with the file
        vim.cmd('ZkNew')
        local templete_context = vim.fn.readfile(entry.value, '')
        vim.api.nvim_buf_set_lines(0, 0, -1, false, templete_context)
        -- maybe this is a bug, the mode is insert mode.
        vim.cmd('stopinsert')
      end)
      return true
    end,
  }):find()
end

local function run()
    show_script_names()
end

return require("telescope").register_extension({
    exports = {
        -- Default when to argument is given, i.e. :Telescope scriptnames
        zettelkasten_template = run,
    },
})
