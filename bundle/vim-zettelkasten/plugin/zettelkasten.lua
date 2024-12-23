--=============================================================================
-- zettelkasten.lua --- init plugin for zk
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================
vim.cmd([[command ZkNew :lua require('zettelkasten').zknew({})]])

vim.cmd([[command ZkListTemplete :Telescope zettelkasten_template]])
vim.cmd([[command ZkListTags :Telescope zettelkasten_tags]])
vim.cmd([[command ZkListNotes :Telescope zettelkasten]])

vim.api.nvim_create_user_command('ZkBrowse', function(opt)
  require('zettelkasten.browser').browse(opt.fargs)
end, { nargs = '*' })
_G.zettelkasten = {
  tagfunc = require('zettelkasten').tagfunc,
  completefunc = require('zettelkasten').completefunc,
  zknew = require('zettelkasten').zknew,
  zkbrowse = function()
    vim.cmd('edit zk://browser')
  end,
}
