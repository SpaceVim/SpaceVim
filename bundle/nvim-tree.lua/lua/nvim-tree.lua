local luv = vim.loop
local api = vim.api

local lib = require "nvim-tree.lib"
local log = require "nvim-tree.log"
local colors = require "nvim-tree.colors"
local renderer = require "nvim-tree.renderer"
local view = require "nvim-tree.view"
local utils = require "nvim-tree.utils"
local change_dir = require "nvim-tree.actions.change-dir"
local legacy = require "nvim-tree.legacy"
local core = require "nvim-tree.core"

local _config = {}

local M = {}

function M.focus()
  M.open()
  view.focus()
end

---@deprecated
M.on_keypress = require("nvim-tree.actions").on_keypress

function M.toggle(find_file, no_focus)
  if view.is_visible() then
    view.close()
  else
    local previous_buf = api.nvim_get_current_buf()
    M.open()
    if _config.update_focused_file.enable or find_file then
      M.find_file(false, previous_buf)
    end
    if no_focus then
      vim.cmd "noautocmd wincmd p"
    end
  end
end

function M.open(cwd)
  cwd = cwd ~= "" and cwd or nil
  if view.is_visible() then
    lib.set_target_win()
    view.focus()
  else
    lib.open(cwd)
  end
end

function M.open_replacing_current_buffer()
  if view.is_visible() then
    return
  end

  local buf = api.nvim_get_current_buf()
  local bufname = api.nvim_buf_get_name(buf)
  if bufname == "" or vim.loop.fs_stat(bufname) == nil then
    return
  end

  local cwd = vim.fn.fnamemodify(bufname, ":p:h")
  if not core.get_explorer() or cwd ~= core.get_cwd() then
    core.init(cwd)
  end
  view.open_in_current_win { hijack_current_buf = false, resize = false }
  require("nvim-tree.renderer").draw()
  require("nvim-tree.actions.find-file").fn(bufname)
end

function M.tab_change()
  if view.is_visible { any_tabpage = true } then
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname:match "Neogit" ~= nil or bufname:match "--graph" ~= nil then
      return
    end
    view.open { focus_tree = false }
    require("nvim-tree.renderer").draw()
  end
end

local function find_existing_windows()
  return vim.tbl_filter(function(win)
    local buf = api.nvim_win_get_buf(win)
    return api.nvim_buf_get_name(buf):match "NvimTree" ~= nil
  end, api.nvim_list_wins())
end

local function is_file_readable(fname)
  local stat = luv.fs_stat(fname)
  return stat and stat.type == "file" and luv.fs_access(fname, "R")
end

local function update_base_dir_with_filepath(filepath, bufnr)
  local ft = api.nvim_buf_get_option(bufnr, "filetype") or ""
  for _, value in pairs(_config.update_focused_file.ignore_list) do
    if utils.str_find(filepath, value) or utils.str_find(ft, value) then
      return
    end
  end

  if not vim.startswith(filepath, core.get_explorer().cwd) then
    change_dir.fn(vim.fn.fnamemodify(filepath, ":p:h"))
  end
end

function M.find_file(with_open, bufnr)
  if not with_open and not core.get_explorer() then
    return
  end

  bufnr = bufnr or api.nvim_get_current_buf()
  local bufname = api.nvim_buf_get_name(bufnr)
  local filepath = utils.canonical_path(vim.fn.fnamemodify(bufname, ":p"))
  if not is_file_readable(filepath) then
    return
  end

  if with_open then
    M.open()
  end

  vim.schedule(function()
    -- if we don't schedule, it will search for NvimTree
    if _config.update_focused_file.update_cwd then
      update_base_dir_with_filepath(filepath, bufnr)
    end
    require("nvim-tree.actions.find-file").fn(filepath)
  end)
end

M.resize = view.resize

function M.open_on_directory()
  local should_proceed = M.initialized and (_config.hijack_directories.auto_open or view.is_visible())
  if not should_proceed then
    return
  end

  local buf = api.nvim_get_current_buf()
  local bufname = api.nvim_buf_get_name(buf)
  if vim.fn.isdirectory(bufname) ~= 1 then
    return
  end

  change_dir.force_dirchange(bufname, true)
end

function M.reset_highlight()
  colors.setup()
  renderer.render_hl(view.get_bufnr())
end

local prev_line
function M.place_cursor_on_node()
  local l = vim.api.nvim_win_get_cursor(0)[1]
  if l == prev_line then
    return
  end
  prev_line = l

  local node = lib.get_node_at_cursor()
  if not node or node.name == ".." then
    return
  end

  local line = api.nvim_get_current_line()
  local cursor = api.nvim_win_get_cursor(0)
  local idx = vim.fn.stridx(line, node.name)

  if idx >= 0 then
    api.nvim_win_set_cursor(0, { cursor[1], idx })
  end
end

function M.on_enter(netrw_disabled)
  local bufnr = api.nvim_get_current_buf()
  local bufname = api.nvim_buf_get_name(bufnr)
  local buftype = api.nvim_buf_get_option(bufnr, "filetype")
  local ft_ignore = _config.ignore_ft_on_setup

  local stats = luv.fs_stat(bufname)
  local is_dir = stats and stats.type == "directory"
  local is_file = stats and stats.type == "file"
  local cwd
  if is_dir then
    cwd = vim.fn.expand(bufname)
    -- INFO: could potentially conflict with rooter plugins
    vim.cmd("noautocmd cd " .. cwd)
  end

  local lines = not is_dir and api.nvim_buf_get_lines(bufnr, 0, -1, false) or {}
  local buf_has_content = #lines > 1 or (#lines == 1 and lines[1] ~= "")

  local buf_is_dir = is_dir and netrw_disabled
  local buf_is_empty = bufname == "" and not buf_has_content
  local should_be_preserved = vim.tbl_contains(ft_ignore, buftype)

  local should_open = false
  local should_focus_other_window = false
  local should_find = false
  if (_config.open_on_setup or _config.open_on_setup_file) and not should_be_preserved then
    if buf_is_dir or buf_is_empty then
      should_open = true
    elseif is_file and _config.open_on_setup_file then
      should_open = true
      should_focus_other_window = true
      should_find = _config.update_focused_file.enable
    elseif _config.ignore_buffer_on_setup then
      should_open = true
      should_focus_other_window = true
    end
  end

  local should_hijack = _config.hijack_directories.enable
    and _config.hijack_directories.auto_open
    and is_dir
    and not should_be_preserved

  -- Session that left a NvimTree Buffer opened, reopen with it
  local existing_tree_wins = find_existing_windows()
  if existing_tree_wins[1] then
    api.nvim_set_current_win(existing_tree_wins[1])
  end

  if should_open or should_hijack or existing_tree_wins[1] ~= nil then
    lib.open(cwd)

    if should_focus_other_window then
      vim.cmd "noautocmd wincmd p"
      if should_find then
        M.find_file(false)
      end
    end
  end
  M.initialized = true
end

function M.get_config()
  return M.config
end

local function manage_netrw(disable_netrw, hijack_netrw)
  if hijack_netrw then
    vim.cmd "silent! autocmd! FileExplorer *"
    vim.cmd "autocmd VimEnter * ++once silent! autocmd! FileExplorer *"
  end
  if disable_netrw then
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end
end

local function setup_vim_commands()
  vim.cmd [[
    command! -nargs=? -complete=dir NvimTreeOpen lua require'nvim-tree'.open("<args>")
    command! NvimTreeClose lua require'nvim-tree.view'.close()
    command! NvimTreeToggle lua require'nvim-tree'.toggle(false)
    command! NvimTreeFocus lua require'nvim-tree'.focus()
    command! NvimTreeRefresh lua require'nvim-tree.actions.reloaders'.reload_explorer()
    command! NvimTreeClipboard lua require'nvim-tree.actions.copy-paste'.print_clipboard()
    command! NvimTreeFindFile lua require'nvim-tree'.find_file(true)
    command! NvimTreeFindFileToggle lua require'nvim-tree'.toggle(true)
    command! -nargs=1 NvimTreeResize lua require'nvim-tree'.resize("<args>")
    command! NvimTreeCollapse lua require'nvim-tree.actions.collapse-all'.fn()
    command! NvimTreeCollapseKeepBuffers lua require'nvim-tree.actions.collapse-all'.fn(true)
  ]]
end

function M.change_dir(name)
  change_dir.fn(name)

  if _config.update_focused_file.enable then
    M.find_file(false)
  end
end

local function setup_autocommands(opts)
  vim.cmd "augroup NvimTree"
  vim.cmd "autocmd!"

  -- reset highlights when colorscheme is changed
  vim.cmd "au ColorScheme * lua require'nvim-tree'.reset_highlight()"
  if opts.auto_reload_on_write then
    vim.cmd "au BufWritePost * lua require'nvim-tree.actions.reloaders'.reload_explorer()"
  end
  vim.cmd "au User FugitiveChanged,NeogitStatusRefreshed lua require'nvim-tree.actions.reloaders'.reload_git()"

  if opts.open_on_tab then
    vim.cmd "au TabEnter * lua require'nvim-tree'.tab_change()"
  end
  if opts.hijack_cursor then
    vim.cmd "au CursorMoved NvimTree_* lua require'nvim-tree'.place_cursor_on_node()"
  end
  if opts.update_cwd then
    vim.cmd "au DirChanged * lua require'nvim-tree'.change_dir(vim.loop.cwd())"
  end
  if opts.update_focused_file.enable then
    vim.cmd "au BufEnter * lua require'nvim-tree'.find_file(false)"
  end

  if not opts.actions.open_file.quit_on_open then
    vim.cmd "au BufWipeout NvimTree_* lua require'nvim-tree.view'._prevent_buffer_override()"
  else
    vim.cmd "au BufWipeout NvimTree_* lua require'nvim-tree.view'.abandon_current_window()"
  end

  if opts.hijack_directories.enable then
    vim.cmd "au BufEnter,BufNewFile * lua require'nvim-tree'.open_on_directory()"
  end

  vim.cmd "augroup end"
end

local DEFAULT_OPTS = { -- BEGIN_DEFAULT_OPTS
  auto_reload_on_write = true,
  disable_netrw = false,
  hijack_cursor = false,
  hijack_netrw = true,
  hijack_unnamed_buffer_when_opening = false,
  ignore_buffer_on_setup = false,
  open_on_setup = false,
  open_on_setup_file = false,
  open_on_tab = false,
  sort_by = "name",
  update_cwd = false,
  view = {
    width = 30,
    height = 30,
    hide_root_folder = false,
    side = "left",
    preserve_window_proportions = false,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
    mappings = {
      custom_only = false,
      list = {
        -- user mappings go here
      },
    },
  },
  renderer = {
    indent_markers = {
      enable = false,
      icons = {
        corner = "└ ",
        edge = "│ ",
        none = "  ",
      },
    },
    icons = {
      webdev_colors = true,
      git_placement = "before",
    },
  },
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  update_focused_file = {
    enable = false,
    update_cwd = false,
    ignore_list = {},
  },
  ignore_ft_on_setup = {},
  system_open = {
    cmd = "",
    args = {},
  },
  diagnostics = {
    enable = false,
    show_on_dirs = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  filters = {
    dotfiles = false,
    custom = {},
    exclude = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 400,
  },
  actions = {
    use_system_clipboard = true,
    change_dir = {
      enable = true,
      global = false,
      restrict_above_cwd = false,
    },
    open_file = {
      quit_on_open = false,
      resize_window = false,
      window_picker = {
        enable = true,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
  log = {
    enable = false,
    truncate = false,
    types = {
      all = false,
      config = false,
      copy_paste = false,
      diagnostics = false,
      git = false,
      profile = false,
    },
  },
} -- END_DEFAULT_OPTS

local function merge_options(conf)
  return vim.tbl_deep_extend("force", DEFAULT_OPTS, conf or {})
end

local FIELD_OVERRIDE_TYPECHECK = {
  width = { string = true, ["function"] = true, number = true },
  height = { string = true, ["function"] = true, number = true },
}

local function validate_options(conf)
  local msg

  local function validate(user, def, prefix)
    -- only compare tables with contents that are not integer indexed
    if type(user) ~= "table" or type(def) ~= "table" or not next(def) or type(next(def)) == "number" then
      return
    end

    for k, v in pairs(user) do
      local invalid
      local override_typecheck = FIELD_OVERRIDE_TYPECHECK[k] or {}
      if def[k] == nil then
        -- option does not exist
        invalid = string.format("unknown option: %s%s", prefix, k)
      elseif type(v) ~= type(def[k]) and not override_typecheck[type(v)] then
        -- option is of the wrong type and is not a function
        invalid = string.format("invalid option: %s%s expected: %s actual: %s", prefix, k, type(def[k]), type(v))
      end

      if invalid then
        if msg then
          msg = string.format("%s | %s", msg, invalid)
        else
          msg = string.format("%s", invalid)
        end
        user[k] = nil
      else
        validate(v, def[k], prefix .. k .. ".")
      end
    end
  end

  validate(conf, DEFAULT_OPTS, "")

  if msg then
    utils.warn(msg)
  end
end

function M.setup(conf)
  legacy.migrate_legacy_options(conf or {})

  validate_options(conf)

  local opts = merge_options(conf)
  local netrw_disabled = opts.disable_netrw or opts.hijack_netrw

  _config.update_focused_file = opts.update_focused_file
  _config.open_on_setup = opts.open_on_setup
  _config.open_on_setup_file = opts.open_on_setup_file
  _config.ignore_buffer_on_setup = opts.ignore_buffer_on_setup
  _config.ignore_ft_on_setup = opts.ignore_ft_on_setup
  _config.hijack_directories = opts.hijack_directories
  _config.hijack_directories.enable = _config.hijack_directories.enable and netrw_disabled

  manage_netrw(opts.disable_netrw, opts.hijack_netrw)

  M.config = opts
  require("nvim-tree.log").setup(opts)

  log.line("config", "default config + user")
  log.raw("config", "%s\n", vim.inspect(opts))

  require("nvim-tree.actions").setup(opts)
  require("nvim-tree.colors").setup()
  require("nvim-tree.diagnostics").setup(opts)
  require("nvim-tree.explorer").setup(opts)
  require("nvim-tree.git").setup(opts)
  require("nvim-tree.view").setup(opts)
  require("nvim-tree.lib").setup(opts)
  require("nvim-tree.renderer").setup(opts)

  setup_vim_commands()
  setup_autocommands(opts)

  vim.schedule(function()
    M.on_enter(netrw_disabled)
  end)
end

return M
