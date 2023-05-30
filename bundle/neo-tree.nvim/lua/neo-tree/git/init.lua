local status = require("neo-tree.git.status")
local ignored = require("neo-tree.git.ignored")
local git_utils = require("neo-tree.git.utils")

local M = {
  get_repository_root = git_utils.get_repository_root,
  is_ignored = ignored.is_ignored,
  mark_ignored = ignored.mark_ignored,
  status = status.status,
  status_async = status.status_async,
}

return M
