local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'qml-lsp' },
    filetypes = { 'qmljs' },
    root_dir = util.root_pattern '*.qml',
  },
  docs = {
    description = [[
https://invent.kde.org/sdk/qml-lsp

LSP implementation for QML (autocompletion, live linting, etc. in editors)
        ]],
  },
}
