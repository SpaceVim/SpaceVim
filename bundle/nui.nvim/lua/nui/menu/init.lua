local Line = require("nui.line")
local Popup = require("nui.popup")
local Text = require("nui.text")
local Tree = require("nui.tree")
local _ = require("nui.utils")._
local defaults = require("nui.utils").defaults
local is_type = require("nui.utils").is_type

local function calculate_initial_max_width(items)
  local max_width = 0

  for _, item in ipairs(items) do
    local width = 0
    if is_type("string", item.text) then
      width = vim.api.nvim_strwidth(item.text)
    elseif is_type("table", item.text) and item.text.width then
      width = item.text:width()
    end

    if max_width < width then
      max_width = width
    end
  end

  return max_width
end

local default_keymap = {
  close = { "<Esc>", "<C-c>" },
  focus_next = { "j", "<Down>", "<Tab>" },
  focus_prev = { "k", "<Up>", "<S-Tab>" },
  submit = { "<CR>" },
}

---@param keymap table<string, string|string[]>
---@return table<string, string[]>
local function parse_keymap(keymap)
  local result = defaults(keymap, {})

  for name, default_keys in pairs(default_keymap) do
    if is_type("nil", result[name]) then
      result[name] = default_keys
    elseif is_type("string", result[name]) then
      result[name] = { result[name] }
    end
  end

  return result
end

---@type nui_menu_should_skip_item
local function default_should_skip_item(node)
  return node._type == "separator"
end

---@param menu NuiMenu
---@return nui_menu_prepare_item
local function make_default_prepare_node(menu)
  local border = menu.border

  local fallback_sep = {
    char = Text(is_type("table", border._.char) and border._.char.top or " "),
    text_align = is_type("table", border._.text) and border._.text.top_align or "left",
  }

  -- luacov: disable
  if menu._.sep then
    -- @deprecated

    if menu._.sep.char then
      fallback_sep.char = Text(menu._.sep.char)
    end

    if menu._.sep.text_align then
      fallback_sep.text_align = menu._.sep.text_align
    end
  end
  -- luacov: enable

  local max_width = menu._.size.width

  ---@type nui_menu_prepare_item
  local function default_prepare_node(node)
    ---@type NuiText|NuiLine
    local content = is_type("string", node.text) and Text(node.text) or node.text

    if node._type == "item" then
      if content:width() > max_width then
        if is_type("function", content.set) then
          ---@cast content NuiText
          _.truncate_nui_text(content, max_width)
        else
          ---@cast content NuiLine
          _.truncate_nui_line(content, max_width)
        end
      end

      local line = Line()

      line:append(content)

      return line
    end

    if node._type == "separator" then
      local sep_char = Text(defaults(node._char, fallback_sep.char))
      local sep_text_align = defaults(node._text_align, fallback_sep.text_align)

      local sep_max_width = max_width - sep_char:width() * 2

      if content:width() > sep_max_width then
        if is_type("function", content.set) then
          ---@cast content NuiText
          _.truncate_nui_text(content, sep_max_width)
        else
          ---@cast content NuiLine
          _.truncate_nui_line(content, sep_max_width)
        end
      end

      local left_gap_width, right_gap_width = _.calculate_gap_width(
        defaults(sep_text_align, "center"),
        sep_max_width,
        content:width()
      )

      local line = Line()

      line:append(Text(sep_char))

      if left_gap_width > 0 then
        line:append(Text(sep_char):set(string.rep(sep_char:content(), left_gap_width)))
      end

      line:append(content)

      if right_gap_width > 0 then
        line:append(Text(sep_char):set(string.rep(sep_char:content(), right_gap_width)))
      end

      line:append(Text(sep_char))

      return line
    end
  end

  return default_prepare_node
end

---@param menu NuiMenu
---@param direction "'next'" | "'prev'"
---@param current_linenr nil | number
local function focus_item(menu, direction, current_linenr)
  local curr_linenr = current_linenr or vim.api.nvim_win_get_cursor(menu.winid)[1]

  local next_linenr = nil

  if direction == "next" then
    if curr_linenr == #menu.tree.nodes.root_ids then
      next_linenr = 1
    else
      next_linenr = curr_linenr + 1
    end
  elseif direction == "prev" then
    if curr_linenr == 1 then
      next_linenr = #menu.tree.nodes.root_ids
    else
      next_linenr = curr_linenr - 1
    end
  end

  local next_node = menu.tree:get_node(next_linenr)

  if menu._.should_skip_item(next_node) then
    return focus_item(menu, direction, next_linenr)
  end

  if next_linenr then
    vim.api.nvim_win_set_cursor(menu.winid, { next_linenr, 0 })
    menu._.on_change(next_node)
  end
end

--luacheck: push no max line length

---@alias nui_menu_prepare_item nui_tree_prepare_node
---@alias nui_menu_should_skip_item fun(node: NuiTreeNode): boolean
---@alias nui_menu_internal nui_popup_internal|{ items: NuiTreeNode[], keymap: table<string,string[]>, sep: { char?: string|NuiText, text_align?: nui_t_text_align }, prepare_item: nui_menu_prepare_item, should_skip_item: nui_menu_should_skip_item }

--luacheck: pop

---@class NuiMenu: NuiPopup
---@field private _ nui_menu_internal
local Menu = Popup:extend("NuiMenu")

---@param content? string|NuiText|NuiLine
---@param options? { char?: string|NuiText, text_align?: nui_t_text_align }
---@return NuiTreeNode
function Menu.separator(content, options)
  options = options or {}
  return Tree.Node({
    _id = tostring(math.random()),
    _type = "separator",
    _char = options.char,
    _text_align = options.text_align,
    text = defaults(content, ""),
  })
end

---@param content string|NuiText|NuiLine
---@param data? table
---@return NuiTreeNode
function Menu.item(content, data)
  if not data then
    ---@diagnostic disable-next-line: undefined-field
    if is_type("table", content) and content.text then
      ---@cast content table
      data = content
    else
      data = { text = content }
    end
  else
    data.text = content
  end

  data._type = "item"
  data._id = data.id or tostring(math.random())

  return Tree.Node(data)
end

---@param popup_options table
---@param options table
function Menu:init(popup_options, options)
  local max_width = calculate_initial_max_width(options.lines)

  local width = math.max(math.min(max_width, defaults(options.max_width, 256)), defaults(options.min_width, 4))
  local height = math.max(math.min(#options.lines, defaults(options.max_height, 256)), defaults(options.min_height, 1))

  popup_options = vim.tbl_deep_extend("force", {
    enter = true,
    size = {
      width = width,
      height = height,
    },
    win_options = {
      cursorline = true,
      scrolloff = 1,
      sidescrolloff = 0,
    },
  }, popup_options)

  Menu.super.init(self, popup_options)

  self._.items = options.lines
  self._.keymap = parse_keymap(options.keymap)

  ---@param node NuiTreeNode
  self._.on_change = function(node)
    if options.on_change then
      options.on_change(node, self)
    end
  end

  -- @deprecated
  self._.sep = options.separator

  self._.should_skip_item = defaults(options.should_skip_item, default_should_skip_item)
  self._.prepare_item = defaults(options.prepare_item, make_default_prepare_node(self))

  self.menu_props = {}

  local props = self.menu_props

  props.on_submit = function()
    local item = self.tree:get_node()

    self:unmount()

    if options.on_submit then
      options.on_submit(item)
    end
  end

  props.on_close = function()
    self:unmount()

    if options.on_close then
      options.on_close()
    end
  end

  props.on_focus_next = function()
    focus_item(self, "next")
  end

  props.on_focus_prev = function()
    focus_item(self, "prev")
  end
end

function Menu:mount()
  Menu.super.mount(self)

  local props = self.menu_props

  for _, key in pairs(self._.keymap.focus_next) do
    self:map("n", key, props.on_focus_next, { noremap = true, nowait = true })
  end

  for _, key in pairs(self._.keymap.focus_prev) do
    self:map("n", key, props.on_focus_prev, { noremap = true, nowait = true })
  end

  for _, key in pairs(self._.keymap.close) do
    self:map("n", key, props.on_close, { noremap = true, nowait = true })
  end

  for _, key in pairs(self._.keymap.submit) do
    self:map("n", key, props.on_submit, { noremap = true, nowait = true })
  end

  self.tree = Tree({
    winid = self.winid,
    ns_id = self.ns_id,
    nodes = self._.items,
    get_node_id = function(node)
      return node._id
    end,
    prepare_node = self._.prepare_item,
  })

  ---@deprecated
  self._tree = self.tree

  self.tree:render()

  -- focus first item
  for linenr = 1, #self.tree.nodes.root_ids do
    local node, target_linenr = self.tree:get_node(linenr)
    if not self._.should_skip_item(node) then
      vim.api.nvim_win_set_cursor(self.winid, { target_linenr, 0 })
      self._.on_change(node)
      break
    end
  end
end

---@alias NuiMenu.constructor fun(popup_options: table, options: table): NuiMenu
---@type NuiMenu|NuiMenu.constructor
local NuiMenu = Menu

return NuiMenu
