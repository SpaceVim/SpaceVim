local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local previewers = require "telescope.previewers"
local pickers = require "telescope.pickers"
local sorters = require "telescope.sorters"

local helpers = {}

-- TODO: We should do something with builtins to get those easily.
helpers.auto_find_files = function(opts)
  opts = opts or {}
  opts.prompt_prefix = ""

  local find_command = opts.find_command

  if not find_command then
    if 1 == vim.fn.executable "fd" then
      find_command = { "fd", "--type", "f" }
    elseif 1 == vim.fn.executable "fdfind" then
      find_command = { "fdfind", "--type", "f" }
    elseif 1 == vim.fn.executable "rg" then
      find_command = { "rg", "--files" }
    end
  end

  if opts.cwd then
    opts.cwd = vim.fn.expand(opts.cwd)
  end

  opts.entry_maker = opts.entry_maker or make_entry.gen_from_file(opts)

  local p = pickers.new(opts, {
    prompt = "Find Files",
    finder = finders.new_oneshot_job(find_command, opts),
    previewer = previewers.cat.new(opts),
    sorter = sorters.get_fuzzy_file(),

    track = true,
  })

  local count = 0
  p:register_completion_callback(function(s)
    print(
      count,
      vim.inspect(s.stats, {
        process = function(item)
          if type(item) == "string" and item:sub(1, 1) == "_" then
            return nil
          end

          return item
        end,
      })
    )

    count = count + 1
  end)

  local feed = function(text, feed_opts)
    feed_opts = feed_opts or "n"
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(text, true, false, true), feed_opts, true)
  end

  p:register_completion_callback(coroutine.wrap(function()
    local input = opts.input

    for i = 1, #input do
      feed(input:sub(i, i))
      coroutine.yield()
    end

    vim.wait(300, function() end)
    feed("<CR>", "")

    vim.defer_fn(function()
      PASSED = opts.condition()
      COMPLETED = true
    end, 500)

    coroutine.yield()
  end))

  p:find()
end

return helpers
