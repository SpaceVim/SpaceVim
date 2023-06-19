local util = require 'lspconfig/util'

return {
  default_config = {
    cmd = { 'starlark', '--lsp' },
    filetypes = { 'star', 'bzl', 'BUILD.bazel' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
https://github.com/facebookexperimental/starlark-rust/
The LSP part of `starlark-rust` is not currently documented,
 but the implementation works well for linting.
This gives valuable warnings for potential issues in the code,
but does not support refactorings.

It can be installed with cargo: https://crates.io/crates/starlark
]],
  },
}
