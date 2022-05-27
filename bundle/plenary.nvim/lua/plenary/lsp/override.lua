local vim = vim

local M = {}

M._original_functions = {}

--- Override an lsp method default callback
--- @param method string
--- @param new_function function
function M.override(method, new_function)
  if M._original_functions[method] == nil then
    M._original_functions[method] = vim.lsp.callbacks[method]
  end

  vim.lsp.callbacks[method] = new_function
end

--- Get the original method callback
---     useful if you only want to override in some circumstances
---
--- @param method string
function M.get_original_function(method)
  if M._original_functions[method] == nil then
    M._original_functions[method] = vim.lsp.callbacks[method]
  end

  return M._original_functions[method]
end

return M
