local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local sp_file = require('spacevim.api').import('file')
local zk_config = require("zettelkasten.config")

local function prepare_output_table()
    local lines = {}
    local result = vim.split(vim.fn.globpath(zk_config.templete_dir, '**/*'), "\n")

    for templete in ipairs(result) do
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
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local entry = action_state.get_selected_entry()
                -- print(vim.inspect(selection))
                -- vim.cmd("e " + entry.value)
                vim.cmd('e ' .. vim.fn.split(entry.value, ": ")[2])
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
