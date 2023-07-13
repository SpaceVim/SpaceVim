---Utilities function to filter the LSP servers
local utils = require("neo-tree.utils")

---@alias LspRespRaw table<integer, { result: LspRespNode }>
local M = {}

---@alias FilterFn fun(client_name: string): boolean

---Filter clients
---@param filter_type "first" | "all"
---@param filter_fn FilterFn
---@param resp LspRespRaw
---@return table<string, LspRespNode>
local filter_clients = function(filter_type, filter_fn, resp)
  if resp == nil or type(resp) ~= "table" then
    return {}
  end
  filter_fn = filter_fn or function(client_name)
    return true
  end

  local result = {}
  for client_id, client_resp in pairs(resp) do
    local client_name = vim.lsp.get_client_by_id(client_id).name
    if filter_fn(client_name) and client_resp.result ~= nil then
      result[client_name] = client_resp.result
      if filter_type ~= "all" then
        break
      end
    end
  end
  return result
end

---Filter only allowed clients
---@param allow_only string[] the list of clients to keep
---@return FilterFn
local allow_only = function(allow_only)
  return function(client_name)
    return vim.tbl_contains(allow_only, client_name)
  end
end

---Ignore clients
---@param ignore string[] the list of clients to remove
---@return FilterFn
local ignore = function(ignore)
  return function(client_name)
    return not vim.tbl_contains(ignore, client_name)
  end
end

---Main entry point for the filter
---@param resp LspRespRaw
---@return table<string, LspRespNode>
M.filter_resp = function(resp)
  return {}
end

---Setup the filter accordingly to the config
---@see neo-tree-document-symbols-source for more details on options that the filter accepts
---@param cfg_flt "first" | "all" | { type: "first" | "all", fn: FilterFn, allow_only: string[], ignore: string[] }
M.setup = function(cfg_flt)
  local filter_type = "first"
  local filter_fn = nil

  if type(cfg_flt) == "table" then
    if cfg_flt.type == "all" then
      filter_type = "all"
    end

    if cfg_flt.fn ~= nil then
      filter_fn = cfg_flt.fn
    elseif cfg_flt.allow_only then
      filter_fn = allow_only(cfg_flt.allow_only)
    elseif cfg_flt.ignore then
      filter_fn = ignore(cfg_flt.ignore)
    end
  elseif cfg_flt == "all" then
    filter_type = "all"
  end

  M.filter_resp = function(resp)
    return filter_clients(filter_type, filter_fn, resp)
  end
end

return M
