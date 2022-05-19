local uv = vim.loop
local utils = require "nvim-tree.utils"

local M = {
  is_windows = vim.fn.has "win32" == 1,
}

function M.get_dir_git_status(parent_ignored, status, absolute_path)
  if parent_ignored then
    return "!!"
  end
  local dir_status = status.dirs and status.dirs[absolute_path]
  local file_status = status.files and status.files[absolute_path]
  return dir_status or file_status
end

function M.get_git_status(parent_ignored, status, absolute_path)
  return parent_ignored and "!!" or status.files and status.files[absolute_path]
end

function M.folder(parent, absolute_path, name, status, parent_ignored)
  local handle = uv.fs_scandir(absolute_path)
  local has_children = handle and uv.fs_scandir_next(handle) ~= nil

  return {
    absolute_path = absolute_path,
    fs_stat = uv.fs_stat(absolute_path),
    git_status = M.get_dir_git_status(parent_ignored, status, absolute_path),
    group_next = nil, -- If node is grouped, this points to the next child dir/link node
    has_children = has_children,
    name = name,
    nodes = {},
    open = false,
    parent = parent,
  }
end

local function is_executable(absolute_path, ext)
  if M.is_windows then
    return utils.is_windows_exe(ext)
  end
  return uv.fs_access(absolute_path, "X")
end

function M.file(parent, absolute_path, name, status, parent_ignored)
  local ext = string.match(name, ".?[^.]+%.(.*)") or ""

  return {
    absolute_path = absolute_path,
    executable = is_executable(absolute_path, ext),
    extension = ext,
    fs_stat = uv.fs_stat(absolute_path),
    git_status = M.get_git_status(parent_ignored, status, absolute_path),
    name = name,
    parent = parent,
  }
end

-- TODO-INFO: sometimes fs_realpath returns nil
-- I expect this be a bug in glibc, because it fails to retrieve the path for some
-- links (for instance libr2.so in /usr/lib) and thus even with a C program realpath fails
-- when it has no real reason to. Maybe there is a reason, but errno is definitely wrong.
-- So we need to check for link_to ~= nil when adding new links to the main tree
function M.link(parent, absolute_path, name, status, parent_ignored)
  --- I dont know if this is needed, because in my understanding, there isnt hard links in windows, but just to be sure i changed it.
  local link_to = uv.fs_realpath(absolute_path)
  local open, nodes, has_children
  if (link_to ~= nil) and uv.fs_stat(link_to).type == "directory" then
    local handle = uv.fs_scandir(link_to)
    has_children = handle and uv.fs_scandir_next(handle) ~= nil
    open = false
    nodes = {}
  end

  return {
    absolute_path = absolute_path,
    fs_stat = uv.fs_stat(absolute_path),
    git_status = M.get_git_status(parent_ignored, status, absolute_path),
    group_next = nil, -- If node is grouped, this points to the next child dir/link node
    has_children = has_children,
    link_to = link_to,
    name = name,
    nodes = nodes,
    open = open,
    parent = parent,
  }
end

return M
