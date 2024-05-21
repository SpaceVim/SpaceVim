local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'matlab-language-server', '--stdio' },
    filetypes = { 'matlab' },
    root_dir = util.find_git_ancestor,
    single_file_support = false,
    settings = {
      MATLAB = {
        indexWorkspace = false,
        installPath = '',
        matlabConnectionTiming = 'onStart',
        telemetry = true,
      },
    },
  },
  docs = {
    description = [[
https://github.com/mathworks/MATLAB-language-server

MATLAB® language server implements the Microsoft® Language Server Protocol for the MATLAB language.
]],
  },
}
