---Utilities functions for the document_symbols source
local renderer = require("neo-tree.ui.renderer")
local filters = require("neo-tree.sources.document_symbols.lib.client_filters")
local kinds = require("neo-tree.sources.document_symbols.lib.kinds")

local M = {}

---@alias Loc integer[] a location in a buffer {row, col}, 0-indexed
---@alias LocRange { start: Loc, ["end"]: Loc } a range consisting of two loc

---@class SymbolExtra
---@field bufnr integer the buffer containing the symbols,
---@field kind string the kind of each symbol
---@field selection_range LocRange the symbol's location
---@field position Loc start of symbol's definition
---@field end_position Loc start of symbol's definition

---@class SymbolNode see
---@field id string
---@field name string name of symbol
---@field path string buffer path - should all be the same
---@field type "root"|"symbol"
---@field children SymbolNode[]
---@field extra SymbolExtra additional info

---@alias LspLoc { line: integer, character: integer}
---@alias LspRange { start : LspLoc, ["end"]: LspLoc }
---@class LspRespNode
---@field name string
---@field detail string?
---@field kind integer
---@field tags any
---@field deprecated boolean?
---@field range LspRange
---@field selectionRange LspRange
---@field children LspRespNode[]

---Parse the LspRange
---@param range LspRange the LspRange object to parse
---@return LocRange range the parsed range
local parse_range = function(range)
  return {
    start = { range.start.line, range.start.character },
    ["end"] = { range["end"].line, range["end"].character },
  }
end

---Compare two tuples of length 2 by first - second elements
---@param a Loc
---@param b Loc
---@return boolean
local loc_less_than = function(a, b)
  if a[1] < b[1] then
    return true
  elseif a[1] == b[1] then
    return a[2] <= b[2]
  end
  return false
end

---Check whether loc is contained in range, i.e range[1] <= loc <= range[2]
---@param loc Loc
---@param range LocRange
---@return boolean
M.is_loc_in_range = function(loc, range)
  return loc_less_than(range[1], loc) and loc_less_than(loc, range[2])
end

---Get the the current symbol under the cursor
---@param tree any the Nui symbol tree
---@param loc Loc the cursor location {row, col} (0-index)
---@return string node_id
M.get_symbol_by_loc = function(tree, loc)
  local function dfs(node)
    local node_id = node:get_id()
    if node:has_children() then
      for _, child in ipairs(tree:get_nodes(node_id)) do
        if M.is_loc_in_range(loc, { child.extra.position, child.extra.end_position }) then
          return dfs(child)
        end
      end
    end
    return node_id
  end

  for _, root in ipairs(tree:get_nodes()) do
    local node_id = dfs(root)
    if node_id ~= root:get_id() then
      return node_id
    end
  end
  return ""
end

---Parse the LSP response into a tree. Each node on the tree follows
---the same structure as a NuiTree node, with the extra field
---containing additional information.
---@param resp_node LspRespNode the LSP response node
---@param id string the id of the current node
---@return SymbolNode symb_node the parsed tree
local function parse_resp(resp_node, id, state, parent_search_path)
  -- parse all children
  local children = {}
  local search_path = parent_search_path .. "/" .. resp_node.name
  for i, child in ipairs(resp_node.children or {}) do
    local child_node = parse_resp(child, id .. "." .. i, state, search_path)
    table.insert(children, child_node)
  end

  -- parse current node
  local preview_range = parse_range(resp_node.range)
  local symb_node = {
    id = id,
    name = resp_node.name,
    type = "symbol",
    path = state.path,
    children = children,
    extra = {
      bufnr = state.lsp_bufnr,
      kind = kinds.get_kind(resp_node.kind),
      selection_range = parse_range(resp_node.selectionRange),
      search_path = search_path,
      -- detail = resp_node.detail,
      position = preview_range.start,
      end_position = preview_range["end"],
    },
  }
  return symb_node
end

---Callback function for lsp request
---@param lsp_resp LspRespRaw the response of the lsp client
---@param state table the state of the source
local on_lsp_resp = function(lsp_resp, state)
  if lsp_resp == nil or type(lsp_resp) ~= "table" then
    return
  end

  -- filter the response to get only the desired LSP
  local resp = filters.filter_resp(lsp_resp)

  local bufname = state.path
  local items = {}

  -- parse each client's response
  for client_name, client_result in pairs(resp) do
    local symbol_list = {}
    for i, resp_node in ipairs(client_result) do
      table.insert(symbol_list, parse_resp(resp_node, #items .. "." .. i, state, "/"))
    end

    -- add the parsed response to the tree
    local splits = vim.split(bufname, "/")
    local filename = splits[#splits]
    table.insert(items, {
      id = "" .. #items,
      name = string.format("SYMBOLS (%s) in %s", client_name, filename),
      path = bufname,
      type = "root",
      children = symbol_list,
      extra = { kind = kinds.get_kind(0), search_path = "/" },
    })
  end
  renderer.show_nodes(items, state)
end

M.render_symbols = function(state)
  local bufnr = state.lsp_bufnr
  local bufname = state.path

  -- if no client found, terminate
  local client_found = false
  for _, client in pairs(vim.lsp.get_active_clients({ bufnr = bufnr })) do
    if client.server_capabilities.documentSymbolProvider then
      client_found = true
      break
    end
  end
  if not client_found then
    local splits = vim.split(bufname, "/")
    renderer.show_nodes({
      {
        id = "0",
        name = "No client found for " .. splits[#splits],
        path = bufname,
        type = "root",
        children = {},
        extra = { kind = kinds.get_kind(0), search_path = "/" },
      },
    }, state)
    return
  end

  -- client found
  vim.lsp.buf_request_all(
    bufnr,
    "textDocument/documentSymbol",
    { textDocument = vim.lsp.util.make_text_document_params(bufnr) },
    function(resp)
      on_lsp_resp(resp, state)
    end
  )
end

M.setup = function(config)
  filters.setup(config.client_filters)
  kinds.setup(config.custom_kinds, config.kinds)
end

return M
