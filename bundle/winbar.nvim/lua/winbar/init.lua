--=============================================================================
-- init.lua --- winbar plugin
-- Copyright 2025 Eric Wong
-- Author: Eric Wong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local default_conf = {
  winbar_seperator = '>',
  excluded_filetypes = {},
}

local function redraw_winbar()
  local file_name = vim.fn.expand('%:t')

  if file_name == '' then
    return
  end

  local value = '%#SpaceVim_winbar#' .. file_name .. ' ' .. default_conf.winbar_seperator

  vim.api.nvim_set_option_value('winbar', value, { scope = 'local' })
end

function M.setup(opt)
  if type(opt) == 'table' then
    default_conf = vim.tbl_deep_extend('force', {}, default_conf, opt)
  end
  local augroup = vim.api.nvim_create_augroup('winbar.nvim', {
    clear = true,
  })
  vim.api.nvim_create_autocmd({ 'WinEnter' }, {
    group = augroup,
    pattern = '*',
    callback = function(e)
      redraw_winbar()
    end,
  })
end

return M
