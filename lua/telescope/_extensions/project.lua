local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")

local function get_all_projects()
    local p = {}
    local projects = vim.api.nvim_eval('g:unite_source_menu_menus.Projects.command_candidates')

    for _, project in pairs(projects) do
        table.insert(p, project)
    end
    return p
end

local function show_changes(opts)
    opts = opts or {}
    local displayer = entry_display.create({
        separator = ' ',
        items = {
            { width = 20  },
            { width = vim.api.nvim_win_get_width(0) - 60 },
            { remaining = true },
        },
    })
    local function make_display(entry)
        -- print(vim.inspect(entry))
        return displayer({
            { '[' .. entry.value.name .. ']', 'TelescopeResultsVariable' },
            { entry.value.path, 'TelescopeResultsFunction' },
            { '<' .. vim.fn.strftime('%Y-%m-%d %T', entry.value.opened_time) .. '>', 'TelescopeResultsComment' },
        })
    end
    pickers.new(opts, {
        prompt_title = "Projects",
        finder = finders.new_table {
            results = get_all_projects(),
            entry_maker = function(entry)
                return {
                    value = entry[3],
                    command = entry[2],
                    display = make_display,
                    ordinal = entry[1]
                }
            end
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                local entry = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd(entry.command)
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
        -- Default when to argument is given, i.e. :Telescope project
        project = run,
    },
})

