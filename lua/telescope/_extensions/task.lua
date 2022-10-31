local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")

local function prepare_neoyank_output(register)
    local lines = {}
    local taskconfig = vim.api.nvim_eval('SpaceVim#plugins#tasks#get_tasks()')
    local yank = taskconfig[register] or {}

    for _, y in pairs(yank) do
        table.insert(lines, y)
    end
    return lines
end

local function show_taskconfig(opts)
    local opts = opts or {}
    local register = opts.register or '"'
    local displayer = entry_display.create({
        separator = ' ',
        items = {
            { width = 4 },
            { remaining = true },
        },
    })
    local function make_display(entry)
        -- print(vim.inspect(entry))
        return displayer({
            { '[' .. entry.value[2] .. ']', 'TelescopeResultsComment' },
            { entry.value[1]:gsub("\n", "\\n"), 'TelescopeResultsFunction' },
        })
    end
    pickers.new(opts, {
        prompt_title = "neoyank",
        finder = finders.new_table {
            results = prepare_neoyank_output(register),
            entry_maker = function(entry)
                return {
                    value = entry,
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
                local reg = vim.fn.getreg('"')
                vim.fn.setreg('"', entry.value[1])
                local ok, rst = pcall(vim.cmd, 'normal! p')
                if not ok then
                  vim.g._spacevim_temp_err = rst
                  -- @todo implement lua notify api
                  local notify = vim.api.nvim_eval('SpaceVim#api#notify#get().notify(g:_spacevim_temp_err, "WarningMsg")')
                end
                vim.fn.setreg('"', reg)
            end)
            return true
        end,
    }):find()
end

local function run()
    show_taskconfig()
end

return require("telescope").register_extension({
    exports = {
        -- Default when to argument is given, i.e. :Telescope neoyank
        neoyank = run,
    },
})


