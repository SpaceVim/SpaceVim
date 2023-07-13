local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local conf = require('telescope.config').values
local entry_display = require('telescope.pickers.entry_display')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local pm = require('spacevim.plugin.projectmanager')

local function get_all_projects()
  local p = {}
  local projects = pm.get_project_history()

  for _, k in pairs(projects) do
    table.insert(p, k)
  end
  return p
end

local function show_changes(opts)
  opts = opts or {}
  local displayer = entry_display.create({
    separator = ' ',
    items = {
      { width = 20 },
      { width = vim.o.columns - 100 },
      { remaining = true },
    },
  })
  local function make_display(entry)
    -- print(vim.inspect(entry))
    return displayer({
      { '[' .. entry.value.name .. ']', 'TelescopeResultsVariable' },
      { entry.value.path, 'TelescopeResultsFunction' },
      {
        '<' .. vim.fn.strftime('%Y-%m-%d %T', entry.value.opened_time) .. '>',
        'TelescopeResultsComment',
      },
    })
  end
  pickers
    .new(opts, {
      prompt_title = 'Projects',
      finder = finders.new_table({
        results = get_all_projects(),
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
          pm.open(entry.value.path)
        end)
        return true
      end,
    })
    :find()
end

local function run()
  show_changes()
end

return require('telescope').register_extension({
  exports = {
    -- Default when to argument is given, i.e. :Telescope project
    project = run,
  },
})
