--!/usr/bin/lua
local M = {}


function M.t(str)
      -- https://github.com/neovim/neovim/issues/17369
  local ret = vim.api.nvim_replace_termcodes(str, false, true, true):gsub("\128\254X", "\128")
  return ret
end

return M
