--=============================================================================
-- job.lua --- Job api based on libuv
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local uv = vim.loop

local M = {}

-- s:self.start(argv,...)
-- s:self.stop(id)
-- s:self.send(id,data)
-- s:self.status(id)
-- s:self.list()
-- s:self.info(id)
-- s:self.chanclose(id,type)
-- s:self.debug()
function M.start(argv, ...) -- {{{
end
-- }}}

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
