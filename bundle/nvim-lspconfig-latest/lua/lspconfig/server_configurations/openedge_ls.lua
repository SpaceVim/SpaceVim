local util = require 'lspconfig.util'

return {
  default_config = {
    filetypes = { 'progress' },
    root_dir = util.root_pattern 'openedge-project.json',
    on_new_config = function(config)
      if not config.cmd and config.oe_jar_path then
        config.cmd = {
          'java',
          '--add-opens=java.base/java.lang=ALL-UNNAMED',
          '--add-opens=java.base/java.math=ALL-UNNAMED',
          '--add-opens=java.base/java.util=ALL-UNNAMED',
          '--add-opens=java.base/java.util.concurrent=ALL-UNNAMED',
          '--add-opens=java.base/java.net=ALL-UNNAMED',
          '--add-opens=java.base/java.text=ALL-UNNAMED',
        }
        if config.debug then
          config.cmd[#config.cmd + 1] = '-Dorg.slf4j.simpleLogger.defaultLogLevel=DEBUG'
        end
        config.cmd[#config.cmd + 1] = '-jar'
        config.cmd[#config.cmd + 1] = config.oe_jar_path
        if config.dlc then
          config.cmd[#config.cmd + 1] = '--dlc'
          config.cmd[#config.cmd + 1] = config.dlc
        end
        if config.trace then
          config.cmd[#config.cmd + 1] = '--trace'
        end
      end
    end,
  },
  docs = {
    description = [[
[Language server](https://github.com/vscode-abl/vscode-abl) for Progress OpenEdge ABL.

For manual installation, download abl-lsp.jar from the [VSCode
extension](https://github.com/vscode-abl/vscode-abl/releases/latest).

Configuration

```lua
require('lspconfig').['openedge_ls'].setup {
  oe_jar_path = '/path/to/abl-lsp.jar',
  dlc = '12.2:/path/to/dlc-12.2', -- Version number and OpenEdge root directory (colon separator)
  debug = false, -- Set to true for debug logging
  trace = false -- Set to true for trace logging (REALLY verbose)
}
```
]],
    default_config = {
      root_dir = [[root_pattern('openedge-project.json')]],
    },
  },
}
