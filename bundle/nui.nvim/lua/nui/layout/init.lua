local Object = require("nui.object")
local Popup = require("nui.popup")
local Split = require("nui.split")
local utils = require("nui.utils")
local layout_utils = require("nui.layout.utils")
local float_layout = require("nui.layout.float")
local split_layout = require("nui.layout.split")
local split_utils = require("nui.split.utils")
local autocmd = require("nui.utils.autocmd")

local _ = utils._

local defaults = utils.defaults
local is_type = utils.is_type
local u = {
  get_next_id = _.get_next_id,
  position = layout_utils.position,
  size = layout_utils.size,
  split = split_utils,
  update_layout_config = layout_utils.update_layout_config,
}

-- GitHub Issue: https://github.com/neovim/neovim/issues/18925
local function apply_workaround_for_float_relative_position_issue_18925(layout)
  local current_winid = vim.api.nvim_get_current_win()

  vim.api.nvim_set_current_win(layout.winid)
  vim.api.nvim_command("redraw!")
  vim.api.nvim_set_current_win(current_winid)
end

local function merge_default_options(options)
  options.relative = defaults(options.relative, "win")

  return options
end

local function normalize_options(options)
  options = _.normalize_layout_options(options)

  return options
end

local function is_box(object)
  return object and (object.box or object.component)
end

local function is_component(object)
  return object and object.mount
end

local function is_component_mounted(component)
  return is_type("number", component.winid)
end

local function get_layout_config_relative_to_component(component)
  return {
    relative = { type = "win", winid = component.winid },
    position = { row = 0, col = 0 },
    size = { width = "100%", height = "100%" },
  }
end

---@param layout NuiLayout
---@param box table Layout.Box
local function wire_up_layout_components(layout, box)
  for _, child in ipairs(box.box) do
    if child.component then
      autocmd.create({ "BufWipeout", "QuitPre" }, {
        group = layout._.augroup.unmount,
        buffer = child.component.bufnr,
        callback = vim.schedule_wrap(function()
          layout:unmount()
        end),
      }, child.component.bufnr)

      autocmd.create("BufWinEnter", {
        group = layout._.augroup.unmount,
        buffer = child.component.bufnr,
        callback = function()
          local winid = child.component.winid
          if layout._.type == "float" and not winid then
            --[[
              `BufWinEnter` does not contain window id and
              it is fired before `nvim_open_win` returns
              the window id.
            --]]
            winid = vim.fn.bufwinid(child.component.bufnr)
          end

          autocmd.create("WinClosed", {
            group = layout._.augroup.hide,
            pattern = tostring(winid),
            callback = function()
              layout:hide()
            end,
          }, child.component.bufnr)
        end,
      }, child.component.bufnr)
    else
      wire_up_layout_components(layout, child)
    end
  end
end

---@class NuiLayout
local Layout = Object("NuiLayout")

---@return '"float"'|'"split"' layout_type
local function get_layout_type(box)
  for _, child in ipairs(box.box) do
    if child.component and child.type then
      return child.type
    end

    local type = get_layout_type(child)
    if type then
      return type
    end
  end

  error("unexpected empty box")
end

function Layout:init(options, box)
  local id = u.get_next_id()

  box = Layout.Box(box)

  local type = get_layout_type(box)

  self._ = {
    id = id,
    type = type,
    box = box,
    loading = false,
    mounted = false,
    augroup = {
      hide = string.format("%s_hide", id),
      unmount = string.format("%s_unmount", id),
    },
  }

  if type == "float" then
    local container
    if is_component(options) then
      container = options
      options = get_layout_config_relative_to_component(container)
    else
      options = merge_default_options(options)
      options = normalize_options(options)
    end

    self._[type] = {
      container = container,
      layout = {},
      win_enter = false,
      win_config = {
        focusable = false,
        style = "minimal",
        zindex = 49,
      },
      win_options = {
        winblend = 100,
      },
    }

    if not is_component(container) or is_component_mounted(container) then
      self:update(options)
    end
  end

  if type == "split" then
    options = u.split.merge_default_options(options)
    options = u.split.normalize_options(options)

    self._[type] = {
      layout = {},
      position = options.position,
      size = {},
      win_config = {
        pending_changes = {},
      },
    }

    self:update(options)
  end
end

function Layout:_process_layout()
  local type = self._.type

  if type == "float" then
    local info = self._.float

    apply_workaround_for_float_relative_position_issue_18925(self)

    float_layout.process(self._.box, {
      winid = self.winid,
      container_size = info.size,
      position = {
        row = 0,
        col = 0,
      },
    })

    return
  end

  if type == "split" then
    local info = self._.split

    split_layout.process(self._.box, {
      position = info.position,
      relative = info.relative,
      container_size = info.size,
      container_fallback_size = info.container_info.size,
    })
  end
end

function Layout:_open_window()
  if self._.type == "float" then
    local info = self._.float

    self.winid = vim.api.nvim_open_win(self.bufnr, info.win_enter, info.win_config)
    assert(self.winid, "failed to create popup window")

    _.set_win_options(self.winid, info.win_options)
  end
end

function Layout:_close_window()
  if not self.winid then
    return
  end

  if vim.api.nvim_win_is_valid(self.winid) then
    vim.api.nvim_win_close(self.winid, true)
  end

  self.winid = nil
end

function Layout:mount()
  if self._.loading or self._.mounted then
    return
  end

  self._.loading = true

  local type = self._.type

  if type == "float" then
    local info = self._.float

    local container = info.container
    if is_component(container) and not is_component_mounted(container) then
      container:mount()
      self:update(get_layout_config_relative_to_component(container))
    end

    if not self.bufnr then
      self.bufnr = vim.api.nvim_create_buf(false, true)
      assert(self.bufnr, "failed to create buffer")
    end

    self:_open_window()
  end

  self:_process_layout()

  if type == "float" then
    float_layout.mount_box(self._.box)
  end

  if type == "split" then
    split_layout.mount_box(self._.box)
  end

  self._.loading = false
  self._.mounted = true
end

function Layout:unmount()
  if self._.loading or not self._.mounted then
    return
  end

  pcall(autocmd.delete_group, self._.augroup.hide)
  pcall(autocmd.delete_group, self._.augroup.unmount)

  self._.loading = true

  local type = self._.type

  if type == "float" then
    float_layout.unmount_box(self._.box)

    if self.bufnr then
      if vim.api.nvim_buf_is_valid(self.bufnr) then
        vim.api.nvim_buf_delete(self.bufnr, { force = true })
      end
      self.bufnr = nil
    end

    self:_close_window()
  end

  if type == "split" then
    split_layout.unmount_box(self._.box)
  end

  self._.loading = false
  self._.mounted = false
end

function Layout:hide()
  if self._.loading or not self._.mounted then
    return
  end

  self._.loading = true

  pcall(autocmd.delete_group, self._.augroup.hide)

  local type = self._.type

  if type == "float" then
    float_layout.hide_box(self._.box)

    self:_close_window()
  end

  if type == "split" then
    split_layout.hide_box(self._.box)
  end

  self._.loading = false
end

function Layout:show()
  if self._.loading or not self._.mounted then
    return
  end

  self._.loading = true

  autocmd.create_group(self._.augroup.hide, { clear = true })

  local type = self._.type

  if type == "float" then
    self:_open_window()
  end

  self:_process_layout()

  if type == "float" then
    float_layout.show_box(self._.box)
  end

  if type == "split" then
    split_layout.show_box(self._.box)
  end

  self._.loading = false
end

function Layout:update(config, box)
  config = config or {}

  if not box and is_box(config) or is_box(config[1]) then
    box = config
    config = {}
  end

  autocmd.create_group(self._.augroup.hide, { clear = true })
  autocmd.create_group(self._.augroup.unmount, { clear = true })

  local prev_box = self._.box

  if box then
    self._.box = Layout.Box(box)
    self._.type = get_layout_type(self._.box)
  end

  if self._.type == "float" then
    local info = self._.float

    u.update_layout_config(info, config)

    if self.winid then
      vim.api.nvim_win_set_config(self.winid, info.win_config)

      self:_process_layout()

      float_layout.process_box_change(self._.box, prev_box)
    end

    wire_up_layout_components(self, self._.box)
  end

  if self._.type == "split" then
    local info = self._.split

    local relative_winid = info.relative and info.relative.win

    local prev_winid = vim.api.nvim_get_current_win()
    if relative_winid then
      vim.api.nvim_set_current_win(relative_winid)
    end

    local curr_box = self._.box
    if prev_box ~= curr_box then
      self._.box = prev_box
      self:hide()
      self._.box = curr_box
    end

    u.split.update_layout_config(info, config)

    if prev_box == curr_box then
      self:_process_layout()
    else
      self:show()
    end

    if vim.api.nvim_win_is_valid(prev_winid) then
      vim.api.nvim_set_current_win(prev_winid)
    end

    wire_up_layout_components(self, self._.box)
  end
end

function Layout.Box(box, options)
  options = options or {}

  if is_box(box) then
    return box
  end

  if box.mount then
    local type
    if box:is_instance_of(Popup) then
      type = "float"
    elseif box:is_instance_of(Split) then
      type = "split"
    end

    if not type then
      error("unsupported component")
    end

    return {
      type = type,
      component = box,
      grow = options.grow,
      size = options.size,
    }
  end

  local dir = defaults(options.dir, "row")

  -- normalize children size
  for _, child in ipairs(box) do
    if not child.grow and not child.size then
      error("missing child.size")
    end

    if dir == "row" then
      if not is_type("table", child.size) then
        child.size = { width = child.size }
      end
      if not child.size.height then
        child.size.height = "100%"
      end
    elseif dir == "col" then
      if not is_type("table", child.size) then
        child.size = { height = child.size }
      end
      if not child.size.width then
        child.size.width = "100%"
      end
    end
  end

  return {
    box = box,
    dir = dir,
    grow = options.grow,
    size = options.size,
  }
end

---@alias NuiLayout.constructor fun(options: table, box: table): NuiLayout
---@type NuiLayout|NuiLayout.constructor
local NuiLayout = Layout

return NuiLayout
