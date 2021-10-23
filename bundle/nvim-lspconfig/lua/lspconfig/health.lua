local M = {}
function M.check_health()
  local configs = require 'lspconfig/configs'

  for _, top_level_config in pairs(configs) do
    -- Only check configs that have a make_config function.
    if not (top_level_config.make_config == nil) then
      -- the folder needs to exist
      local config = top_level_config.make_config '.'

      local status, cmd = pcall(vim.lsp._cmd_parts, config.cmd)
      if not status then
        vim.fn['health#report_error'](string.format('%s: config.cmd error, %s', config.name, cmd))
      else
        if not (vim.fn.executable(cmd) == 1) then
          vim.fn['health#report_error'](string.format('%s: The given command %q is not executable.', config.name, cmd))
        else
          vim.fn['health#report_info'](string.format('%s: configuration checked.', config.name))
        end
      end
    end
  end
end

return M
