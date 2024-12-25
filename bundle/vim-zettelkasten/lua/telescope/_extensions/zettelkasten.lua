local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local conf = require('telescope.config').values
local entry_display = require('telescope.pickers.entry_display')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local browser = require('zettelkasten.browser')
local hi = require('spacevim.api.vim.highlight')

local function get_all_zettelkasten_notes()
  local p = {}
  local notes = browser.get_notes()
  for _, k in pairs(notes) do
    table.insert(p, k)
  end
  return p
end

local function concat_tags(t)
  
    local tags = {}
    for _, tag in ipairs(t) do
      if vim.tbl_contains(tags, tag.name) == false then
        table.insert(tags, tag.name)
      end
    end

    return table.concat(tags, ' ')
end

local function show_changes(opts)
  opts = opts or {}
  local displayer = entry_display.create({
    separator = ' ',
    items = {
      { width = 23 },
      { width = vim.o.columns - 100 },
      { remaining = true },
    },
  })
  local function make_display(entry)
    local normal = hi.group2dict('Normal')
    hi.hi({
    name = 'NormalFG', guifg = normal.guifg})
    return displayer({
      { vim.fn.fnamemodify(entry.value.file_name, ':t'), 'String' },
      { entry.value.title, 'NormalFG' },
      {
        concat_tags(entry.value.tags),
        'Tag',
      },
    })
  end
  pickers
    .new(opts, {
      prompt_title = 'ZettelKasten Notes',
      finder = finders.new_table({
        results = get_all_zettelkasten_notes(),
        entry_maker = function(entry)
          return {
            value = entry,
            display = make_display,
            ordinal = entry.title,
          }
        end,
      }),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          vim.cmd('e ' .. entry.value.file_name)
        end)
        actions.select_tab:replace(function()
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          vim.cmd('tabedit ' .. entry.value.file_name)
        end)
        actions.select_vertical:replace(function()
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          vim.cmd('vsplit ' .. entry.value.file_name)
        end)
        actions.select_horizontal:replace(function()
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          vim.cmd('split ' .. entry.value.file_name)
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
    zettelkasten = run,
  },
})
