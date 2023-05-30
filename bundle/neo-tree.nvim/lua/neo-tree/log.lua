-- log.lua
--
-- Inspired by rxi/log.lua
-- Modified by tjdevries and can be found at github.com/tjdevries/vlog.nvim
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.

local vim = vim
-- User configuration section
local default_config = {
  -- Name of the plugin. Prepended to log messages
  plugin = "neo-tree.nvim",

  -- Should print the output to neovim while running
  use_console = true,

  -- Should highlighting be used in console (using echohl)
  highlights = true,

  -- Should write to a file
  use_file = false,

  -- Any messages above this level will be logged.
  level = "info",

  -- Level configuration
  modes = {
    { name = "trace", hl = "None", level = vim.log.levels.TRACE },
    { name = "debug", hl = "None", level = vim.log.levels.DEBGUG },
    { name = "info", hl = "None", level = vim.log.levels.INFO },
    { name = "warn", hl = "WarningMsg", level = vim.log.levels.WARN },
    { name = "error", hl = "ErrorMsg", level = vim.log.levels.ERROR },
    { name = "fatal", hl = "ErrorMsg", level = vim.log.levels.ERROR },
  },

  -- Can limit the number of decimals displayed for floats
  float_precision = 0.01,
}

-- {{{ NO NEED TO CHANGE
local log = {}

local unpack = unpack or table.unpack

local notify = function(message, level_config)
  if type(vim.notify) == "table" then
    -- probably using nvim-notify
    vim.notify(message, level_config.level, { title = "Neo-tree" })
  else
    local nameupper = level_config.name:upper()
    local console_string = string.format("[Neo-tree %s] %s", nameupper, message)
    vim.notify(console_string, level_config.level)
  end
end

log.new = function(config, standalone)
  config = vim.tbl_deep_extend("force", default_config, config)

  local outfile =
    string.format("%s/%s.log", vim.api.nvim_call_function("stdpath", { "data" }), config.plugin)

  local obj
  if standalone then
    obj = log
  else
    obj = {}
  end
  obj.outfile = outfile

  obj.use_file = function(file, quiet)
    if file == false then
      if not quiet then
        obj.info("[neo-tree] Logging to file disabled")
      end
      config.use_file = false
    else
      if type(file) == "string" then
        obj.outfile = file
      else
        obj.outfile = outfile
      end
      config.use_file = true
      if not quiet then
        obj.info("[neo-tree] Logging to file: " .. obj.outfile)
      end
    end
  end

  local levels = {}
  for i, v in ipairs(config.modes) do
    levels[v.name] = i
  end

  obj.set_level = function(level)
    if levels[level] then
      if config.level ~= level then
        config.level = level
      end
    else
      notify("Invalid log level: " .. level, config.modes[5])
    end
  end

  local round = function(x, increment)
    increment = increment or 1
    x = x / increment
    return (x > 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)) * increment
  end

  local make_string = function(...)
    local t = {}
    for i = 1, select("#", ...) do
      local x = select(i, ...)

      if type(x) == "number" and config.float_precision then
        x = tostring(round(x, config.float_precision))
      elseif type(x) == "table" then
        x = vim.inspect(x)
        if #x > 300 then
          x = x:sub(1, 300) .. "..."
        end
      else
        x = tostring(x)
      end

      t[#t + 1] = x
    end
    return table.concat(t, " ")
  end

  local log_at_level = function(level, level_config, message_maker, ...)
    -- Return early if we're below the config.level
    if level < levels[config.level] then
      return
    end
    -- Ignnore this if vim is exiting
    if vim.v.dying > 0 or vim.v.exiting ~= vim.NIL then
      return
    end
    local nameupper = level_config.name:upper()

    local msg = message_maker(...)
    local info = debug.getinfo(2, "Sl")
    local lineinfo = info.short_src .. ":" .. info.currentline

    -- Output to log file
    if config.use_file then
      local str = string.format("[%-6s%s] %s: %s\n", nameupper, os.date(), lineinfo, msg)
      local fp = io.open(obj.outfile, "a")
      if fp then
        fp:write(str)
        fp:close()
      else
        print("[neo-tree] Could not open log file: " .. obj.outfile)
      end
    end

    -- Output to console
    if config.use_console and level > 2 then
      vim.schedule(function()
        notify(msg, level_config)
      end)
    end
  end

  for i, x in ipairs(config.modes) do
    obj[x.name] = function(...)
      return log_at_level(i, x, make_string, ...)
    end

    obj[("fmt_%s"):format(x.name)] = function()
      return log_at_level(i, x, function(...)
        local passed = { ... }
        local fmt = table.remove(passed, 1)
        local inspected = {}
        for _, v in ipairs(passed) do
          table.insert(inspected, vim.inspect(v))
        end
        return string.format(fmt, unpack(inspected))
      end)
    end
  end
end

log.new(default_config, true)
-- }}}

return log
