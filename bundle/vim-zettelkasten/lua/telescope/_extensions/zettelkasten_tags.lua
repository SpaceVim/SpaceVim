local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local browser = require('zettelkasten.browser')

local function unique_string_table(t)
  local temp = {}
  for _, k in ipairs(t) do
    temp[k] = true
  end
  local rst = {}
  for m, _ in pairs(temp) do
    table.insert(rst, m)
  end
  return rst
end

local function prepare_output_table()
    local lines = {}
    local result = browser.get_tags()

    for _, tag in ipairs(result) do
      table.insert(lines, tag.name)
    end
    return unique_string_table(lines)
end

local function show_script_names(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "ZettelKasten Tags",
    finder = finders.new_table {
      results = prepare_output_table()
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd('ZkBrowse --tags ' .. entry.value)
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
        zettelkasten_tags = run,
    },
})

