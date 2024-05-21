local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'bzl', 'lsp', 'serve' },
    filetypes = { 'bzl' },
    -- https://docs.bazel.build/versions/5.4.1/build-ref.html#workspace
    root_dir = util.root_pattern('WORKSPACE', 'WORKSPACE.bazel'),
  },
  docs = {
    description = [[
https://bzl.io/

https://docs.stack.build/docs/cli/installation

https://docs.stack.build/docs/vscode/starlark-language-server
]],
    default_config = {
      root_dir = [[root_pattern(".git")]],
    },
  },
}
