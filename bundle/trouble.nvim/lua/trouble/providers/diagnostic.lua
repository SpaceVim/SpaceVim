local util = require("trouble.util")

---@class Lsp
local M = {}

---@param options TroubleOptions
---@return Item[]
function M.diagnostics(_, buf, cb, options)
  if options.mode == "workspace_diagnostics" then
    buf = nil
  end

  local items = {}

  if vim.diagnostic then
    local diags = vim.diagnostic.get(buf, { severity = options.severity })
    for _, item in ipairs(diags) do
      table.insert(items, util.process_item(item))
    end
  else
    ---@diagnostic disable-next-line: deprecated
    local diags = buf and { [buf] = vim.lsp.diagnostic.get(buf) } or vim.lsp.diagnostic.get_all()
    items = util.locations_to_items(diags, 1)
  end

  cb(items)
end

function M.get_signs()
  local signs = {}
  for _, v in pairs(util.severity) do
    if v ~= "Other" then
      -- pcall to catch entirely unbound or cleared out sign hl group
      local status, sign = pcall(function()
        return vim.trim(vim.fn.sign_getdefined(util.get_severity_label(v, "Sign"))[1].text)
      end)
      if not status then
        sign = v:sub(1, 1)
      end
      signs[string.lower(v)] = sign
    end
  end
  return signs
end

return M
