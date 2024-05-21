local util = require 'lspconfig.util'

local root_files = {
  'pyproject.toml',
  'ruff.toml',
  '.ruff.toml',
}

return {
  default_config = {
    cmd = { 'ruff', 'server', '--preview' },
    filetypes = { 'python' },
    root_dir = util.root_pattern(unpack(root_files)) or util.find_git_ancestor(),
    single_file_support = true,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/astral-sh/ruff

A Language Server Protocol implementation for Ruff, an extremely fast Python linter and code formatter, written in Rust. It can be installed via pip.

```sh
pip install ruff
```

_Requires Ruff v0.3.3 or later._

This is the new Rust-based version of the original `ruff-lsp` implementation. It's currently in alpha, meaning that some features are under development. Currently, the following capabilities are supported:

1. Diagnostics
2. Code actions
3. Formatting
4. Range Formatting

Please note that the `ruff-lsp` server will continue to be maintained until further notice.

  ]],
    root_dir = [[root_pattern("pyproject.toml", "ruff.toml", ".ruff.toml", ".git")]],
  },
}
