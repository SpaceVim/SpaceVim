local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local conf = require('telescope.config').values
local entry_display = require('telescope.pickers.entry_display')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local taskmanager = require('spacevim.plugin.tasks')
local runner = require('spacevim.plugin.runner')

local function prepare_project_task_output(register)
  local rst = {}
  local taskconfig = taskmanager.get_tasks()
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
      { width = 10 },
      { width = 15 },
      { remaining = true },
    },
  })
  local function make_display(entry)
    local n = entry.value.name
    local desc = entry.value.task.description
    if desc == nil then
      desc = entry.value.task.command
      if entry.value.task.args ~= nil then
        desc = desc .. ' ' .. table.concat(entry.value.task.args, ' ')
      end
    end
    local task_name = entry.value.name
    local task_type = 'local'
    if entry.value.task.isGlobal == 1 then
      task_type = 'global'
    elseif entry.value.task.isDetected == 1 then
      task_type = 'detected'
      task_name = (entry.value.task.detectedName or '') .. task_name
    end
    -- @todo the text maybe changed
    local background = 'no-background'
    if entry.value.task.isBackground then
      background = 'background'
    end
    return displayer({
      { '[' .. task_name .. ']', 'TelescopeResultsVariable' },
      { '[' .. task_type .. ']', 'TelescopeResultsNumber' },
      { '[' .. background .. ']', 'TelescopeResultsNumber' },
      { desc, 'TelescopeResultsComment' },
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
          runner.run_task(taskmanager.expand_task(entry.value.task))
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
