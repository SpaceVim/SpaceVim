local vim = vim
local renderer = require("neo-tree.ui.renderer")
local utils = require("neo-tree.utils")
local file_items = require("neo-tree.sources.common.file-items")
local log = require("neo-tree.log")

local M = {}

---Get a table of all open buffers, along with all parent paths of those buffers.
---The paths are the keys of the table, and all the values are 'true'.
M.get_opened_buffers = function(state)
  if state.loading then
    return
  end
  state.loading = true
  local context = file_items.create_context()
  context.state = state
  -- Create root folder
  local root = file_items.create_item(context, state.path, "directory")
  root.name = vim.fn.fnamemodify(root.path, ":~")
  root.loaded = true
  root.search_pattern = state.search_pattern
  context.folders[root.path] = root
  local terminals = {}

  local function add_buffer(bufnr, path)
    local is_loaded = vim.api.nvim_buf_is_loaded(bufnr)
    if is_loaded or state.show_unloaded then
      local is_listed = vim.fn.buflisted(bufnr)
      if is_listed == 1 then
        if path == "" then
          path = "[No Name]"
        end
        local success, item = pcall(file_items.create_item, context, path, "file", bufnr)
        if success then
          item.extra = {
            bufnr = bufnr,
            is_listed = is_listed,
          }
        else
          log.error("Error creating item for " .. path .. ": " .. item)
        end
      end
    end
  end

  local bufs = vim.api.nvim_list_bufs()
  for _, b in ipairs(bufs) do
    local path = vim.api.nvim_buf_get_name(b)
    if vim.startswith(path, "term://") then
      local name = path:match("term://(.*)//.*")
      local abs_path = vim.fn.fnamemodify(name, ":p")
      local has_title, title = pcall(vim.api.nvim_buf_get_var, b, "term_title")
      local item = {
        name = has_title and title or name,
        ext = "terminal",
        path = abs_path,
        id = path,
        type = "terminal",
        loaded = true,
        extra = {
          bufnr = b,
          is_listed = true,
        },
      }
      if utils.is_subpath(state.path, abs_path) then
        table.insert(terminals, item)
      end
    elseif path == "" then
      add_buffer(b, path)
    else
      if #state.path > 1 then
        local rootsub = path:sub(1, #state.path)
        -- make sure this is within the root path
        if rootsub == state.path then
          add_buffer(b, path)
        end
      else
        add_buffer(b, path)
      end
    end
  end

  local root_folders = { root }

  if #terminals > 0 then
    local terminal_root = {
      name = "Terminals",
      id = "Terminals",
      ext = "terminal",
      type = "terminal",
      children = terminals,
      loaded = true,
      search_pattern = state.search_pattern,
    }
    context.folders["Terminals"] = terminal_root
    root_folders[2] = terminal_root
  end
  state.default_expanded_nodes = {}
  for id, _ in pairs(context.folders) do
    table.insert(state.default_expanded_nodes, id)
  end
  file_items.deep_sort(root.children)
  renderer.show_nodes(root_folders, state)
  state.loading = false
end

return M
