local M = {}
local nt = require('spacevim.api.notify')

local log = require('spacevim.logger').derive('format')

function M.msg(msg)
  nt.notify(msg)
end

function M.info(msg)
  log.info(msg)
end

return M
