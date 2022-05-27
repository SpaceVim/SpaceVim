local core = require "nvim-tree.core"
local diagnostics = require "nvim-tree.diagnostics"
local log = require "nvim-tree.log"
local view = require "nvim-tree.view"

local _padding = require "nvim-tree.renderer.components.padding"
local icon_component = require "nvim-tree.renderer.components.icons"
local help = require "nvim-tree.renderer.help"
local git = require "nvim-tree.renderer.components.git"
local Builder = require "nvim-tree.renderer.builder"

local api = vim.api

local M = {
  last_highlights = {},
}

local namespace_id = api.nvim_create_namespace "NvimTreeHighlights"

local function _draw(bufnr, lines, hl)
  api.nvim_buf_set_option(bufnr, "modifiable", true)
  api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  M.render_hl(bufnr, hl)
  api.nvim_buf_set_option(bufnr, "modifiable", false)
end

function M.render_hl(bufnr, hl)
  if not bufnr or not api.nvim_buf_is_loaded(bufnr) then
    return
  end
  api.nvim_buf_clear_namespace(bufnr, namespace_id, 0, -1)
  for _, data in ipairs(hl or M.last_highlights) do
    api.nvim_buf_add_highlight(bufnr, namespace_id, data[1], data[2], data[3], data[4])
  end
end

local function should_show_arrows()
  return not M.config.indent_markers.enable
    and icon_component.configs.show_folder_icon
    and icon_component.configs.show_folder_arrows
end

local picture_map = {
  jpg = true,
  jpeg = true,
  png = true,
  gif = true,
}

local function get_special_files_map()
  return vim.g.nvim_tree_special_files
    or {
      ["Cargo.toml"] = true,
      Makefile = true,
      ["README.md"] = true,
      ["readme.md"] = true,
    }
end

function M.draw()
  local bufnr = view.get_bufnr()
  if not core.get_explorer() or not bufnr or not api.nvim_buf_is_loaded(bufnr) then
    return
  end

  local ps = log.profile_start "draw"

  local cursor = api.nvim_win_get_cursor(view.get_winnr())
  _padding.reload_padding_function()
  icon_component.reset_config(M.config.icons.webdev_colors)
  git.reload()

  local lines, hl
  if view.is_help_ui() then
    lines, hl = help.compute_lines()
  else
    lines, hl = Builder.new(core.get_cwd())
      :configure_initial_depth(should_show_arrows())
      :configure_root_modifier(vim.g.nvim_tree_root_folder_modifier)
      :configure_trailing_slash(vim.g.nvim_tree_add_trailing == 1)
      :configure_special_map(get_special_files_map())
      :configure_picture_map(picture_map)
      :configure_opened_file_highlighting(vim.g.nvim_tree_highlight_opened_files)
      :configure_git_icons_padding(vim.g.nvim_tree_icon_padding)
      :configure_git_icons_placement(M.config.icons.git_placement)
      :build_header(view.is_root_folder_visible(core.get_cwd()))
      :build(core.get_explorer())
      :unwrap()
  end

  _draw(bufnr, lines, hl)
  M.last_highlights = hl

  if cursor and #lines >= cursor[1] then
    api.nvim_win_set_cursor(view.get_winnr(), cursor)
  end

  if view.is_help_ui() then
    diagnostics.clear()
  else
    diagnostics.update()
  end

  log.profile_end(ps, "draw")
end

function M.setup(opts)
  M.config = {
    indent_markers = opts.renderer.indent_markers,
    icons = opts.renderer.icons,
  }

  _padding.setup(opts)
end

return M
