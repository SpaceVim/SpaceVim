if vim.b.did_ftp == true then
  return
end

vim.opt_local.cursorline = true
vim.opt_local.modifiable = false
vim.opt_local.buflisted = false
vim.opt_local.syntax = 'zkbrowser'
vim.opt_local.buftype = 'nofile'
vim.opt_local.swapfile = false
vim.opt_local.iskeyword:append(':')
vim.opt_local.iskeyword:append('-')
vim.opt_local.suffixesadd:append('.md')
vim.opt_local.errorformat = '%f:%l: %m'
vim.opt_local.keywordprg = ':ZkHover -preview'
vim.opt_local.tagfunc = 'v:lua.zettelkasten.tagfunc'

local win = require('spacevim.api.vim.window')
local hi = require('spacevim.api.vim.highlight')

require('zettelkasten').add_hover_command()

if vim.fn.mapcheck('[I', 'n') == '' then
  vim.api.nvim_buf_set_keymap(
    0,
    'n',
    '[I',
    '<CMD>lua require("zettelkasten").show_back_references(vim.fn.expand("<cword>"))<CR>',
    { noremap = true, silent = true, nowait = true }
  )
  vim.api.nvim_buf_set_keymap(0, 'n', 'q', '', {
    noremap = true,
    silent = true,
    nowait = true,
    callback = function()
      if vim.fn.tabpagenr('$') > 1 and win.is_last_win() then
        vim.cmd('quit')
        return
      end
      local ok = pcall(function()
        vim.cmd('b#')
      end)

      if not ok then
        vim.cmd('bd')
      end
    end,
  })
  vim.api.nvim_buf_set_keymap(0, 'n', '<C-l>', '', {
    noremap = true,
    silent = true,
    nowait = true,
    callback = function()
      vim.cmd('ZkBrowse')
    end,
  })
  vim.api.nvim_buf_set_keymap(0, 'n', '<LeftRelease>', '', {
    noremap = true,
    silent = true,
    nowait = true,
    callback = function()
      if hi.syntax_at() == 'ZettelKastenTags' then
        vim.cmd('ZkBrowse #' .. vim.fn.expand('<cword>') )

      end
    end,
  })
  vim.api.nvim_buf_set_keymap(0, 'n', '<F2>', '', {
    noremap = true,
    silent = true,
    nowait = true,
    callback = function()
      require('zettelkasten.sidebar').open_tag_tree()
    end,
  })
  vim.api.nvim_buf_set_keymap(0, 'n', '<Enter>', '', {
    noremap = true,
    silent = true,
    nowait = true,
    callback = function()
      vim.cmd('normal 0gf')
    end,
  })
end

local config = require('zettelkasten.config')
if config.zettel_dir ~= '' then
  vim.cmd('lcd ' .. config.zettel_dir)
end
