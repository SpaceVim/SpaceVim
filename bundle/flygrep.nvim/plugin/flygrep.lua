--=============================================================================
-- flygrep.lua
-- Copyright 2025 Eric Wong
-- Author: Eric Wong < wsdjeg@outlook.com >
-- URL: https://github.com/wsdjeg/flygrep.nvim
-- License: GPLv3
--=============================================================================

vim.api.nvim_create_user_command('FlyGrep', function(opt)
  require('flygrep').open()
end, {})

require('flygrep').setup()
