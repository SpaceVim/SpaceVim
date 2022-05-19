local a = vim.api

local M = {}

local events = require "nvim-tree.events"

M.View = {
  tabpages = {},
  cursors = {},
  hide_root_folder = false,
  winopts = {
    relativenumber = false,
    number = false,
    list = false,
    foldenable = false,
    winfixwidth = true,
    winfixheight = true,
    spell = false,
    signcolumn = "yes",
    foldmethod = "manual",
    foldcolumn = "0",
    cursorcolumn = false,
    cursorlineopt = "line",
    colorcolumn = "0",
    wrap = false,
    winhl = table.concat({
      "EndOfBuffer:NvimTreeEndOfBuffer",
      "Normal:NvimTreeNormal",
      "CursorLine:NvimTreeCursorLine",
      -- #1221 WinSeparator not present in nvim 0.6.1 and some builds of 0.7.0
      pcall(vim.cmd, "silent hi WinSeparator") and "WinSeparator:NvimTreeWinSeparator" or "VertSplit:NvimTreeWinSeparator",
      "StatusLine:NvimTreeStatusLine",
      "StatusLineNC:NvimTreeStatuslineNC",
      "SignColumn:NvimTreeSignColumn",
      "NormalNC:NvimTreeNormalNC",
    }, ","),
  },
}

-- The initial state of a tab
local tabinitial = {
  -- True if help is displayed
  help = false,
  -- The position of the cursor { line, column }
  cursor = { 0, 0 },
  -- The NvimTree window number
  winnr = nil,
}

local BUFNR_PER_TAB = {}
local BUFFER_OPTIONS = {
  swapfile = false,
  buftype = "nofile",
  modifiable = false,
  filetype = "NvimTree",
  bufhidden = "wipe",
  buflisted = false,
}

local function matches_bufnr(bufnr)
  for _, b in pairs(BUFNR_PER_TAB) do
    if b == bufnr then
      return true
    end
  end
  return false
end

local function wipe_rogue_buffer()
  for _, bufnr in ipairs(a.nvim_list_bufs()) do
    if not matches_bufnr(bufnr) and a.nvim_buf_get_name(bufnr):match "NvimTree" ~= nil then
      return pcall(a.nvim_buf_delete, bufnr, { force = true })
    end
  end
end

local function create_buffer(bufnr)
  wipe_rogue_buffer()

  local tab = a.nvim_get_current_tabpage()
  BUFNR_PER_TAB[tab] = bufnr or a.nvim_create_buf(false, false)
  a.nvim_buf_set_name(M.get_bufnr(), "NvimTree_" .. tab)

  for option, value in pairs(BUFFER_OPTIONS) do
    vim.bo[M.get_bufnr()][option] = value
  end

  require("nvim-tree.actions").apply_mappings(M.get_bufnr())
end

local function get_size()
  local width_or_height = M.is_vertical() and "width" or "height"
  local size = M.View[width_or_height]
  if type(size) == "number" then
    return size
  elseif type(size) == "function" then
    return size()
  end
  local size_as_number = tonumber(size:sub(0, -2))
  local percent_as_decimal = size_as_number / 100
  return math.floor(vim.o.columns * percent_as_decimal)
end

local move_tbl = {
  left = "H",
  right = "L",
  bottom = "J",
  top = "K",
}

-- TODO: remove this once they fix https://github.com/neovim/neovim/issues/14670
local function set_local(opt, value)
  local cmd
  if value == true then
    cmd = string.format("setlocal %s", opt)
  elseif value == false then
    cmd = string.format("setlocal no%s", opt)
  else
    cmd = string.format("setlocal %s=%s", opt, value)
  end
  vim.cmd(cmd)
end

-- setup_tabpage sets up the initial state of a tab
local function setup_tabpage(tabpage)
  local winnr = a.nvim_get_current_win()
  M.View.tabpages[tabpage] = vim.tbl_extend("force", M.View.tabpages[tabpage] or tabinitial, { winnr = winnr })
end

local function open_window()
  a.nvim_command "vsp"
  M.reposition_window()
  setup_tabpage(a.nvim_get_current_tabpage())
end

local function set_window_options_and_buffer()
  pcall(vim.cmd, "buffer " .. M.get_bufnr())
  for k, v in pairs(M.View.winopts) do
    set_local(k, v)
  end
end

local function get_existing_buffers()
  return vim.tbl_filter(function(buf)
    return a.nvim_buf_is_valid(buf) and vim.fn.buflisted(buf) == 1
  end, a.nvim_list_bufs())
end

local function switch_buf_if_last_buf()
  if #a.nvim_list_wins() == 1 then
    if #get_existing_buffers() > 0 then
      vim.cmd "sbnext"
    else
      vim.cmd "new"
    end
  end
end

-- save_tab_state saves any state that should be preserved across redraws.
local function save_tab_state()
  local tabpage = a.nvim_get_current_tabpage()
  M.View.cursors[tabpage] = a.nvim_win_get_cursor(M.get_winnr())
end

function M.close()
  if not M.is_visible() then
    return
  end
  save_tab_state()
  switch_buf_if_last_buf()
  local tree_win = M.get_winnr()
  local current_win = a.nvim_get_current_win()
  for _, win in pairs(a.nvim_list_wins()) do
    if tree_win ~= win and a.nvim_win_get_config(win).relative == "" then
      a.nvim_win_close(tree_win, true)
      local prev_win = vim.fn.winnr "#" -- this tab only
      if tree_win == current_win and prev_win > 0 then
        a.nvim_set_current_win(vim.fn.win_getid(prev_win))
      end
      events._dispatch_on_tree_close()
      return
    end
  end
end

function M.open(options)
  if M.is_visible() then
    return
  end

  create_buffer()
  open_window()
  set_window_options_and_buffer()
  M.resize()

  local opts = options or { focus_tree = true }
  if not opts.focus_tree then
    vim.cmd "wincmd p"
  end
  events._dispatch_on_tree_open()
end

function M.resize(size)
  if type(size) == "string" then
    size = vim.trim(size)
    local first_char = size:sub(1, 1)
    size = tonumber(size)

    if first_char == "+" or first_char == "-" then
      size = M.View.width + size
    end
  end

  if type(size) == "number" and size <= 0 then
    return
  end

  if size then
    M.View.width = size
    M.View.height = size
  end

  if not M.is_visible() then
    return
  end

  if M.is_vertical() then
    a.nvim_win_set_width(M.get_winnr(), get_size())
  else
    a.nvim_win_set_height(M.get_winnr(), get_size())
  end

  if not M.View.preserve_window_proportions then
    vim.cmd ":wincmd ="
  end
end

function M.reposition_window()
  local move_to = move_tbl[M.View.side]
  a.nvim_command("wincmd " .. move_to)
  M.resize()
end

local function set_current_win()
  local current_tab = a.nvim_get_current_tabpage()
  M.View.tabpages[current_tab].winnr = a.nvim_get_current_win()
end

function M.open_in_current_win(opts)
  opts = opts or { hijack_current_buf = true, resize = true }
  create_buffer(opts.hijack_current_buf and a.nvim_get_current_buf())
  setup_tabpage(a.nvim_get_current_tabpage())
  set_current_win()
  set_window_options_and_buffer()
  if opts.resize then
    M.reposition_window()
    M.resize()
  end
end

function M.abandon_current_window()
  local tab = a.nvim_get_current_tabpage()
  BUFNR_PER_TAB[tab] = nil
  M.View.tabpages[tab].winnr = nil
end

function M.is_visible(opts)
  if opts and opts.any_tabpage then
    for _, v in pairs(M.View.tabpages) do
      if a.nvim_win_is_valid(v.winnr) then
        return true
      end
    end
    return false
  end

  return M.get_winnr() ~= nil and a.nvim_win_is_valid(M.get_winnr())
end

function M.set_cursor(opts)
  if M.is_visible() then
    pcall(a.nvim_win_set_cursor, M.get_winnr(), opts)
    -- patch until https://github.com/neovim/neovim/issues/17395 is fixed
    require("nvim-tree.renderer").draw()
  end
end

function M.focus(winnr, open_if_closed)
  local wnr = winnr or M.get_winnr()

  if a.nvim_win_get_tabpage(wnr or 0) ~= a.nvim_win_get_tabpage(0) then
    M.close()
    M.open()
    wnr = M.get_winnr()
  elseif open_if_closed and not M.is_visible() then
    M.open()
  end

  a.nvim_set_current_win(wnr)
end

function M.is_vertical()
  return M.View.side == "left" or M.View.side == "right"
end

--- Restores the state of a NvimTree window if it was initialized before.
function M.restore_tab_state()
  local tabpage = a.nvim_get_current_tabpage()
  M.set_cursor(M.View.cursors[tabpage])
end

--- Returns the window number for nvim-tree within the tabpage specified
---@param tabpage number: (optional) the number of the chosen tabpage. Defaults to current tabpage.
---@return number
function M.get_winnr(tabpage)
  tabpage = tabpage or a.nvim_get_current_tabpage()
  local tabinfo = M.View.tabpages[tabpage]
  if tabinfo ~= nil then
    return tabinfo.winnr
  end
end

--- Returns the current nvim tree bufnr
---@return number
function M.get_bufnr()
  return BUFNR_PER_TAB[a.nvim_get_current_tabpage()]
end

--- Checks if nvim-tree is displaying the help ui within the tabpage specified
---@param tabpage number: (optional) the number of the chosen tabpage. Defaults to current tabpage.
---@return number
function M.is_help_ui(tabpage)
  tabpage = tabpage or a.nvim_get_current_tabpage()
  local tabinfo = M.View.tabpages[tabpage]
  if tabinfo ~= nil then
    return tabinfo.help
  end
end

function M.toggle_help(tabpage)
  tabpage = tabpage or a.nvim_get_current_tabpage()
  M.View.tabpages[tabpage].help = not M.View.tabpages[tabpage].help
end

function M.is_buf_valid(bufnr)
  return bufnr and a.nvim_buf_is_valid(bufnr) and a.nvim_buf_is_loaded(bufnr)
end

function M._prevent_buffer_override()
  local view_winnr = M.get_winnr()
  local view_bufnr = M.get_bufnr()

  -- need to schedule to let the new buffer populate the window
  -- because this event needs to be run on bufWipeout.
  -- Otherwise the curwin/curbuf would match the view buffer and the view window.
  vim.schedule(function()
    local curwin = a.nvim_get_current_win()
    local curbuf = a.nvim_win_get_buf(curwin)
    local bufname = a.nvim_buf_get_name(curbuf)
    if not bufname:match "NvimTree" then
      for i, tabpage in ipairs(M.View.tabpages) do
        if tabpage.winnr == view_winnr then
          M.View.tabpages[i] = nil
          break
        end
      end
    end
    if curwin ~= view_winnr or bufname == "" or curbuf == view_bufnr then
      return
    end

    -- patch to avoid the overriding window to be fixed in size
    -- might need a better patch
    vim.cmd "setlocal nowinfixwidth"
    vim.cmd "setlocal nowinfixheight"
    M.open { focus_tree = false }
    require("nvim-tree.renderer").draw()
    a.nvim_win_close(curwin, { force = true })
    require("nvim-tree.actions.open-file").fn("edit", bufname)
  end)
end

function M.is_root_folder_visible(cwd)
  return cwd ~= "/" and not M.View.hide_root_folder
end

function M.setup(opts)
  local options = opts.view or {}
  M.View.side = options.side
  M.View.width = options.width
  M.View.height = options.height
  M.View.hide_root_folder = options.hide_root_folder
  M.View.preserve_window_proportions = options.preserve_window_proportions
  M.View.winopts.number = options.number
  M.View.winopts.relativenumber = options.relativenumber
  M.View.winopts.signcolumn = options.signcolumn
end

return M
