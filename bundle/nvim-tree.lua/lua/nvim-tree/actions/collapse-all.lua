local renderer = require "nvim-tree.renderer"
local utils = require "nvim-tree.utils"
local core = require "nvim-tree.core"

local M = {}

function M.fn(keep_buffers)
  if not core.get_explorer() then
    return
  end

  local buffer_paths = {}
  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    table.insert(buffer_paths, vim.api.nvim_buf_get_name(buffer))
  end

  local function iter(nodes)
    for _, node in pairs(nodes) do
      if node.open then
        local new_open = false

        if keep_buffers == true then
          for _, buffer_path in ipairs(buffer_paths) do
            local matches = utils.str_find(buffer_path, node.absolute_path)
            if matches then
              new_open = true
            end
          end
        end

        node.open = new_open
      end
      if node.nodes then
        iter(node.nodes)
      end
    end
  end

  iter(core.get_explorer().nodes)
  renderer.draw()
end

return M
