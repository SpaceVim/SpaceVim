local deprecated = {}

deprecated.options = function(opts)
  local messages = {}

  if #messages > 0 then
    table.insert(messages, 1, "Deprecated options. Please see ':help telescope.changelog'")
    vim.api.nvim_err_write(table.concat(messages, "\n \n   ") .. "\n \nPress <Enter> to continue\n")
  end
end

return deprecated
