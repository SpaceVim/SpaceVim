local log = require "nvim-tree.log"
local uv = vim.loop
local view = require "nvim-tree.view"
local utils = require "nvim-tree.utils"
local renderer = require "nvim-tree.renderer"
local core = require "nvim-tree.core"

local M = {}

local running = {}

---Find a path in the tree, expand it and focus it
---@param fname string full path
function M.fn(fname)
  if running[fname] or not core.get_explorer() then
    return
  end
  running[fname] = true

  local ps = log.profile_start("find file %s", fname)
  -- always match against the real path
  local fname_real = uv.fs_realpath(fname)
  if not fname_real then
    return
  end

  local i = core.get_nodes_starting_line() - 1
  local tree_altered = false

  local function iterate_nodes(nodes)
    for _, node in ipairs(nodes) do
      i = i + 1

      if not node.absolute_path or not uv.fs_stat(node.absolute_path) then
        break
      end

      -- match against node absolute and link, as symlinks themselves will differ
      if node.absolute_path == fname_real or node.link_to == fname_real then
        return i
      end
      local abs_match = vim.startswith(fname_real, node.absolute_path .. utils.path_separator)
      local link_match = node.link_to and vim.startswith(fname_real, node.link_to .. utils.path_separator)
      local path_matches = node.nodes and (abs_match or link_match)
      if path_matches then
        if not node.open then
          node.open = true
          tree_altered = true
        end

        if #node.nodes == 0 then
          core.get_explorer():expand(node)
        end

        if iterate_nodes(node.nodes) ~= nil then
          return i
        end
        -- mandatory to iterate i
      elseif node.open then
        iterate_nodes(node.nodes)
      end
    end
  end

  local index = iterate_nodes(core.get_explorer().nodes)
  if tree_altered then
    renderer.draw()
  end
  if index and view.is_visible() then
    view.set_cursor { index, 0 }
  end
  running[fname] = false

  log.profile_end(ps, "find file %s", fname)
end

return M
