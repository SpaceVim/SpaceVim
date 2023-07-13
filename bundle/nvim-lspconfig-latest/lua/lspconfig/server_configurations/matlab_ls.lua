local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'matlab-language-server', '--stdio' },
    filetypes = { 'matlab' },
    root_dir = util.find_git_ancestor,
    single_file_support = false,
    settings = {
      matlab = {
        indexWorkspace = false,
        installPath = '',
        matlabConnectionTiming = 'onStart',
        telemetry = true,
      },
    },
    handlers = {
      ['workspace/configuration'] = function(_, _, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        return { client.config.settings.matlab }
      end,
    },
  },
  docs = {
    description = [[
https://github.com/mathworks/MATLAB-language-server

MATLAB® language server implements the Microsoft® Language Server Protocol for the MATLAB language.
]],
  },
}
