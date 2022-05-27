local kind = require("cmp").lsp.CompletionItemKind.Snippet
local fn = vim.fn

local M = {}

local Source = {}
M.Source = Source

function Source.new()
  return setmetatable({}, { __index = Source })
end

function Source:is_available()
  return vim.g.loaded_neosnippet
end

function Source:get_debug_name()
  return "neosnippet"
end

function Source:complete(_, callback)
  -- not impl cache for filetype
  local snippets = fn["neosnippet#helpers#get_completion_snippets"]()
  local items = vim.tbl_map(function(s)
    return { label = s.word, kind = kind }
  end, snippets)
  callback(items)
end

return M
