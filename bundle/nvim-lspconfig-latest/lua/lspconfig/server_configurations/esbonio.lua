local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'python3', '-m', 'esbonio' },
    filetypes = { 'rst' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
https://github.com/swyddfa/esbonio

Esbonio is a language server for [Sphinx](https://www.sphinx-doc.org/en/master/) documentation projects.
The language server can be installed via pip

```
pip install esbonio
```

Since Sphinx is highly extensible you will get best results if you install the language server in the same
Python environment as the one used to build your documentation. To ensure that the correct Python environment
is picked up, you can either launch `nvim` with the correct environment activated.

```
source env/bin/activate
nvim
```

Or you can modify the default `cmd` to include the full path to the Python interpreter.

```lua
require'lspconfig'.esbonio.setup {
  cmd = { '/path/to/virtualenv/bin/python', '-m', 'esbonio' }
}
```

Esbonio supports a number of config values passed as `init_options` on startup, for example.

```lua
require'lspconfig'.esbonio.setup {
  init_options = {
    server = {
      logLevel = "debug"
    },
    sphinx = {
      confDir = "/path/to/docs",
      srcDir = "${confDir}/../docs-src"
    }
}
```

A full list and explanation of the available options can be found [here](https://docs.esbon.io/en/esbonio-language-server-v0.16.4/lsp/getting-started.html?editor=neovim-lspconfig#configuration)
]],
  },
}
