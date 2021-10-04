local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = 'groovyls'
local bin_name = 'groovy-language-server-all.jar'

configs[name] = {
  default_config = {
    cmd = {
      'java',
      '-jar',
      bin_name,
    },
    filetypes = { 'groovy' },
    root_dir = util.root_pattern '.git' or vim.loop.os_homedir(),
  },
  docs = {
    description = [[
https://github.com/prominic/groovy-language-server.git

Requirements:
 - Linux/macOS (for now)
 - Java 11+

`groovyls` can be installed by following the instructions [here](https://github.com/prominic/groovy-language-server.git#build).

If you have installed groovy language server, you can set the `cmd` custom path as follow:

```lua
require'lspconfig'.groovyls.setup{
    -- Unix
    cmd = { "java", "-jar", "path/to/groovyls/groovy-language-server-all.jar" },
    ...
}
```
]],
    default_config = {
      cmd = {
        'java',
        '-jar',
        bin_name,
      },
      filetypes = { 'groovy' },
      root_dir = [[root_pattern(".git") or vim.loop.os_homedir()]],
    },
  },
}
