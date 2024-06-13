local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'lean', '--server' },
    filetypes = { 'lean' },
    root_dir = function(fname)
      -- check if inside elan stdlib
      local stdlib_dir
      do
        local _, endpos = fname:find(util.path.sep .. util.path.join('lib', 'lean'))
        if endpos then
          stdlib_dir = fname:sub(1, endpos)
        end
      end

      return util.root_pattern('lakefile.lean', 'lean-toolchain', 'leanpkg.toml')(fname)
        or stdlib_dir
        or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/leanprover/lean4

Lean installation instructions can be found
[here](https://leanprover-community.github.io/get_started.html#regular-install).

The Lean 4 language server is built-in with a Lean 4 install
(and can be manually run with, e.g., `lean --server`).

Note: that if you're using [lean.nvim](https://github.com/Julian/lean.nvim),
that plugin fully handles the setup of the Lean language server,
and you shouldn't set up `leanls` both with it and `lspconfig`.
    ]],
    default_config = {
      root_dir = [[root_pattern("lakefile.lean", "lean-toolchain", "leanpkg.toml", ".git")]],
    },
  },
}
