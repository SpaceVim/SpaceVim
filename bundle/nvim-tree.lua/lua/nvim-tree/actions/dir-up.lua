local utils = require "nvim-tree.utils"
local core = require "nvim-tree.core"

local M = {}

function M.fn(node)
  if not node or node.name == ".." then
    return require("nvim-tree.actions.change-dir").fn ".."
  else
    local newdir = vim.fn.fnamemodify(utils.path_remove_trailing(core.get_cwd()), ":h")
    require("nvim-tree.actions.change-dir").fn(newdir)
    return require("nvim-tree.actions.find-file").fn(node.absolute_path)
  end
end

return M
