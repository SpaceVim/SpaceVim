local util = require 'lspconfig.util'

return {
  default_config = {
    filetypes = { 'apexcode' },
    root_dir = util.root_pattern 'sfdx-project.json',
    on_new_config = function(config)
      if not config.cmd and config.apex_jar_path then
        config.cmd = {
          'java',
          '-cp',
          config.apex_jar_path,
          '-Ddebug.internal.errors=true',
          '-Ddebug.semantic.errors=' .. tostring(config.apex_enable_semantic_errors or false),
          '-Ddebug.completion.statistics=' .. tostring(config.apex_enable_completion_statistics or false),
          '-Dlwc.typegeneration.disabled=true',
        }
        if config.apex_jvm_max_heap then
          table.insert(config.cmd, '-Xmx' .. config.apex_jvm_max_heap)
        end
        table.insert(config.cmd, 'apex.jorje.lsp.ApexLanguageServerLauncher')
      end
    end,
  },
  docs = {
    description = [[
https://github.com/forcedotcom/salesforcedx-vscode

Language server for Apex.

For manual installation, download the JAR file from the [VSCode
extension](https://github.com/forcedotcom/salesforcedx-vscode/tree/develop/packages/salesforcedx-vscode-apex).

```lua
require'lspconfig'.apex_ls.setup {
  apex_jar_path = '/path/to/apex-jorje-lsp.jar',
  apex_enable_semantic_errors = false, -- Whether to allow Apex Language Server to surface semantic errors
  apex_enable_completion_statistics = false, -- Whether to allow Apex Language Server to collect telemetry on code completion usage
}
```
]],
    default_config = {
      root_dir = [[root_pattern('sfdx-project.json')]],
    },
  },
}
