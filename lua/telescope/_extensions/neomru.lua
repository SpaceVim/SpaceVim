--=============================================================================
-- neomru.lua --- telescope neomru extension
-- Copyright (c) 2024 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local sp_file = require('spacevim.api').import('file')

local function prepare_output_table()
    local lines = {}
    local oldfiles = vim.fn['neomru#_gather_file_candidates']()

    for _, f in ipairs(oldfiles) do
        table.insert(lines, sp_file.unify_path(f, ':.'))
    end
    return lines
end

local function show_script_names(opts)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "Recent Files",
        finder = finders.new_table {
            results = prepare_output_table()
        },
        sorter = conf.generic_sorter(opts),
        previewer = conf.file_previewer({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local entry = action_state.get_selected_entry()
                -- print(vim.inspect(selection))
                -- vim.cmd("e " + entry.value)
                vim.cmd('e ' .. entry.value)
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
        neomru = run,
    },
})
