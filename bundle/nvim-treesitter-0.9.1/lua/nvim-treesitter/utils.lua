local api = vim.api
local fn = vim.fn
local luv = vim.loop

local M = {}

-- Wrapper around vim.notify with common options set.
---@param msg string
---@param log_level number|nil
---@param opts table|nil
function M.notify(msg, log_level, opts)
  local default_opts = { title = "nvim-treesitter" }
  vim.notify(msg, log_level, vim.tbl_extend("force", default_opts, opts or {}))
end

-- Returns the system-specific path separator.
---@return string
function M.get_path_sep()
  return (fn.has "win32" == 1 and not vim.opt.shellslash:get()) and "\\" or "/"
end

-- Returns a function that joins the given arguments with separator. Arguments
-- can't be nil. Example:
--
--[[
  print(M.generate_join(" ")("foo", "bar"))
--]]
--prints "foo bar"
---@param separator string
---@return fun(...: string): string
function M.generate_join(separator)
  return function(...)
    return table.concat({ ... }, separator)
  end
end

M.join_path = M.generate_join(M.get_path_sep())

M.join_space = M.generate_join " "

---@class Command
---@field run function
---@field f_args string
---@field args string

-- Define user defined vim command which calls nvim-treesitter module function
--     - If module name is 'mod', it should be defined in hierarchy 'nvim-treesitter.mod'
--     - A table with name 'commands' should be defined in 'mod' which needs to be passed as
--       the commands param of this function
--
---@param mod string  Name of the module that resides in the hierarchy - nvim-treesitter.module
---@param commands table<string, Command>  Command list for the module
---         - {command_name} Name of the vim user defined command, Keys:
---             - {run}: (function) callback function that needs to be executed
---             - {f_args}: (string, default <f-args>)
---                 - type of arguments that needs to be passed to the vim command
---             - {args}: (string, optional)
---                 - vim command attributes
---
---* @example
---  If module is nvim-treesitter.custom_mod
---  <pre>
---  M.commands = {
---      custom_command = {
---          run = M.module_function,
---          f_args = "<f-args>",
---          args = {
---              "-range"
---          }
---      }
---  }
---
---  utils.setup_commands("custom_mod", require("nvim-treesitter.custom_mod").commands)
---  </pre>
---
---  Will generate command :
---  <pre>
---  command! -range custom_command \
---      lua require'nvim-treesitter.custom_mod'.commands.custom_command['run<bang>'](<f-args>)
---  </pre>
function M.setup_commands(mod, commands)
  for command_name, def in pairs(commands) do
    local f_args = def.f_args or "<f-args>"
    local call_fn =
      string.format("lua require'nvim-treesitter.%s'.commands.%s['run<bang>'](%s)", mod, command_name, f_args)
    local parts = vim.tbl_flatten {
      "command!",
      "-bar",
      def.args,
      command_name,
      call_fn,
    }
    api.nvim_command(table.concat(parts, " "))
  end
end

---@param dir string
---@param create_err string
---@param writeable_err string
---@return string|nil, string|nil
function M.create_or_reuse_writable_dir(dir, create_err, writeable_err)
  create_err = create_err or M.join_space("Could not create dir '", dir, "': ")
  writeable_err = writeable_err or M.join_space("Invalid rights, '", dir, "' should be read/write")
  -- Try creating and using parser_dir if it doesn't exist
  if not luv.fs_stat(dir) then
    local ok, error = pcall(vim.fn.mkdir, dir, "p", "0755")
    if not ok then
      return nil, M.join_space(create_err, error)
    end

    return dir
  end

  -- parser_dir exists, use it if it's read/write
  if luv.fs_access(dir, "RW") then
    return dir
  end

  -- parser_dir exists but isn't read/write, give up
  return nil, M.join_space(writeable_err, dir, "'")
end

function M.get_package_path()
  -- Path to this source file, removing the leading '@'
  local source = string.sub(debug.getinfo(1, "S").source, 2)

  -- Path to the package root
  return fn.fnamemodify(source, ":p:h:h:h")
end

function M.get_cache_dir()
  local cache_dir = fn.stdpath "data"

  if luv.fs_access(cache_dir, "RW") then
    return cache_dir
  elseif luv.fs_access("/tmp", "RW") then
    return "/tmp"
  end

  return nil, M.join_space("Invalid cache rights,", fn.stdpath "data", "or /tmp should be read/write")
end

-- Returns $XDG_DATA_HOME/nvim/site, but could use any directory that is in
-- runtimepath
function M.get_site_dir()
  return M.join_path(fn.stdpath "data", "site")
end

-- Gets a property at path
---@param tbl table the table to access
---@param path string the '.' separated path
---@return table|nil result the value at path or nil
function M.get_at_path(tbl, path)
  if path == "" then
    return tbl
  end

  local segments = vim.split(path, ".", true)
  ---@type table[]|table
  local result = tbl

  for _, segment in ipairs(segments) do
    if type(result) == "table" then
      ---@type table
      -- TODO: figure out the actual type of tbl
      result = result[segment]
    end
  end

  return result
end

function M.set_jump()
  vim.cmd "normal! m'"
end

-- Filters a list based on the given predicate
---@param tbl any[] The list to filter
---@param predicate fun(v:any, i:number):boolean The predicate to filter with
function M.filter(tbl, predicate)
  local result = {}

  for i, v in ipairs(tbl) do
    if predicate(v, i) then
      table.insert(result, v)
    end
  end

  return result
end

-- Returns a list of all values from the first list
-- that are not present in the second list.
---@param tbl1 any[] The first table
---@param tbl2 any[] The second table
---@return table
function M.difference(tbl1, tbl2)
  return M.filter(tbl1, function(v)
    return not vim.tbl_contains(tbl2, v)
  end)
end

function M.identity(a)
  return a
end

-- Returns a function returning the given value
---@param a any
---@return fun():any
function M.constant(a)
  return function()
    return a
  end
end

-- Returns a function that returns the given value if it is a function,
-- otherwise returns a function that returns the given value.
---@param a any
---@return fun(...):any
function M.to_func(a)
  return type(a) == "function" and a or M.constant(a)
end

---@return string|nil
function M.ts_cli_version()
  if fn.executable "tree-sitter" == 1 then
    local handle = io.popen "tree-sitter -V"
    if not handle then
      return
    end
    local result = handle:read "*a"
    handle:close()
    return vim.split(result, "\n")[1]:match "[^tree%psitter ].*"
  end
end

return M
