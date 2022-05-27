local finders = require('telescope.finders')
local previewers = require('telescope.previewers')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')

-- Get all the items from v:oldfiles that are valid files
local valid_oldfiles = vim.tbl_filter(function(val)
  return 0 ~= vim.fn.filereadable(val)
end, vim.v.oldfiles)

-- print(vim.inspect(valid_oldfiles))
-- => {
--      "/home/tj/blah.txt",
--      "/home/tj/another_dir/file.py",
--      ...
-- }

-- Create a finder from a Lua list.
local oldfiles_finder = finders.new_table(valid_oldfiles)

-- Get a pre-defined sorter.
--  Sorters return a "score" for each "Entry" found by a finder.
--
-- This sorter is optimized to best find files in a fuzzy manner.
local oldfiles_sorter = sorters.get_fuzzy_file()

-- Get a pre-defined previewer.
--  Previewers take the currently selected entry,
--  and put a preview of it in a floating window
local oldfiles_previewer = previewers.cat

-- Create and run a Picker.
--  Pickers are the main entry point to telescope.
--  They manage the interactions between:
--      Finder,
--      Sorter,
--      Previewer
--
--  And provide the UI for the user.
pickers.new {
  prompt = 'Oldfiles',
  finder = oldfiles_finder,
  sorter = oldfiles_sorter,
  previewer = oldfiles_previewer,
}:find()


