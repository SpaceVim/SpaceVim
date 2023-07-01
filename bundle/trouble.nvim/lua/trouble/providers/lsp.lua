local lsp = require("vim.lsp")
local util = require("trouble.util")

---@class Lsp
local M = {}

local function lsp_buf_request(buf, method, params, handler)
  lsp.buf_request(buf, method, params, function(err, m, result)
    handler(err, method == m and result or m)
  end)
end

---@return Item[]
function M.references(win, buf, cb, _options)
  local method = "textDocument/references"
  local params = util.make_position_params(win, buf)
  params.context = { includeDeclaration = true }
  lsp_buf_request(buf, method, params, function(err, result)
    if err then
      util.error("an error happened getting references: " .. err.message)
      return cb({})
    end
    if result == nil or #result == 0 then
      return cb({})
    end
    local ret = util.locations_to_items({ result }, 0)
    cb(ret)
  end)
end

---@return Item[]
function M.implementations(win, buf, cb, _options)
  local method = "textDocument/implementation"
  local params = util.make_position_params(win, buf)
  params.context = { includeDeclaration = true }
  lsp_buf_request(buf, method, params, function(err, result)
    if err then
      util.error("an error happened getting implementation: " .. err.message)
      return cb({})
    end
    if result == nil or #result == 0 then
      return cb({})
    end
    local ret = util.locations_to_items({ result }, 0)
    cb(ret)
  end)
end

---@return Item[]
function M.definitions(win, buf, cb, _options)
  local method = "textDocument/definition"
  local params = util.make_position_params(win, buf)
  params.context = { includeDeclaration = true }
  lsp_buf_request(buf, method, params, function(err, result)
    if err then
      util.error("an error happened getting definitions: " .. err.message)
      return cb({})
    end
    if result == nil or #result == 0 then
      return cb({})
    end
    for _, value in ipairs(result) do
      value.uri = value.targetUri or value.uri
      value.range = value.targetSelectionRange or value.range
    end
    local ret = util.locations_to_items({ result }, 0)
    cb(ret)
  end)
end

---@return Item[]
function M.type_definitions(win, buf, cb, _options)
  local method = "textDocument/typeDefinition"
  local params = util.make_position_params(win, buf)
  lsp_buf_request(buf, method, params, function(err, result)
    if err then
      util.error("an error happened getting type definitions: " .. err.message)
      return cb({})
    end
    if result == nil or #result == 0 then
      return cb({})
    end
    for _, value in ipairs(result) do
      value.uri = value.targetUri or value.uri
      value.range = value.targetSelectionRange or value.range
    end
    local ret = util.locations_to_items({ result }, 0)
    cb(ret)
  end)
end

return M
