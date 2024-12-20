--=============================================================================
-- record-key.lua --- record key in neovim
-- Copyright 2024 Eric Wong
-- Author: Eric Wong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================
vim.api.nvim_create_user_command('RecordKeyToggle', function(_)
  require('spacevim.plugin.record-key').toggle()
end, {})
