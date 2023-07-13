local utils = require("neo-tree.utils")

local M = {}

local migrations = {}

M.show_migrations = function()
  if #migrations > 0 then
    for i, message in ipairs(migrations) do
      migrations[i] = "  * " .. message
    end
    table.insert(
      migrations,
      1,
      "# Neo-tree configuration has been updated. Please review the changes below."
    )
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, migrations)
    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "buflisted", false)
    vim.api.nvim_buf_set_option(buf, "swapfile", false)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
    vim.api.nvim_buf_set_name(buf, "Neo-tree migrations")
    vim.defer_fn(function()
      vim.cmd(string.format("%ssplit", #migrations))
      vim.api.nvim_win_set_buf(0, buf)
    end, 100)
  end
end

M.migrate = function(config)
  migrations = {}

  local moved = function(old, new, converter)
    local existing = utils.get_value(config, old)
    if type(existing) ~= "nil" then
      if type(converter) == "function" then
        existing = converter(existing)
      end
      utils.set_value(config, new, existing)
      config[old] = nil
      migrations[#migrations + 1] =
        string.format("The `%s` option has been deprecated, please use `%s` instead.", old, new)
    end
  end

  local removed = function(key)
    local value = utils.get_value(config, key)
    if type(value) ~= "nil" then
      utils.set_value(config, key, nil)
      migrations[#migrations + 1] = string.format("The `%s` option has been removed.", key)
    end
  end

  local renamed_value = function(key, old_value, new_value)
    local value = utils.get_value(config, key)
    if value == old_value then
      utils.set_value(config, key, new_value)
      migrations[#migrations + 1] =
        string.format("The `%s=%s` option has been renamed to `%s`.", key, old_value, new_value)
    end
  end

  local opposite = function(value)
    return not value
  end

  local tab_to_source_migrator = function(labels)
    local converted_sources = {}
    for entry, label in pairs(labels) do
      table.insert(converted_sources, { source = entry, display_name = label })
    end
    return converted_sources
  end

  moved("filesystem.filters", "filesystem.filtered_items")
  moved("filesystem.filters.show_hidden", "filesystem.filtered_items.hide_dotfiles", opposite)
  moved("filesystem.filters.respect_gitignore", "filesystem.filtered_items.hide_gitignored")
  moved("open_files_do_not_replace_filetypes", "open_files_do_not_replace_types")
  moved("source_selector.tab_labels", "source_selector.sources", tab_to_source_migrator)
  removed("filesystem.filters.gitignore_source")
  removed("filesystem.filter_items.gitignore_source")
  renamed_value("filesystem.hijack_netrw_behavior", "open_split", "open_current")
  for _, source in ipairs({ "filesystem", "buffers", "git_status" }) do
    renamed_value(source .. "window.position", "split", "current")
  end

  return migrations
end

return M
