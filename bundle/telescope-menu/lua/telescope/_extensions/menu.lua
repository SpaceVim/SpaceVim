local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")

local function prepare_menu(menu)
    local p = {}
    local projects = vim.api.nvim_eval('g:unite_source_menu_menus.' .. menu .. '.command_candidates')

    for _, project in pairs(projects) do
        table.insert(p, project)
    end
    return p
end

local function show_menu(opts)
    opts = opts or {}
    local menu = opts.menu or ''
    pickers.new(opts, {
        prompt_title = "Menu:" .. menu,
        finder = finders.new_table {
            results = prepare_menu(menu),
            entry_maker = function(entry)
                return {
                    command = entry[2],
                    display = entry[1],
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

local function run(opts)
  show_menu(opts)
end

return require("telescope").register_extension({
  exports = {
    -- Default when to argument is given, i.e. :Telescope menu menu=CustomKeyMaps
    menu = run,
  },
})
