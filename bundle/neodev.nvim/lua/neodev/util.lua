local config = require("neodev.config")

local M = {}

--- find the root directory that has /lua
---@param path string?
---@return string?
function M.find_root(path)
  path = path or vim.api.nvim_buf_get_name(0)
  return vim.fs.find({ "lua" }, { path = path, upward = true, type = "directory" })[1]
end

function M.fetch(url)
  local fd = io.popen(string.format("curl -s -k %q", url))
  if not fd then
    error(("Could not download %s"):format(url))
  end
  local ret = fd:read("*a")
  fd:close()
  return ret
end

function M.is_nvim_config()
  local path = vim.loop.fs_realpath(vim.api.nvim_buf_get_name(0))
  if path then
    path = vim.fs.normalize(path)
    local config_root = vim.loop.fs_realpath(vim.fn.stdpath("config")) or vim.fn.stdpath("config")
    config_root = vim.fs.normalize(config_root)
    return path:find(config_root, 1, true) == 1
  end
  return false
end

function M.keys(tbl)
  local ret = vim.tbl_keys(tbl)
  table.sort(ret)
  return ret
end

---@generic K
---@generic V
---@param tbl table<K, V>
---@param fn fun(key: K, value: V)
function M.for_each(tbl, fn)
  local keys = M.keys(tbl)
  for _, key in ipairs(keys) do
    fn(key, tbl[key])
  end
end

---@param file string
---@param flags? string
---@return string
function M.read_file(file, flags)
  local fd = io.open(file, "r" .. (flags or ""))
  if not fd then
    error(("Could not open file %s for reading"):format(file))
  end
  local data = fd:read("*a")
  fd:close()
  return data
end

function M.write_file(file, data)
  local fd = io.open(file, "w+")
  if not fd then
    error(("Could not open file %s for writing"):format(file))
  end
  fd:write(data)
  fd:close()
end

function M.debug(msg)
  if config.options.debug then
    M.error(msg)
  end
end

function M.error(msg)
  vim.notify_once(msg, vim.log.levels.ERROR, { title = "neodev.nvim" })
end

function M.warn(msg)
  vim.notify_once(msg, vim.log.levels.WARN, { title = "neodev.nvim" })
end

return M
