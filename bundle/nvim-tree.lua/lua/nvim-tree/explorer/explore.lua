local api = vim.api
local uv = vim.loop

local utils = require "nvim-tree.utils"
local builders = require "nvim-tree.explorer.node-builders"
local common = require "nvim-tree.explorer.common"
local sorters = require "nvim-tree.explorer.sorters"
local filters = require "nvim-tree.explorer.filters"

local M = {}

local function get_type_from(type_, cwd)
  return type_ or (uv.fs_stat(cwd) or {}).type
end

local function populate_children(handle, cwd, node, status)
  local node_ignored = node.git_status == "!!"
  while true do
    local name, t = uv.fs_scandir_next(handle)
    if not name then
      break
    end

    local nodes_by_path = utils.key_by(node.nodes, "absolute_path")
    local abs = utils.path_join { cwd, name }
    t = get_type_from(t, abs)
    if
      not filters.should_ignore(abs)
      and not filters.should_ignore_git(abs, status.files)
      and not nodes_by_path[abs]
    then
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

local function get_dir_handle(cwd)
  local handle = uv.fs_scandir(cwd)
  if type(handle) == "string" then
    api.nvim_err_writeln(handle)
    return
  end
  return handle
end

function M.explore(node, status)
  local cwd = node.cwd or node.link_to or node.absolute_path
  local handle = get_dir_handle(cwd)
  if not handle then
    return
  end

  populate_children(handle, cwd, node, status)

  local is_root = node.cwd ~= nil
  local child_folder_only = common.has_one_child_folder(node) and node.nodes[1]
  if vim.g.nvim_tree_group_empty == 1 and not is_root and child_folder_only then
    node.group_next = child_folder_only
    local ns = M.explore(child_folder_only, status)
    node.nodes = ns or {}
    return ns
  end

  sorters.merge_sort(node.nodes, sorters.node_comparator)
  return node.nodes
end

return M
