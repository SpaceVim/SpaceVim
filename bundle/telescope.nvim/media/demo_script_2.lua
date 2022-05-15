local finders = require('telescope.finders')
local previewers = require('telescope.previewers')
local pickers = require('telescope.pickers')

-- Create a new finder.
--  This finder, rather than taking a Lua list,
--  generates a shell command that should be run.
--
--  Each line of the shell command is converted to an entry,
--  and is possible to preview with builtin previews.
--
-- In this example, we use ripgrep to search over your entire directory
-- live as you type.
local live_grepper = finders.new_job(function(prompt)
  if not prompt or prompt == "" then
    return nil
  end

  return { 'rg', "--vimgrep", prompt}
end)

-- Create and run the Picker.
--
-- NOTE: No sorter is needed to be passed.
--       Results will be returned in the order they are received.
pickers.new({
  prompt    = 'Live Grep',
  finder    = live_grepper,
  previewer = previewers.vimgrep,
}):find()
