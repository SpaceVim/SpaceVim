local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'lean-language-server', '--stdio', '--', '-M', '4096', '-T', '100000' },
    filetypes = { 'lean3' },
    offset_encoding = 'utf-32',
    root_dir = function(fname)
      fname = util.path.sanitize(fname)
      -- check if inside elan stdlib
      local stdlib_dir
      do
        local _, endpos = fname:find '/lean/library'
        if endpos then
          stdlib_dir = fname:sub(1, endpos)
        end
      end

      return util.root_pattern 'leanpkg.toml'(fname)
        or util.root_pattern 'leanpkg.path'(fname)
        or stdlib_dir
        or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/leanprover/lean-client-js/tree/master/lean-language-server

Lean installation instructions can be found
[here](https://leanprover-community.github.io/get_started.html#regular-install).

Once Lean is installed, you can install the Lean 3 language server by running
```sh
npm install -g lean-language-server
```

Note: that if you're using [lean.nvim](https://github.com/Julian/lean.nvim),
that plugin fully handles the setup of the Lean language server,
and you shouldn't set up `lean3ls` both with it and `lspconfig`.
    ]],
    default_config = {
      root_dir = [[root_pattern("leanpkg.toml") or root_pattern(".git")]],
    },
  },
}
