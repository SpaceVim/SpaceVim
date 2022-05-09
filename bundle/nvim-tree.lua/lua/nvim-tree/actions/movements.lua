local utils = require "nvim-tree.utils"
local view = require "nvim-tree.view"
local renderer = require "nvim-tree.renderer"
local core = require "nvim-tree.core"
local lib = require "nvim-tree.lib"

local M = {}

local function get_line_from_node(node, find_parent)
  local node_path = node.absolute_path

  if find_parent then
    node_path = node.absolute_path:match("(.*)" .. utils.path_separator)
  end

  local line = core.get_nodes_starting_line()
  local function iter(nodes, recursive)
    for _, _node in ipairs(nodes) do
      local n = lib.get_last_group_node(_node)
      if node_path == n.absolute_path then
        return line, _node
      end

      line = line + 1
      if _node.open == true and recursive then
        local _, child = iter(_node.nodes, recursive)
        if child ~= nil then
          return line, child
        end
      end
    end
  end
  return iter
end

function M.parent_node(should_close)
  return function(node)
    if should_close and node.open then
      node.open = false
      return renderer.draw()
    end

    local parent = node.parent

    if not parent or parent.cwd then
      return view.set_cursor { 1, 0 }
    end

    local _, line = utils.find_node(core.get_explorer().nodes, function(n)
      return n.absolute_path == parent.absolute_path
    end)

    view.set_cursor { line + 1, 0 }
    if should_close then
      parent.open = false
      renderer.draw()
    end
  end
end

function M.sibling(direction)
  return function(node)
    if node.name == ".." or not direction then
      return
    end

    local iter = get_line_from_node(node, true)
    local node_path = node.absolute_path

    local line = 0
    local parent, _

    -- Check if current node is already at root nodes
    for index, _node in ipairs(core.get_explorer().nodes) do
      if node_path == _node.absolute_path then
        line = index
      end
    end

    if line > 0 then
      parent = core.get_explorer()
    else
      _, parent = iter(core.get_explorer().nodes, true)
      if parent ~= nil and #parent.nodes > 1 then
        line, _ = get_line_from_node(node)(parent.nodes)
      end

      -- Ignore parent line count
      line = line - 1
    end

    local index = line + direction
    if index < 1 then
      index = 1
    elseif index > #parent.nodes then
      index = #parent.nodes
    end
    local target_node = parent.nodes[index]

    line, _ = get_line_from_node(target_node)(core.get_explorer().nodes, true)
    view.set_cursor { line, 0 }
  end
end

function M.find_git_item(where)
  return function()
    local node_cur = lib.get_node_at_cursor()
    local nodes_by_line = lib.get_nodes_by_line(core.get_explorer().nodes, core.get_nodes_starting_line())

    local cur, first, prev, nex = nil, nil, nil, nil
    for line, node in pairs(nodes_by_line) do
      if not first and node.git_status then
        first = line
      end

      if node == node_cur then
        cur = line
      elseif node.git_status then
        if not cur then
          prev = line
        end
        if cur and not nex then
          nex = line
          break
        end
      end
    end

    if where == "prev" then
      if prev then
        view.set_cursor { prev, 0 }
      end
    else
      if cur then
        if nex then
          view.set_cursor { nex, 0 }
        end
      elseif first then
        view.set_cursor { first, 0 }
      end
    end
  end
end

return M
