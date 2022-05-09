local utils = require "nvim-tree.utils"

local git = require "nvim-tree.renderer.components.git"
local pad = require "nvim-tree.renderer.components.padding"
local icons = require "nvim-tree.renderer.components.icons"

local Builder = {}
Builder.__index = Builder

function Builder.new(root_cwd)
  return setmetatable({
    index = 0,
    depth = nil,
    highlights = {},
    lines = {},
    markers = {},
    root_cwd = root_cwd,
  }, Builder)
end

function Builder:configure_initial_depth(show_arrows)
  self.depth = show_arrows and 2 or 0
  return self
end

function Builder:configure_root_modifier(root_folder_modifier)
  self.root_folder_modifier = root_folder_modifier or ":~"
  return self
end

function Builder:configure_trailing_slash(with_trailing)
  self.trailing_slash = with_trailing and "/" or ""
  return self
end

function Builder:configure_special_map(special_map)
  self.special_map = special_map
  return self
end

function Builder:configure_picture_map(picture_map)
  self.picture_map = picture_map
  return self
end

function Builder:configure_opened_file_highlighting(level)
  if level == 1 then
    self.open_file_highlight = "icon"
  elseif level == 2 then
    self.open_file_highlight = "name"
  elseif level == 3 then
    self.open_file_highlight = "all"
  end

  return self
end

function Builder:configure_git_icons_padding(padding)
  self.git_icon_padding = padding or " "
  return self
end

function Builder:configure_git_icons_placement(where)
  where = where or "before"
  self.is_git_before = where == "before"
  self.is_git_after = not self.is_git_before
  return self
end

function Builder:_insert_highlight(group, start, end_)
  table.insert(self.highlights, { group, self.index, start, end_ or -1 })
end

function Builder:_insert_line(line)
  table.insert(self.lines, line)
end

local function get_folder_name(node)
  local name = node.name
  local next = node.group_next
  while next do
    name = name .. "/" .. next.name
    next = next.group_next
  end
  return name
end

function Builder:_unwrap_git_data(git_icons_and_hl_groups, offset)
  if not git_icons_and_hl_groups then
    return ""
  end

  local icon = ""
  for _, v in ipairs(git_icons_and_hl_groups) do
    if #v.icon > 0 then
      self:_insert_highlight(v.hl, offset + #icon, offset + #icon + #v.icon)
      icon = icon .. v.icon .. self.git_icon_padding
    end
  end
  return icon
end

function Builder:_build_folder(node, padding, git_hl, git_icons_tbl)
  local offset = string.len(padding)

  local name = get_folder_name(node)
  local has_children = #node.nodes ~= 0 or node.has_children
  local icon = icons.get_folder_icon(node.open, node.link_to ~= nil, has_children)

  local foldername = name .. self.trailing_slash
  local git_icons = self:_unwrap_git_data(git_icons_tbl, offset + #icon + (self.is_git_after and #foldername + 1 or 0))
  local fname_starts_at = offset + #icon + (self.is_git_before and #git_icons or 0)
  local line = self:_format_line(padding .. icon, foldername, git_icons)
  self:_insert_line(line)

  if #icon > 0 then
    self:_insert_highlight("NvimTreeFolderIcon", offset, offset + #icon)
  end

  local foldername_hl = "NvimTreeFolderName"
  if self.special_map[node.absolute_path] then
    foldername_hl = "NvimTreeSpecialFolderName"
  elseif node.open then
    foldername_hl = "NvimTreeOpenedFolderName"
  elseif not has_children then
    foldername_hl = "NvimTreeEmptyFolderName"
  end

  self:_insert_highlight(foldername_hl, fname_starts_at, fname_starts_at + #foldername)

  if git_hl then
    self:_insert_highlight(git_hl, fname_starts_at, fname_starts_at + #foldername)
  end
end

function Builder:_format_line(before, after, git_icons)
  return string.format(
    "%s%s%s %s",
    before,
    self.is_git_after and "" or git_icons,
    after,
    self.is_git_after and git_icons or ""
  )
end

function Builder:_build_symlink(node, padding, git_highlight, git_icons_tbl)
  local offset = string.len(padding)

  local icon = icons.i.symlink
  local arrow = icons.i.symlink_arrow
  local symlink_formatted = node.name .. arrow .. node.link_to

  local link_highlight = git_highlight or "NvimTreeSymlink"

  local git_icons_starts_at = offset + #icon + (self.is_git_after and #symlink_formatted + 1 or 0)
  local git_icons = self:_unwrap_git_data(git_icons_tbl, git_icons_starts_at)
  local line = self:_format_line(padding .. icon, symlink_formatted, git_icons)

  self:_insert_highlight(link_highlight, offset + (self.is_git_after and 0 or #git_icons), string.len(line))
  self:_insert_line(line)
end

function Builder:_build_file_icon(node, offset)
  local icon, hl_group = icons.get_file_icon(node.name, node.extension)
  if hl_group then
    self:_insert_highlight(hl_group, offset, offset + #icon)
  end
  return icon, false
end

function Builder:_highlight_opened_files(node, offset, icon_length, git_icons_length)
  local from = offset
  local to = offset

  if self.open_file_highlight == "icon" then
    to = from + icon_length
  elseif self.open_file_highlight == "name" then
    from = offset + icon_length + git_icons_length
    to = from + #node.name
  elseif self.open_file_highlight == "all" then
    to = from + icon_length + git_icons_length + #node.name
  end

  self:_insert_highlight("NvimTreeOpenedFile", from, to)
end

function Builder:_build_file(node, padding, git_highlight, git_icons_tbl)
  local offset = string.len(padding)

  local icon = self:_build_file_icon(node, offset)

  local git_icons_starts_at = offset + #icon + (self.is_git_after and #node.name + 1 or 0)
  local git_icons = self:_unwrap_git_data(git_icons_tbl, git_icons_starts_at)

  self:_insert_line(self:_format_line(padding .. icon, node.name, git_icons))

  local git_icons_length = self.is_git_after and 0 or #git_icons
  local col_start = offset + #icon + git_icons_length
  local col_end = col_start + #node.name

  if self.special_map[node.absolute_path] or self.special_map[node.name] then
    self:_insert_highlight("NvimTreeSpecialFile", col_start, col_end)
  elseif node.executable then
    self:_insert_highlight("NvimTreeExecFile", col_start, col_end)
  elseif self.picture_map[node.extension] then
    self:_insert_highlight("NvimTreeImageFile", col_start, col_end)
  end

  local should_highlight_opened_files = self.open_file_highlight and vim.fn.bufloaded(node.absolute_path) > 0
  if should_highlight_opened_files then
    self:_highlight_opened_files(node, offset, #icon, git_icons_length)
  end

  if git_highlight then
    self:_insert_highlight(git_highlight, col_start, col_end)
  end
end

function Builder:_build_line(tree, node, idx)
  local padding = pad.get_padding(self.depth, idx, tree, node, self.markers)

  if self.depth > 0 then
    self:_insert_highlight("NvimTreeIndentMarker", 0, string.len(padding))
  end

  local git_highlight = git.get_highlight(node)
  local git_icons_tbl = git.get_icons(node)

  local is_folder = node.nodes ~= nil
  local is_symlink = node.link_to ~= nil

  if is_folder then
    self:_build_folder(node, padding, git_highlight, git_icons_tbl)
  elseif is_symlink then
    self:_build_symlink(node, padding, git_highlight, git_icons_tbl)
  else
    self:_build_file(node, padding, git_highlight, git_icons_tbl)
  end
  self.index = self.index + 1

  if node.open then
    self.depth = self.depth + 2
    self:build(node)
    self.depth = self.depth - 2
  end
end

function Builder:build(tree)
  for idx, node in ipairs(tree.nodes) do
    self:_build_line(tree, node, idx)
  end

  return self
end

local function format_root_name(root_cwd, modifier)
  local base_root = utils.path_remove_trailing(vim.fn.fnamemodify(root_cwd, modifier))
  return utils.path_join { base_root, ".." }
end

function Builder:build_header(show_header)
  if show_header then
    local root_name = format_root_name(self.root_cwd, self.root_folder_modifier)
    self:_insert_line(root_name)
    self:_insert_highlight("NvimTreeRootFolder", 0, string.len(root_name))
    self.index = 1
  end

  return self
end

function Builder:unwrap()
  return self.lines, self.highlights
end

return Builder
