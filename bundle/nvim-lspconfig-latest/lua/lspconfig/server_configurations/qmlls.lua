local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'qmlls' },
    filetypes = { 'qml', 'qmljs' },
    root_dir = function(fname)
      return util.find_git_ancestor(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/qt/qtdeclarative

LSP implementation for QML (autocompletion, live linting, etc. in editors),
        ]],
  },
}
