local Object = require("nui.object")
local _ = require("nui.utils")._
local defaults = require("nui.utils").defaults
local is_type = require("nui.utils").is_type
local tree_util = require("nui.tree.util")

local u = {
  clear_namespace = _.clear_namespace,
  normalize_namespace_id = _.normalize_namespace_id,
}

---@param bufnr number
---@param linenr_range { [1]: integer, [2]: integer }
local function clear_buf_lines(bufnr, linenr_range)
  local count = linenr_range[2] - linenr_range[1] + 1

  if count < 1 then
    return
  end

  local lines = {}
  for i = 1, count do
    lines[i] = ""
  end

  vim.api.nvim_buf_set_lines(bufnr, linenr_range[1] - 1, linenr_range[2], false, lines)
end

-- returns id of the first window that contains the buffer
---@param bufnr number
---@return number winid
local function get_winid(bufnr)
  return vim.fn.win_findbuf(bufnr)[1]
end

---@param nodes NuiTreeNode[]
---@param parent_node? NuiTreeNode
---@param get_node_id nui_tree_get_node_id
---@return { by_id: table<string, NuiTreeNode>, root_ids: string[] }
local function initialize_nodes(nodes, parent_node, get_node_id)
  local start_depth = parent_node and parent_node:get_depth() + 1 or 1

  ---@type table<string, NuiTreeNode>
  local by_id = {}
  ---@type string[]
  local root_ids = {}

  ---@param node NuiTreeNode
  ---@param depth number
  local function initialize(node, depth)
    node._depth = depth
    node._id = get_node_id(node)
    node._initialized = true

    local node_id = node:get_id()

    if by_id[node_id] then
      error("duplicate node id" .. node_id)
    end

    by_id[node_id] = node

    if depth == start_depth then
      table.insert(root_ids, node_id)
    end

    if not node.__children or #node.__children == 0 then
      return
    end

    if not node._child_ids then
      node._child_ids = {}
    end

    for _, child_node in ipairs(node.__children) do
      child_node._parent_id = node_id
      initialize(child_node, depth + 1)
      table.insert(node._child_ids, child_node:get_id())
    end

    node.__children = nil
  end

  for _, node in ipairs(nodes) do
    node._parent_id = parent_node and parent_node:get_id() or nil
    initialize(node, start_depth)
  end

  return {
    by_id = by_id,
    root_ids = root_ids,
  }
end

---@class NuiTreeNode
local TreeNode = {
  super = nil,
}

---@return string
function TreeNode:get_id()
  return self._id
end

---@return number
function TreeNode:get_depth()
  return self._depth
end

---@return string|nil
function TreeNode:get_parent_id()
  return self._parent_id
end

---@return boolean
function TreeNode:has_children()
  return #(self._child_ids or self.__children or {}) > 0
end

---@return string[]
function TreeNode:get_child_ids()
  return self._child_ids or {}
end

---@return boolean
function TreeNode:is_expanded()
  return self._is_expanded
end

---@return boolean is_updated
function TreeNode:expand()
  if self:has_children() and not self:is_expanded() then
    self._is_expanded = true
    return true
  end
  return false
end

---@return boolean is_updated
function TreeNode:collapse()
  if self:is_expanded() then
    self._is_expanded = false
    return true
  end
  return false
end

--luacheck: push no max line length

---@alias nui_tree_get_node_id fun(node: NuiTreeNode): string
---@alias nui_tree_prepare_node fun(node: NuiTreeNode, parent_node?: NuiTreeNode): nil | string | string[] | NuiLine | NuiLine[]
---@alias nui_tree_internal { buf_options: table<string,any>, win_options: table<string,any>, get_node_id: nui_tree_get_node_id, prepare_node: nui_tree_prepare_node, track_tree_linenr?: boolean }

--luacheck: pop

---@class NuiTree
---@field bufnr integer
---@field nodes { by_id: table<string,NuiTreeNode>, root_ids: string[] }
---@field ns_id integer
---@field private _ nui_tree_internal
---@field winid number # @deprecated
local Tree = Object("NuiTree")

function Tree:init(options)
  ---@deprecated
  if options.winid then
    if not vim.api.nvim_win_is_valid(options.winid) then
      error("invalid winid " .. options.winid)
    end

    self.winid = options.winid
    self.bufnr = vim.api.nvim_win_get_buf(self.winid)
  end

  if options.bufnr then
    if not vim.api.nvim_buf_is_valid(options.bufnr) then
      error("invalid bufnr " .. options.bufnr)
    end

    self.bufnr = options.bufnr
    self.winid = nil
  end

  if not self.bufnr then
    error("missing bufnr")
  end

  self.ns_id = u.normalize_namespace_id(options.ns_id)

  self._ = {
    buf_options = vim.tbl_extend("force", {
      bufhidden = "hide",
      buflisted = false,
      buftype = "nofile",
      modifiable = false,
      readonly = true,
      swapfile = false,
      undolevels = 0,
    }, defaults(options.buf_options, {})),
    ---@deprecated
    win_options = vim.tbl_extend("force", {
      foldcolumn = "0",
      foldmethod = "manual",
      wrap = false,
    }, defaults(options.win_options, {})),
    get_node_id = defaults(options.get_node_id, tree_util.default_get_node_id),
    prepare_node = defaults(options.prepare_node, tree_util.default_prepare_node),
    track_tree_linenr = nil,
  }

  _.set_buf_options(self.bufnr, self._.buf_options)

  ---@deprecated
  if self.winid then
    _.set_win_options(self.winid, self._.win_options)
  end

  self:set_nodes(defaults(options.nodes, {}))
end

---@generic D : table
---@param data D data table
---@param children NuiTreeNode[]
---@return NuiTreeNode|D
function Tree.Node(data, children)
  ---@type NuiTreeNode
  local self = {
    __children = children,
    _initialized = false,
    _is_expanded = false,
    _child_ids = nil,
    _parent_id = nil,
    _depth = nil,
    _id = nil,
  }

  self = setmetatable(vim.tbl_extend("keep", self, data), {
    __index = TreeNode,
    __name = "NuiTreeNode",
  })

  return self
end

---@param node_id_or_linenr? string | number
---@return NuiTreeNode|nil node
---@return number|nil linenr
function Tree:get_node(node_id_or_linenr)
  if is_type("string", node_id_or_linenr) then
    return self.nodes.by_id[node_id_or_linenr], unpack(self._content.linenr_by_node_id[node_id_or_linenr] or {})
  end

  local winid = get_winid(self.bufnr)
  local linenr = node_id_or_linenr or vim.api.nvim_win_get_cursor(winid)[1]
  local node_id = self._content.node_id_by_linenr[linenr]
  return self.nodes.by_id[node_id], unpack(self._content.linenr_by_node_id[node_id] or {})
end

---@param parent_id? string parent node's id
---@return NuiTreeNode[] nodes
function Tree:get_nodes(parent_id)
  local node_ids = {}

  if parent_id then
    local parent_node = self.nodes.by_id[parent_id]
    if parent_node then
      node_ids = parent_node._child_ids
    end
  else
    node_ids = self.nodes.root_ids
  end

  return vim.tbl_map(function(id)
    return self.nodes.by_id[id]
  end, node_ids or {})
end

---@param nodes NuiTreeNode[]
---@param parent_node? NuiTreeNode
function Tree:_add_nodes(nodes, parent_node)
  local new_nodes = initialize_nodes(nodes, parent_node, self._.get_node_id)

  self.nodes.by_id = vim.tbl_extend("force", self.nodes.by_id, new_nodes.by_id)

  if parent_node then
    if not parent_node._child_ids then
      parent_node._child_ids = {}
    end

    for _, id in ipairs(new_nodes.root_ids) do
      table.insert(parent_node._child_ids, id)
    end
  else
    for _, id in ipairs(new_nodes.root_ids) do
      table.insert(self.nodes.root_ids, id)
    end
  end
end

---@param nodes NuiTreeNode[]
---@param parent_id? string parent node's id
function Tree:set_nodes(nodes, parent_id)
  --luacheck: push no max line length

  ---@type { linenr: {[1]?:integer,[2]?:integer}, lines: string[]|NuiLine[], node_id_by_linenr: table<number,string>, linenr_by_node_id: table<string, {[1]:integer,[2]:integer}> }
  self._content = { linenr = {}, lines = {}, node_id_by_linenr = {}, linenr_by_node_id = {} }

  --luacheck: pop

  if not parent_id then
    self.nodes = { by_id = {}, root_ids = {} }
    self:_add_nodes(nodes)
    return
  end

  local parent_node = self.nodes.by_id[parent_id]
  if not parent_node then
    error("invalid parent_id " .. parent_id)
  end

  if parent_node._child_ids then
    for _, node_id in ipairs(parent_node._child_ids) do
      self.nodes.by_id[node_id] = nil
    end

    parent_node._child_ids = nil
  end

  self:_add_nodes(nodes, parent_node)
end

---@param node NuiTreeNode
---@param parent_id? string parent node's id
function Tree:add_node(node, parent_id)
  local parent_node = self.nodes.by_id[parent_id]
  if parent_id and not parent_node then
    error("invalid parent_id " .. parent_id)
  end

  self:_add_nodes({ node }, parent_node)
end

local function remove_node(tree, node_id)
  local node = tree.nodes.by_id[node_id]
  if node:has_children() then
    for _, child_id in ipairs(node._child_ids) do
      -- We might want to store the nodes and return them with the node itself?
      -- We should _really_ not be doing this recursively, but it will work for now
      remove_node(tree, child_id)
    end
  end
  tree.nodes.by_id[node_id] = nil
  return node
end

---@param node_id string
---@return NuiTreeNode
function Tree:remove_node(node_id)
  local node = remove_node(self, node_id)
  local parent_id = node._parent_id
  if parent_id then
    local parent_node = self.nodes.by_id[parent_id]
    parent_node._child_ids = vim.tbl_filter(function(id)
      return id ~= node_id
    end, parent_node._child_ids)
  else
    self.nodes.root_ids = vim.tbl_filter(function(id)
      return id ~= node_id
    end, self.nodes.root_ids)
  end
  return node
end

---@param linenr_start number start line number (1-indexed)
function Tree:_prepare_content(linenr_start)
  self._content.lines = {}
  self._content.node_id_by_linenr = {}
  self._content.linenr_by_node_id = {}

  local current_linenr = 1

  local function prepare(node_id, parent_node)
    local node = self.nodes.by_id[node_id]
    if not node then
      return
    end

    local lines = self._.prepare_node(node, parent_node)

    if lines then
      if not is_type("table", lines) or lines.content then
        lines = { lines }
      end

      local linenr = {}
      for _, line in ipairs(lines) do
        self._content.lines[current_linenr] = line
        self._content.node_id_by_linenr[current_linenr + linenr_start - 1] = node:get_id()
        linenr[1] = linenr[1] or (current_linenr + linenr_start - 1)
        linenr[2] = (current_linenr + linenr_start - 1)
        current_linenr = current_linenr + 1
      end
      self._content.linenr_by_node_id[node:get_id()] = linenr
    end

    if not node:has_children() or not node:is_expanded() then
      return
    end

    for _, child_node_id in ipairs(node:get_child_ids()) do
      prepare(child_node_id, node)
    end
  end

  for _, node_id in ipairs(self.nodes.root_ids) do
    prepare(node_id)
  end

  self._content.linenr = { linenr_start, current_linenr - 1 + linenr_start - 1 }
end

---@param linenr_start? number start line number (1-indexed)
function Tree:render(linenr_start)
  if is_type("nil", self._.track_tree_linenr) then
    self._.track_tree_linenr = is_type("number", linenr_start)
  end

  linenr_start = linenr_start or self._content.linenr[1] or 1

  local prev_linenr = { self._content.linenr[1], self._content.linenr[2] }
  self:_prepare_content(linenr_start)
  local next_linenr = { self._content.linenr[1], self._content.linenr[2] }

  _.set_buf_options(self.bufnr, { modifiable = true, readonly = false })

  local buf_lines = vim.tbl_map(function(line)
    if is_type("string", line) then
      return line
    end
    return line:content()
  end, self._content.lines)

  if self._.track_tree_linenr then
    u.clear_namespace(self.bufnr, self.ns_id, prev_linenr[1], prev_linenr[2])

    -- if linenr_start was shifted downwards, clear the
    -- previously rendered buffer lines above the tree.
    clear_buf_lines(self.bufnr, {
      math.min(next_linenr[1], prev_linenr[1] or next_linenr[1]),
      prev_linenr[1] and next_linenr[1] - 1 or 0,
    })

    -- for initial render, start inserting the tree in a single buffer line.
    local content_linenr_range = {
      next_linenr[1],
      next_linenr[1],
    }
    -- for subsequent renders, replace the buffer lines from previous tree.
    if prev_linenr[1] then
      content_linenr_range[2] = prev_linenr[2] < next_linenr[2] and math.min(next_linenr[2], prev_linenr[2])
        or math.max(next_linenr[2], prev_linenr[2])
    end

    vim.api.nvim_buf_set_lines(self.bufnr, content_linenr_range[1] - 1, content_linenr_range[2], false, buf_lines)
  else
    u.clear_namespace(self.bufnr, self.ns_id)

    vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, buf_lines)
  end

  for i, line in ipairs(self._content.lines) do
    if not is_type("string", line) then
      line:highlight(self.bufnr, self.ns_id, i + linenr_start - 1)
    end
  end

  _.set_buf_options(self.bufnr, { modifiable = false, readonly = true })
end

---@alias NuiTree.constructor fun(options: table): NuiTree
---@type NuiTree|NuiTree.constructor
local NuiTree = Tree

return NuiTree
