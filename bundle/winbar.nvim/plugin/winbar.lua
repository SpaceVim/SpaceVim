--=============================================================================
-- winbar.lua --- winbar plugin
-- Copyright 2025 Eric Wong
-- Author: Eric Wong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

if vim.fn.exists('+winbar') == 1 then
  require('winbar').setup()
end
