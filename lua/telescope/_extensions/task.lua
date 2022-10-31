local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local conf = require('telescope.config').values
local entry_display = require('telescope.pickers.entry_display')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')

local function prepare_project_task_output(register)
  local rst = {}
  local taskconfig = vim.api.nvim_eval('SpaceVim#plugins#tasks#get_tasks()')
  for k, v in pairs(taskconfig) do
    table.insert(rst, {
      name = k,
      task = v,
    })
  end
  return rst
end

local function show_taskconfig(opts)
  local opts = opts or {}
  local register = opts.register or '"'
  local displayer = entry_display.create({
    separator = ' ',
    items = {
      { width = 25 },
      { remaining = true },
    },
  })
  local function make_display(entry)
    local n = entry.value.name
    local desc = entry.value.task.description
    if desc == nil then
      desc = entry.value.task.command
      if entry.value.task.args ~= nil then
        desc = desc .. table.concat(entry.value.task.args, ' ')
      end
    end
    return displayer({
      { '[' .. entry.value.name .. ']', 'TelescopeResultsComment' },
      { desc, 'TelescopeResultsFunction' },
    })
  end
  pickers
    .new(opts, {
      prompt_title = 'Project Tasks',
      finder = finders.new_table({
        results = prepare_project_task_output(register),
        entry_maker = function(entry)
          return {
            value = entry,
            display = make_display,
            ordinal = entry.name,
          }
        end,
      }),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          -- vim.fn.setreg('"', entry.value[1])
          local task = entry.value.task
        end)
        return true
      end,
    })
    :find()
end

local function run()
  show_taskconfig()
end

return require('telescope').register_extension({
  exports = {
    -- Default when to argument is given, i.e. :Telescope neoyank
    task = run,
  },
})
