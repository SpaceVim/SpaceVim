local M = {}

local color_templete = require('flygrep.config').color_templete
local hi = require('spacevim.api.vim.highlight')

function M.def_higroup()
  vim.api.nvim_set_hl(0, 'FlyGrep_a', color_templete.a)
  vim.api.nvim_set_hl(0, 'FlyGrep_b', color_templete.b)
  hi.hi_separator('FlyGrep_a', 'FlyGrep_b')
  hi.hi_separator('FlyGrep_b', 'Normal')
end

return M
