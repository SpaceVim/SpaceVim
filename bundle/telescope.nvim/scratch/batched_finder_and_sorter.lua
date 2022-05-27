local actions = require('telescope.actions')
local finders = require('telescope.finders')
local previewers = require('telescope.previewers')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local utils = require('telescope.utils')

local Job = require('plenary.job')

-- local live_grepper = finders.new {
--   fn_command = function(_, prompt)
--     -- TODO: Make it so that we can start searching on the first character.
--     if not prompt or prompt == "" then
--       return nil
--     end

--     return {
--       command = 'rg',
--       args = {"--vimgrep", prompt},
--     }
--   end
-- }

local f = function(prompt, process_result, process_complete)
  local fzf = Job:new {
    command = 'fzf';

    writer = Job:new {
      command = "fdfind",
      args = nil,
      cwd = "/home/tj/build/neovim",

      enable_handlers = false,
    },

    -- Still doesn't work if you don't pass these args and just run `fzf`
    args = {'--no-sort', '--filter', prompt};
  }


  local start = vim.fn.reltime()
  print(vim.inspect(fzf:sync()), vim.fn.reltimestr(vim.fn.reltime(start)))
end


-- Process all the files
-- f("", nil, nil)
-- Filter on nvimexec
f("nvim/executor", nil, nil)

-- pickers.new({}, {
--   prompt    = 'Live Grep',
--   finder    = f,
--   previewer = previewers.vimgrep,
-- }):find()
