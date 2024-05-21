local util = require 'lspconfig.util'

local root_files = {
  'hardhat.config.js',
  'hardhat.config.ts',
  'foundry.toml',
  'remappings.txt',
  'truffle.js',
  'truffle-config.js',
  'ape-config.yaml',
}

return {
  default_config = {
    cmd = { 'vscode-solidity-server', '--stdio' },
    filetypes = { 'solidity' },
    root_dir = util.root_pattern(unpack(root_files)) or util.root_pattern('.git', 'package.json'),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/juanfranblanco/vscode-solidity

`vscode-solidity-server` can be installed via `npm`:

```sh
npm install -g vscode-solidity-server
```

`vscode-solidity-server` is a language server for the Solidity language ported from the VSCode "solidity" extension.
]],
    default_config = {
      root_dir = [[root_pattern("]] .. table.concat(root_files, '", "') .. [[", ".git", "package.json")]],
    },
  },
}
