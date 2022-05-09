local has_notify, notify = pcall(require, "notify")

local a = vim.api
local uv = vim.loop

local M = {}

M.is_windows = vim.fn.has "win32" == 1 or vim.fn.has "win32unix" == 1

function M.path_to_matching_str(path)
  return path:gsub("(%-)", "(%%-)"):gsub("(%.)", "(%%.)"):gsub("(%_)", "(%%_)")
end

function M.warn(msg)
  vim.schedule(function()
    if has_notify then
      notify(msg, vim.log.levels.WARN, { title = "NvimTree" })
    else
      vim.notify("[NvimTree] " .. msg, vim.log.levels.WARN)
    end
  end)
end

function M.str_find(haystack, needle)
  return vim.fn.stridx(haystack, needle) ~= -1
end

function M.read_file(path)
  local fd = uv.fs_open(path, "r", 438)
  if not fd then
    return ""
  end
  local stat = uv.fs_fstat(fd)
  if not stat then
    return ""
  end
  local data = uv.fs_read(fd, stat.size, 0)
  uv.fs_close(fd)
  return data or ""
end

local path_separator = package.config:sub(1, 1)
function M.path_join(paths)
  return table.concat(vim.tbl_map(M.path_remove_trailing, paths), path_separator)
end

function M.path_split(path)
  return path:gmatch("[^" .. path_separator .. "]+" .. path_separator .. "?")
end

---Get the basename of the given path.
---@param path string
---@return string
function M.path_basename(path)
  path = M.path_remove_trailing(path)
  local i = path:match("^.*()" .. path_separator)
  if not i then
    return path
  end
  return path:sub(i + 1, #path)
end

---Get a path relative to another path.
---@param path string
---@param relative_to string
---@return string
function M.path_relative(path, relative_to)
  local p, _ = path:gsub("^" .. M.path_to_matching_str(M.path_add_trailing(relative_to)), "")
  return p
end

function M.path_add_trailing(path)
  if path:sub(-1) == path_separator then
    return path
  end

  return path .. path_separator
end

function M.path_remove_trailing(path)
  local p, _ = path:gsub(path_separator .. "$", "")
  return p
end

M.path_separator = path_separator

function M.clear_prompt()
  vim.api.nvim_command "normal! :"
end

function M.get_user_input_char()
  local c = vim.fn.getchar()
  while type(c) ~= "number" do
    c = vim.fn.getchar()
  end
  return vim.fn.nr2char(c)
end

-- get the node from the tree that matches the predicate
-- @param nodes list of node
-- @param fn    function(node): boolean
function M.find_node(nodes, fn)
  local function iter(nodes_, fn_)
    local i = 1
    for _, node in ipairs(nodes_) do
      if fn_(node) then
        return node, i
      end
      if node.open and #node.nodes > 0 then
        local n, idx = iter(node.nodes, fn_)
        i = i + idx
        if n then
          return n, i
        end
      else
        i = i + 1
      end
    end
    return nil, i
  end
  local node, i = iter(nodes, fn)
  i = require("nvim-tree.view").View.hide_root_folder and i - 1 or i
  return node, i
end

---Matching executable files in Windows.
---@param ext string
---@return boolean
local PATHEXT = vim.env.PATHEXT or ""
local wexe = vim.split(PATHEXT:gsub("%.", ""), ";")
local pathexts = {}
for _, v in pairs(wexe) do
  pathexts[v] = true
end

function M.is_windows_exe(ext)
  return pathexts[ext:upper()]
end

function M.rename_loaded_buffers(old_path, new_path)
  for _, buf in pairs(a.nvim_list_bufs()) do
    if a.nvim_buf_is_loaded(buf) then
      local buf_name = a.nvim_buf_get_name(buf)
      local exact_match = buf_name == old_path
      local child_match = (
        buf_name:sub(1, #old_path) == old_path and buf_name:sub(#old_path + 1, #old_path + 1) == path_separator
      )
      if exact_match or child_match then
        a.nvim_buf_set_name(buf, new_path .. buf_name:sub(#old_path + 1))
        -- to avoid the 'overwrite existing file' error message on write for
        -- normal files
        if a.nvim_buf_get_option(buf, "buftype") == "" then
          a.nvim_buf_call(buf, function()
            vim.cmd "silent! write!"
          end)
        end
      end
    end
  end
end

--- @param path string path to file or directory
--- @return boolean
function M.file_exists(path)
  local _, error = vim.loop.fs_stat(path)
  return error == nil
end

--- @param path string
--- @return string
function M.canonical_path(path)
  if M.is_windows and path:match "^%a:" then
    return path:sub(1, 1):upper() .. path:sub(2)
  end
  return path
end

-- Create empty sub-tables if not present
-- @param tbl to create empty inside of
-- @param sub dot separated string of sub-tables
-- @return deepest sub-table
function M.table_create_missing(tbl, sub)
  if tbl == nil then
    return nil
  end

  local t = tbl
  for s in string.gmatch(sub, "([^%.]+)%.*") do
    if t[s] == nil then
      t[s] = {}
    end
    t = t[s]
  end

  return t
end

function M.format_bytes(bytes)
  local units = { "B", "K", "M", "G", "T" }

  bytes = math.max(bytes, 0)
  local pow = math.floor((bytes and math.log(bytes) or 0) / math.log(1024))
  pow = math.min(pow, #units)

  local value = bytes / (1024 ^ pow)
  value = math.floor((value * 10) + 0.5) / 10

  pow = pow + 1

  return (units[pow] == nil) and (bytes .. "B") or (value .. units[pow])
end

function M.key_by(tbl, key)
  local keyed = {}
  for _, val in ipairs(tbl) do
    keyed[val[key]] = val
  end
  return keyed
end

return M
