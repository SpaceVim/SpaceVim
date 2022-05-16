---@tag telescope.command
---@config { ["module"] = "telescope.command" }

---@brief [[
---
--- Telescope commands can be called through two apis,
--- the lua api and the viml api.
---
--- The lua api is the more direct way to interact with Telescope, as you directly call the
--- lua functions that Telescope defines.
--- It can be called in a lua file using commands like:
--- <pre>
--- `require("telescope.builtin").find_files({hidden=true, layout_config={prompt_position="top"}})`
--- </pre>
--- If you want to use this api from a vim file you should prepend `lua` to the command, as below:
--- <pre>
--- `lua require("telescope.builtin").find_files({hidden=true, layout_config={prompt_position="top"}})`
--- </pre>
--- If you want to use this api from a neovim command line you should prepend `:lua` to
--- the command, as below:
--- <pre>
--- `:lua require("telescope.builtin").find_files({hidden=true, layout_config={prompt_position="top"}})`
--- </pre>
---
--- The viml api is more indirect, as first the command must be parsed to the relevant lua
--- equivalent, which brings some limitations.
--- The viml api can be called using commands like:
--- <pre>
--- `:Telescope find_files hidden=true layout_config={"prompt_position":"top"}`
--- </pre>
--- This involves setting options using an `=` and using viml syntax for lists and
--- dictionaries when the corresponding lua function requires a table.
---
--- One limitation of the viml api is that there can be no spaces in any of the options.
--- For example, if you want to use the `cwd` option for `find_files` to specify that you
--- only want to search within the folder `/foo bar/subfolder/` you could not do that using the
--- viml api, as the path name contains a space.
--- Similarly, you could NOT set the `prompt_position` to `"top"` using the following command:
--- <pre>
--- `:Telescope find_files layout_config={ "prompt_position" : "top" }`
--- </pre>
--- as there are spaces in the option.
---
---@brief ]]
local themes = require "telescope.themes"
local builtin = require "telescope.builtin"
local extensions = require("telescope._extensions").manager
local config = require "telescope.config"
local utils = require "telescope.utils"
local command = {}

local arg_value = {
  ["nil"] = nil,
  ['""'] = "",
  ['"'] = "",
}

local bool_type = {
  ["false"] = false,
  ["true"] = true,
}

local split_keywords = {
  ["find_command"] = true,
  ["vimgrep_arguments"] = true,
  ["sections"] = true,
  ["search_dirs"] = true,
  ["symbols"] = true,
  ["ignore_symbols"] = true,
}

-- convert command line string arguments to
-- lua number boolean type and nil value
command.convert_user_opts = function(user_opts)
  local default_opts = config.values

  local _switch = {
    ["boolean"] = function(key, val)
      if val == "false" then
        user_opts[key] = false
        return
      end
      user_opts[key] = true
    end,
    ["number"] = function(key, val)
      user_opts[key] = tonumber(val)
    end,
    ["string"] = function(key, val)
      if arg_value[val] ~= nil then
        user_opts[key] = arg_value[val]
        return
      end

      if bool_type[val] ~= nil then
        user_opts[key] = bool_type[val]
      end
    end,
    ["table"] = function(key, val)
      local ok, eval = pcall(vim.fn.eval, val)
      if ok then
        user_opts[key] = eval
      else
        local err
        eval, err = loadstring("return " .. val)
        if err ~= nil then
          -- discard invalid lua expression
          user_opts[key] = nil
        elseif eval ~= nil then
          ok, eval = pcall(eval)
          if ok and type(eval) == "table" then
            -- allow if return a table only
            user_opts[key] = eval
          else
            -- otherwise return nil (allows split check later)
            user_opts[key] = nil
          end
        end
      end
    end,
  }

  local _switch_metatable = {
    __index = function(_, k)
      utils.notify("command", {
        msg = string.format("Type of '%s' does not match", k),
        level = "WARN",
      })
    end,
  }

  setmetatable(_switch, _switch_metatable)

  for key, val in pairs(user_opts) do
    if split_keywords[key] then
      _switch["table"](key, val)
      if user_opts[key] == nil then
        user_opts[key] = vim.split(val, ",")
      end
    elseif default_opts[key] ~= nil then
      _switch[type(default_opts[key])](key, val)
    elseif tonumber(val) ~= nil then
      _switch["number"](key, val)
    else
      _switch["string"](key, val)
    end
  end
end

-- receive the viml command args
-- it should be a table value like
-- {
--   cmd = 'find_files',
--   theme = 'dropdown',
--   extension_type  = 'command'
--   opts = {
--      cwd = '***',
-- }
local function run_command(args)
  local user_opts = args or {}
  if next(user_opts) == nil and not user_opts.cmd then
    utils.notify("command", {
      msg = "Command missing arguments",
      level = "ERROR",
    })
    return
  end

  local cmd = user_opts.cmd
  local opts = user_opts.opts or {}
  local extension_type = user_opts.extension_type or ""
  local theme = user_opts.theme or ""

  if next(opts) ~= nil then
    command.convert_user_opts(opts)
  end

  if string.len(theme) > 0 then
    local func = themes[theme] or themes["get_" .. theme]
    opts = func(opts)
  end

  if string.len(extension_type) > 0 and extension_type ~= '"' then
    extensions[cmd][extension_type](opts)
    return
  end

  if builtin[cmd] then
    builtin[cmd](opts)
    return
  end

  if rawget(extensions, cmd) then
    extensions[cmd][cmd](opts)
    return
  end

  utils.notify("run_command", {
    msg = "Unknown command",
    level = "ERROR",
  })
end

-- @Summary get extensions sub command
-- register extensions dap gh etc.
-- input in command line `Telescope gh <TAB>`
-- Returns a list for each extension.
function command.get_extensions_subcommand()
  local exts = require("telescope._extensions").manager
  local complete_ext_table = {}
  for cmd, value in pairs(exts) do
    if type(value) == "table" then
      local subcmds = {}
      for key, _ in pairs(value) do
        table.insert(subcmds, key)
      end
      complete_ext_table[cmd] = subcmds
    end
  end
  return complete_ext_table
end

function command.register_keyword(keyword)
  split_keywords[keyword] = true
end

function command.load_command(cmd, ...)
  local args = { ... }
  if cmd == nil then
    run_command { cmd = "builtin" }
    return
  end

  local user_opts = {
    cmd = cmd,
    opts = {},
  }

  for _, arg in ipairs(args) do
    if arg:find("=", 1) == nil then
      user_opts["extension_type"] = arg
    else
      local param = vim.split(arg, "=")
      local key = table.remove(param, 1)
      param = table.concat(param, "=")
      if key == "theme" then
        user_opts["theme"] = param
      else
        user_opts.opts[key] = param
      end
    end
  end

  run_command(user_opts)
end

return command
