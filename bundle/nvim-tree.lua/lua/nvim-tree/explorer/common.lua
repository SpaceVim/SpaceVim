local uv = vim.loop

local M = {}

function M.has_one_child_folder(node)
  return #node.nodes == 1 and node.nodes[1].nodes and uv.fs_access(node.nodes[1].absolute_path, "R")
end

return M
