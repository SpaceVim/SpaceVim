local icon_config = require "nvim-tree.renderer.icon-config"

local M = { i = {} }

local function config_symlinks()
  M.i.symlink = #M.icons.symlink > 0 and M.icons.symlink .. M.padding or ""
  M.i.symlink_arrow = vim.g.nvim_tree_symlink_arrow or " ➛ "
end

local function empty()
  return ""
end

local function get_folder_icon(open, is_symlink, has_children)
  local n
  if is_symlink and open then
    n = M.icons.folder_icons.symlink_open
  elseif is_symlink then
    n = M.icons.folder_icons.symlink
  elseif open then
    if has_children then
      n = M.icons.folder_icons.open
    else
      n = M.icons.folder_icons.empty_open
    end
  else
    if has_children then
      n = M.icons.folder_icons.default
    else
      n = M.icons.folder_icons.empty
    end
  end
  return n .. M.padding
end

local function get_file_icon_default()
  local hl_group = "NvimTreeFileIcon"
  local icon = M.icons.default
  if #icon > 0 then
    return icon .. M.padding, hl_group
  else
    return ""
  end
end

local function get_file_icon_webdev(fname, extension)
  local icon, hl_group = M.devicons.get_icon(fname, extension)
  if not M.webdev_colors then
    hl_group = "NvimTreeFileIcon"
  end
  if icon and hl_group ~= "DevIconDefault" then
    return icon .. M.padding, hl_group
  elseif string.match(extension, "%.(.*)") then
    -- If there are more extensions to the file, try to grab the icon for them recursively
    return get_file_icon_webdev(fname, string.match(extension, "%.(.*)"))
  else
    return get_file_icon_default()
  end
end

local function config_file_icon()
  if M.configs.show_file_icon then
    if M.devicons then
      M.get_file_icon = get_file_icon_webdev
    else
      M.get_file_icon = get_file_icon_default
    end
  else
    M.get_file_icon = empty
  end
end

local function config_folder_icon()
  if M.configs.show_folder_icon then
    M.get_folder_icon = get_folder_icon
  else
    M.get_folder_icon = empty
  end
end

function M.reset_config(webdev_colors)
  M.configs = icon_config.get_config()
  M.icons = M.configs.icons
  M.padding = vim.g.nvim_tree_icon_padding or " "
  M.devicons = M.configs.has_devicons and require "nvim-web-devicons" or nil
  M.webdev_colors = webdev_colors

  config_symlinks()
  config_file_icon()
  config_folder_icon()
end

return M
