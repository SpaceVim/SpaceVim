--=============================================================================
-- job.lua --- Job api based on libuv
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local uv = vim.loop

local M = {}

local function setup_output(output) -- {{{
  if output == nil then
    return uv.new_pipe(false), nil
  end

  if type(output) == 'function' then
    return uv.new_pipe(false), output
  end

  return nil, nil
end
-- }}}

function M.start(argv, ...) -- {{{
  local opts = { ... }
  local opt = opts[1] or {}

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
