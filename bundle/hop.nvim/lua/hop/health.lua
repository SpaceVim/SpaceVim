local M = {}
local hop = require'hop'

-- Initialization check.
--
-- This function will perform checks at initialization to ensure everything will work as expected.
function M.check()
  local health = require'health'

  health.report_start('Ensuring keys are unique')
  local existing_keys = {}
  local had_errors = false
  for i = 0, #hop.opts.keys do
    local key = hop.opts.keys:sub(i, i)

    if existing_keys[key] then
      health.report_error(string.format('key %s appears more than once in opts.keys', key))
      had_errors = true
    else
      existing_keys[key] = true
    end
  end

  if not had_errors then
    health.report_ok('Keys are unique')
  end

  health.report_start('Checking for deprecated features')
  had_errors = false

  if not had_errors then
    health.report_ok('All good')
  end
end

return M
