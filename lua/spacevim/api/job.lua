--=============================================================================
-- job.lua --- Job api based on libuv
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local uv = vim.loop

local M = {}

function M.start(cmd, ...) -- {{{
  local opts = { ... }
  local opt = opts[1] or {}

end
-- }}}

--- @param cmd string|table<string> commands
--- @param opts table job options
--- @return integer
--- keys in opts:
--- cwd: string
--- env: table
function M._run(cmd, opts)
  
end

function M.stop(id) -- {{{
end
-- }}}

function M.send(id, data) -- {{{
end
-- }}}

function M.status(id) -- {{{
end
-- }}}

function M.list() -- {{{
end
-- }}}
function M.info(id) -- {{{
end
-- }}}

function M.chanclose(id, t) -- {{{
end
-- }}}

return M
