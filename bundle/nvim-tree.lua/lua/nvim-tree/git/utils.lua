local M = {}

function M.get_toplevel(cwd)
  local cmd = "git -C " .. vim.fn.shellescape(cwd) .. " rev-parse --show-toplevel"
  local toplevel = vim.fn.system(cmd)

  if not toplevel or #toplevel == 0 or toplevel:match "fatal" then
    return nil
  end

  -- git always returns path with forward slashes
  if vim.fn.has "win32" == 1 then
    toplevel = toplevel:gsub("/", "\\")
  end

  -- remove newline
  return toplevel:sub(0, -2)
end

local untracked = {}

function M.should_show_untracked(cwd)
  if untracked[cwd] ~= nil then
    return untracked[cwd]
  end

  local cmd = "git -C " .. cwd .. " config --type=bool status.showUntrackedFiles"
  local has_untracked = vim.fn.system(cmd)
  untracked[cwd] = vim.trim(has_untracked) ~= "false"
  return untracked[cwd]
end

function M.file_status_to_dir_status(status, cwd)
  local dirs = {}
  for p, s in pairs(status) do
    if s ~= "!!" then
      local modified = vim.fn.fnamemodify(p, ":h")
      dirs[modified] = s
    end
  end

  for dirname, s in pairs(dirs) do
    local modified = dirname
    while modified ~= cwd and modified ~= "/" do
      modified = vim.fn.fnamemodify(modified, ":h")
      dirs[modified] = s
    end
  end

  return dirs
end

return M
