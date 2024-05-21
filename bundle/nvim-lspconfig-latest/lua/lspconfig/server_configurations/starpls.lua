local util = require 'lspconfig/util'

return {
  default_config = {
    cmd = { 'starpls' },
    filetypes = { 'bzl' },
    root_dir = util.root_pattern('WORKSPACE', 'WORKSPACE.bazel', 'MODULE.bazel'),
  },
  docs = {
    description = [[
https://github.com/withered-magic/starpls

`starpls` is an LSP implementation for Starlark. Installation instructions can be found in the project's README.
]],
  },
}
