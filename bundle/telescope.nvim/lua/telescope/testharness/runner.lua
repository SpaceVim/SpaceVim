local builtin = require "telescope.builtin"

local DELAY = vim.g.telescope_test_delay or 50
local runner = {}

-- State is test variable
runner.state = {
  done = false,
  results = {},
  msgs = {},
}

local writer = function(val)
  table.insert(runner.state.results, val)
end

local invalid_test_case = function(k)
  error { case = k, expected = "<a valid key>", actual = k }
end

local _VALID_KEYS = {
  post_typed = true,
  post_close = true,
}

local replace_terms = function(input)
  return vim.api.nvim_replace_termcodes(input, true, false, true)
end

runner.nvim_feed = function(text, feed_opts)
  feed_opts = feed_opts or "m"

  vim.api.nvim_feedkeys(text, feed_opts, true)
end

local end_test_cases = function()
  runner.state.done = true
end

local execute_test_case = function(location, key, spec)
  local ok, actual = pcall(spec[2])

  if not ok then
    writer {
      location = "Error: " .. location,
      case = key,
      expected = "To succeed and return: " .. tostring(spec[1]),
      actual = actual,

      _type = spec._type,
    }

    end_test_cases()
  else
    writer {
      location = location,
      case = key,
      expected = spec[1],
      actual = actual,

      _type = spec._type,
    }
  end

  return ok
end

runner.log = function(msg)
  table.insert(runner.state.msgs, msg)
end

runner.picker = function(picker_name, input, test_cases, opts)
  opts = opts or {}

  for k, _ in pairs(test_cases) do
    if not _VALID_KEYS[k] then
      return invalid_test_case(k)
    end
  end

  opts.on_complete = {
    runner.create_on_complete(input, test_cases),
  }

  opts._on_error = function(self, msg)
    runner.state.done = true
    writer {
      location = "Error while running on complete",
      expected = "To Work",
      actual = msg,
    }
  end

  runner.log "Starting picker"
  builtin[picker_name](opts)
  runner.log "Called picker"
end

runner.create_on_complete = function(input, test_cases)
  input = replace_terms(input)

  local actions = {}
  for i = 1, #input do
    local char = input:sub(i, i)
    table.insert(actions, {
      cb = function()
        runner.log("Inserting char: " .. char)
        runner.nvim_feed(char, "")
      end,
      char = char,
    })
  end

  return function()
    local action

    repeat
      action = table.remove(actions, 1)
      if action then
        action.cb()
      end
    until not action or string.match(action.char, "%g")

    if #actions > 0 then
      return
    end

    vim.defer_fn(function()
      if test_cases.post_typed then
        for k, v in ipairs(test_cases.post_typed) do
          if not execute_test_case("post_typed", k, v) then
            return
          end
        end
      end

      vim.defer_fn(function()
        runner.nvim_feed(replace_terms "<CR>", "")

        vim.defer_fn(function()
          if test_cases.post_close then
            for k, v in ipairs(test_cases.post_close) do
              if not execute_test_case("post_close", k, v) then
                return
              end
            end
          end

          vim.defer_fn(end_test_cases, DELAY)
        end, DELAY)
      end, DELAY)
    end, DELAY)
  end
end

return runner
