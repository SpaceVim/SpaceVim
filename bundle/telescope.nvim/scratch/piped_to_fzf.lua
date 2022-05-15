RELOAD('telescope')
RELOAD('plenary')

local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')

local Job = require('plenary.job')

pickers.new {
  prompt = "Piped FZF",

  finder = finders._new {
    fn_command = function(_, prompt)
      return {
        command = 'fzf',
        args = {'--no-sort', '--filter', prompt or ''},

        writer = Job:new {
          command = 'rg',
          args = {'--files'},
          cwd = '/home/tj/',

          enable_handlers = false,
        },
      }
    end,

    entry_maker = make_entry.gen_from_file(),
    sorter = sorters.get_fuzzy_file(),
  },
}:find()
