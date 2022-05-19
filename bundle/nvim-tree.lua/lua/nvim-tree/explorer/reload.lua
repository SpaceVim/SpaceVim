local api = vim.api
local uv = vim.loop

local utils = require "nvim-tree.utils"
local builders = require "nvim-tree.explorer.node-builders"
local common = require "nvim-tree.explorer.common"
local filters = require "nvim-tree.explorer.filters"
local sorters = require "nvim-tree.explorer.sorters"

local M = {}

local function update_status(nodes_by_path, node_ignored, status)
  return function(node)
    if nodes_by_path[node.absolute_path] then
      if node.nodes then
        node.git_status = builders.get_dir_git_status(node_ignored, status, node.absolute_path)
      else
        node.git_status = builders.get_git_status(node_ignored, status, node.absolute_path)
      end
    end
    return node
  end
end

function M.reload(node, status)
  local cwd = node.cwd or node.link_to or node.absolute_path
  local handle = uv.fs_scandir(cwd)
  if type(handle) == "string" then
    api.nvim_err_writeln(handle)
    return
  end

  if node.group_next then
    node.nodes = { node.group_next }
    node.group_next = nil
  end

  local child_names = {}

  local node_ignored = node.git_status == "!!"
  local nodes_by_path = utils.key_by(node.nodes, "absolute_path")
  while true do
    local name, t = uv.fs_scandir_next(handle)
    if not name then
      break
    end

    local abs = utils.path_join { cwd, name }
    t = t or (uv.fs_stat(abs) or {}).type
    if not filters.should_ignore(abs) and not filters.should_ignore_git(abs, status.files) then
      child_names[abs] = true
      if not nodes_by_path[abs] then
        if t == "directory" and uv.fs_access(abs, "R") then
          table.insert(node.nodes, builders.folder(node, abs, name, status, node_ignored))
        elseif t == "file" then
          table.insert(node.nodes, builders.file(node, abs, name, status, node_ignored))
        elseif t == "link" then
          local link = builders.link(node, abs, name, status, node_ignored)
          if link.link_to ~= nil then
            table.insert(node.nodes, link)
          end
        end
      end
    end
  end

  node.nodes = vim.tbl_map(
    update_status(nodes_by_path, node_ignored, status),
    vim.tbl_filter(function(n)
      return child_names[n.absolute_path]
    end, node.nodes)
  )

  local is_root = node.cwd ~= nil
  local child_folder_only = common.has_one_child_folder(node) and node.nodes[1]
  if vim.g.nvim_tree_group_empty == 1 and not is_root and child_folder_only then
    node.group_next = child_folder_only
    local ns = M.reload(child_folder_only, status)
    node.nodes = ns or {}
    return ns
  end

  sorters.merge_sort(node.nodes, sorters.node_comparator)
  return node.nodes
end

return M
