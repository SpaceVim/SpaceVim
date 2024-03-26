--=============================================================================
-- bookmarks.lua --- telescope support for bookmarks
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local conf = require('telescope.config').values
local entry_display = require('telescope.pickers.entry_display')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local pm = require('spacevim.plugin.projectmanager')
local file = require('spacevim.api.file')

local function get_all_bookmarks()
  local p = {}
  local files = vim.fn['bm#all_files']()

  for _, k in ipairs(files) do
    local line_nrs = vim.fn['bm#all_lines'](k)
    for _, line_nr in ipairs(line_nrs) do
      local bookmark = vim.fn['bm#get_bookmark_by_line'](k, line_nr)

      local text = 'EMPTY LINE'
      if #bookmark.annotation > 0 then
        text = bookmark.annotation
      elseif #bookmark.content > 0 then
        text = bookmark.content
      end
      table.insert(p, {
        file = file.unify_path(k, ':.'),
        linenr = line_nr,
        text = text,
      })
    end
  end
  return p
end

local function show_changes(opts)
  opts = opts or {}
  local displayer = entry_display.create({
    separator = ' ',
    items = {
      { width = 60 },
      { remaining = true },
    },
  })
  local function make_display(entry)
    -- print(vim.inspect(entry))
    return displayer({
      { entry.value.file .. ':' .. entry.value.linenr, 'TelescopeResultsVariable' },
      { entry.value.text, 'TelescopeResultsComment' },
    })
  end
  pickers
    .new(opts, {
      prompt_title = 'Bookmarks',
      finder = finders.new_table({
        results = get_all_bookmarks(),
        entry_maker = function(entry)
          return {
            value = entry,
            display = make_display,
            ordinal = entry.file,
          }
        end,
      }),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          vim.cmd('e ' .. entry.value.file)
          vim.api.nvim_win_set_cursor(0, { entry.value.linenr, 1 })
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
    bookmarks = run,
  },
})
