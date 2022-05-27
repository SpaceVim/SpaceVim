local utils = require "nvim-tree.utils"

local M = {
  ignore_list = {},
  exclude_list = {},
}

local function is_excluded(path)
  for _, node in ipairs(M.exclude_list) do
    if path:match(node) then
      return true
    end
  end
  return false
end

---Check if the given path should be ignored.
---@param path string Absolute path
---@return boolean
function M.should_ignore(path)
  local basename = utils.path_basename(path)

  if is_excluded(path) then
    return false
  end

  if M.config.filter_dotfiles then
    if basename:sub(1, 1) == "." then
      return true
    end
  end

  if not M.config.filter_custom then
    return false
  end

  local relpath = utils.path_relative(path, vim.loop.cwd())
  for pat, _ in pairs(M.ignore_list) do
    if vim.fn.match(relpath, pat) ~= -1 or vim.fn.match(basename, pat) ~= -1 then
      return true
    end
  end

  local idx = path:match ".+()%.[^.]+$"
  if idx then
    if M.ignore_list["*" .. string.sub(path, idx)] == true then
      return true
    end
  end

  return false
end

function M.should_ignore_git(path, status)
  return M.config.filter_git_ignored
    and (M.config.filter_git_ignored and status and status[path] == "!!")
    and not is_excluded(path)
end

function M.setup(opts)
  M.config = {
    filter_custom = true,
    filter_dotfiles = opts.filters.dotfiles,
    filter_git_ignored = opts.git.ignore,
  }

  M.exclude_list = opts.filters.exclude

  local custom_filter = opts.filters.custom
  if custom_filter and #custom_filter > 0 then
    for _, filter_name in pairs(custom_filter) do
      M.ignore_list[filter_name] = true
    end
  end
end

return M
