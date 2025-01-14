--=============================================================================
-- init.lua --- winbar plugin
-- Copyright 2025 Eric Wong
-- Author: Eric Wong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local default_conf = {
  winbar_seperator = '',
  excluded_filetypes = {'defx'},
}

local highlight = require('spacevim.api.vim.highlight')
local function def_colors()
  local name = vim.g.colors_name or 'gruvbox'

  local t

  if vim.g.spacevim_custom_color_palette and #vim.g.spacevim_custom_color_palette > 0 then
    t = vim.g.spacevim_custom_color_palette
  else
    local ok = pcall(function()
      t = vim.fn['SpaceVim#mapping#guide#theme#' .. name .. '#palette']()
    end)

    if not ok then
      t = vim.fn['SpaceVim#mapping#guide#theme#gruvbox#palette']()
    end
  end
  vim.api.nvim_set_hl(0, 'SpaceVim_winbar', {
    fg = t[2][1],
    bg = t[2][2],
    ctermfg = t[2][4],
    ctermbg = t[2][3],
  })
  highlight.hi_separator('SpaceVim_winbar', 'Normal')
end

local function redraw_winbar()
  local file_name = vim.fn.expand('%:t')

  if file_name == '' then
    return
  end

  local value = '%#SpaceVim_winbar#' .. file_name .. ' %#SpaceVim_winbar_Normal#' .. default_conf.winbar_seperator .. '%#Normal#'

  vim.api.nvim_set_option_value('winbar', value, { scope = 'local' })
end

function M.setup(opt)
  if type(opt) == 'table' then
    default_conf = vim.tbl_deep_extend('force', {}, default_conf, opt)
  end
  def_colors()
  local augroup = vim.api.nvim_create_augroup('winbar.nvim', {
    clear = true,
  })
  vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
    group = augroup,
    pattern = '*',
    callback = function(e)
      redraw_winbar()
    end,
  })
end

return M
